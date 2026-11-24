-- Match the tested version, symbol and timeframe rather than reusing a report from a different pair.
-- name: MarketOpportunityReport :one
SELECT r.id FROM reports r
WHERE r.spec->>'rule_version_id' = @rule_id::text AND r.spec->>'timeframe' = '1h'
  AND EXISTS (
    SELECT 1 FROM datasets d WHERE d.symbol = @symbol AND d.timeframe = '1h'
      AND (r.spec->'dataset_ids') ? d.id
  )
ORDER BY r.created_at DESC, r.id
LIMIT 1;

-- name: InsertMarketOpportunity :exec
INSERT INTO market_opportunities (
    symbol, rule_version_id, report_id, spec_revision, candle_closed_at, observed_at,
    expires_at, reference_close, reason, snapshot, snapshot_sha256
)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
ON CONFLICT (rule_version_id, symbol, candle_closed_at) DO NOTHING;

-- name: MarketOpportunity :one
SELECT id, report_id, candle_closed_at, observed_at, expires_at, reference_close, reason
FROM market_opportunities
WHERE rule_version_id = $1 AND symbol = $2 AND candle_closed_at = $3;

-- name: RecentMarketOpportunities :many
SELECT o.id, o.symbol, o.rule_version_id, v.title AS rule_title, o.report_id,
       o.candle_closed_at, o.observed_at, o.expires_at, o.reference_close, o.reason
FROM market_opportunities o
JOIN strategy_rule_versions v ON v.id = o.rule_version_id
ORDER BY o.id DESC
LIMIT 25;
