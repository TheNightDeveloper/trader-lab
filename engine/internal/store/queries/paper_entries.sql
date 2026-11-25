-- Every reservation, cancellation or fill serializes on this account row.
-- name: LockPaperAccount :exec
SELECT id FROM paper_accounts WHERE id = $1 FOR UPDATE;

-- name: MovePaperCash :exec
UPDATE paper_accounts
SET cash_available = cash_available + @available_delta::bigint,
    cash_reserved = cash_reserved + @reserved_delta::bigint,
    revision = revision + 1
WHERE id = @id;

-- name: PaperExposure :one
SELECT coalesce(sum(exposure_bound), 0)::bigint AS exposure,
       coalesce(sum(loss_bound), 0)::bigint AS open_loss,
       count(*)::int AS slots,
       coalesce(bool_or(symbol = @symbol), false)::boolean AS symbol_busy
FROM paper_entries e
WHERE e.account_id = @account_id AND (e.state IN (1, 2) OR EXISTS (
    SELECT 1 FROM paper_positions p WHERE p.entry_id = e.id
));

-- name: InsertPaperEntry :one
INSERT INTO paper_entries (account_id, opportunity_id, plan_hash, symbol, confirmed_at,
                           expires_at, next_open_at, quantity, reserved_cash, exposure_bound, loss_bound)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING *;

-- name: PaperEntryForOpportunity :one
SELECT * FROM paper_entries WHERE account_id = $1 AND opportunity_id = $2;

-- name: ReadPaperEntry :one
SELECT * FROM paper_entries WHERE id = $1 AND account_id = $2;

-- name: RecentPaperEntries :many
SELECT * FROM paper_entries WHERE account_id = $1 ORDER BY id DESC LIMIT 30;

-- name: PendingPaperEntries :many
SELECT id FROM paper_entries e WHERE account_id = $1
  AND (state IN (1, 2) OR EXISTS (SELECT 1 FROM paper_positions p WHERE p.entry_id = e.id))
ORDER BY id;

-- name: UpdatePaperEntry :one
UPDATE paper_entries SET state = $2, filled_quantity = $3, reserved_cash = $4, next_open_at = $5
WHERE id = $1 RETURNING *;

-- Only a candle recorded as available before the entry expired can produce a fill.
-- name: NextPaperCandle :one
SELECT open_time, close_time, available_at, revision, o, h, l, c, volume
FROM candles WHERE symbol = @symbol AND source = 'rest'
  AND open_time >= @next_open AND open_time < @cutoff AND available_at < @expiry AND available_at <= @cutoff
ORDER BY open_time, revision DESC LIMIT 1;

-- name: AddPaperPosition :exec
INSERT INTO paper_positions (entry_id, quantity, cost_basis, next_open_at) VALUES ($1, $2, $3, $4)
ON CONFLICT (entry_id) DO UPDATE SET quantity = paper_positions.quantity + EXCLUDED.quantity,
    cost_basis = paper_positions.cost_basis + EXCLUDED.cost_basis,
    next_open_at = GREATEST(paper_positions.next_open_at, EXCLUDED.next_open_at);

-- name: ReadPaperPosition :one
SELECT * FROM paper_positions WHERE entry_id = $1;

-- name: AdvancePaperPosition :exec
UPDATE paper_positions SET next_open_at = $2 WHERE entry_id = $1;

-- name: RemovePaperPosition :exec
DELETE FROM paper_positions WHERE entry_id = $1;

-- name: ListPaperPositions :many
SELECT p.entry_id, e.symbol, p.quantity, p.cost_basis
FROM paper_positions p JOIN paper_entries e ON e.id = p.entry_id
WHERE e.account_id = $1 ORDER BY p.entry_id;

-- name: InsertPaperExecutionEvent :one
INSERT INTO paper_execution_events (entry_id, kind, recorded_at, quantity, reference,
                                    fill_price, fee, cash, candle_open_at, candle_revision, realized_pnl)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING id;

-- name: PaperExecutionEvents :many
SELECT * FROM paper_execution_events WHERE entry_id = $1 ORDER BY id;
