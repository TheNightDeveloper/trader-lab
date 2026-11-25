-- Reconcile book projections with the balanced ledger and the immutable trade events.
-- Numeric SUM keeps the audit exact even when lifetime turnover exceeds one bigint.
-- name: ReconcilePaperBook :one
WITH account AS (
    SELECT * FROM paper_accounts WHERE id = @account_id
), holdings AS (
    SELECT p.entry_id, i.base AS asset, p.quantity, p.cost_basis
    FROM paper_positions p JOIN paper_entries e ON e.id = p.entry_id
    JOIN instruments i ON i.symbol = e.symbol WHERE e.account_id = @account_id
), posted AS (
    SELECT asset, source, destination, amount FROM paper_postings WHERE account_id = @account_id
), cash AS (
    SELECT coalesce(sum(amount * ((destination = 'available')::int - (source = 'available')::int)), 0) AS available,
           coalesce(sum(amount * ((destination = 'reserved')::int - (source = 'reserved')::int)), 0) AS reserved,
           coalesce(sum(amount) FILTER (WHERE destination = 'fees'), 0) AS fees
    FROM posted WHERE asset = 'USDT'
), base_posted AS (
    SELECT asset, sum(amount * ((destination = 'position')::int - (source = 'position')::int)) AS quantity
    FROM posted WHERE destination = 'position' OR source = 'position' GROUP BY asset
), base_held AS (
    SELECT asset, sum(quantity) AS quantity FROM holdings GROUP BY asset
), events AS (
    SELECT ev.* FROM paper_execution_events ev JOIN paper_entries e ON e.id = ev.entry_id
    WHERE e.account_id = @account_id
), entry_totals AS (
    SELECT entry_id,
           sum(quantity) FILTER (WHERE kind = 'entry_fill') AS bought,
           sum(quantity) FILTER (WHERE candle_open_at IS NOT NULL AND kind <> 'entry_fill') AS sold,
           sum(cash) FILTER (WHERE kind = 'entry_fill') AS spent,
           sum(cash::numeric - realized_pnl) FILTER (WHERE candle_open_at IS NOT NULL AND kind <> 'entry_fill') AS released_basis
    FROM events GROUP BY entry_id
), position_checks AS (
    SELECT coalesce(bool_and(e.filled_quantity = coalesce(t.bought, 0)
           AND coalesce(h.quantity, 0) = coalesce(t.bought, 0) - coalesce(t.sold, 0)
           AND coalesce(h.cost_basis, 0) = coalesce(t.spent, 0) - coalesce(t.released_basis, 0)), true) AS ok
    FROM paper_entries e LEFT JOIN entry_totals t ON t.entry_id = e.id
    LEFT JOIN holdings h ON h.entry_id = e.id WHERE e.account_id = @account_id
)
SELECT (cash.available = account.cash_available AND cash.reserved = account.cash_reserved)::boolean AS cash_matches,
       (account.cash_reserved = (SELECT coalesce(sum(e.reserved_cash), 0) FROM paper_entries e WHERE e.account_id = @account_id))::boolean AS reservations_match,
       (position_checks.ok AND NOT EXISTS (
           SELECT 1 FROM base_posted p FULL JOIN base_held h USING (asset)
           WHERE coalesce(p.quantity, 0) <> coalesce(h.quantity, 0)
       ))::boolean AS positions_match,
       (cash.fees = (SELECT coalesce(sum(fee), 0) FROM events)
        AND cash.available + cash.reserved = account.initial_capital + (
            SELECT coalesce(sum(CASE WHEN ev.kind = 'entry_fill' THEN -ev.cash ELSE ev.cash END), 0)
            FROM events ev WHERE ev.candle_open_at IS NOT NULL
        ))::boolean AS events_match,
       (SELECT coalesce(max(id), 0) FROM events)::bigint AS last_event_id
FROM account, cash, position_checks;
