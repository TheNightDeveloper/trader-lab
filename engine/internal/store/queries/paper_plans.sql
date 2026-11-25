-- name: InitializePaperAccount :execrows
INSERT INTO paper_accounts (id, created_at, initial_capital, cash_available)
VALUES ($1, $2, $3, $3)
ON CONFLICT (id) DO NOTHING;

-- name: InsertPaperPolicy :exec
INSERT INTO paper_policy_versions (account_id, revision, effective_at, max_loss, max_open_loss,
                                  max_exposure, fee_ppm, slippage_ppm, max_cost_ppm, entry_drift_ppm)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

-- name: InsertPaperPosting :exec
INSERT INTO paper_postings (account_id, event_key, leg, recorded_at, asset, source, destination, amount)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8);

-- name: ReadPaperAccount :one
SELECT a.*, p.effective_at, p.max_loss, p.max_open_loss, p.max_exposure,
       p.fee_ppm, p.slippage_ppm, p.max_cost_ppm, p.entry_drift_ppm
FROM paper_accounts a JOIN paper_policy_versions p ON (p.account_id, p.revision) = (a.id, a.policy_revision)
WHERE a.id = $1;

-- name: PaperOpportunity :one
SELECT symbol, rule_version_id, report_id, spec_revision, candle_closed_at, observed_at,
       expires_at, reference_close, snapshot_sha256
FROM market_opportunities WHERE id = $1;

-- name: StorePaperPlan :exec
INSERT INTO paper_trade_plans (hash, account_id, opportunity_id, expires_at, body)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (hash) DO NOTHING;

-- name: LoadPaperPlan :one
SELECT body FROM paper_trade_plans WHERE hash = $1;
