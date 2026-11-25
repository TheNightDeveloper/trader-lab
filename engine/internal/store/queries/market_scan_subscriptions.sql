-- name: EnableMarketScan :execrows
INSERT INTO market_scan_subscriptions (symbol, rule_version_id, report_id)
VALUES ($1, $2, $3)
ON CONFLICT (symbol) DO UPDATE SET symbol = EXCLUDED.symbol
WHERE market_scan_subscriptions.rule_version_id = EXCLUDED.rule_version_id;

-- name: PauseMarketScan :exec
DELETE FROM market_scan_subscriptions WHERE symbol = $1 AND rule_version_id = $2;

-- name: ListMarketScans :many
SELECT s.symbol, s.rule_version_id, v.title AS rule_title, s.last_closed_at, s.last_state
FROM market_scan_subscriptions s JOIN strategy_rule_versions v ON v.id = s.rule_version_id
ORDER BY s.symbol;

-- name: DueMarketScans :many
SELECT symbol FROM market_scan_subscriptions
WHERE symbol = ANY(@symbols::text[])
  AND (last_closed_at IS NULL OR last_closed_at < @closed_at
       OR (last_closed_at = @closed_at AND last_state = 3))
ORDER BY symbol;

-- The worker claims the current row again after acquiring its research slot.
-- name: ClaimMarketScan :one
SELECT * FROM market_scan_subscriptions
WHERE symbol = @symbol
  AND (last_closed_at IS NULL OR last_closed_at < @closed_at
       OR (last_closed_at = @closed_at AND last_state = 3))
FOR UPDATE SKIP LOCKED;

-- name: RecordMarketScan :exec
UPDATE market_scan_subscriptions SET last_closed_at = @closed_at, last_state = @state
WHERE symbol = @symbol;
