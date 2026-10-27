-- name: InsertReport :exec
INSERT INTO reports (id, title, spec, split, evaluation, holdout, oos_net, oos_return, closed_trades, verdict, tone)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);

-- name: GetReport :one
SELECT * FROM reports WHERE id = $1;

-- name: ListReports :many
SELECT r.id, r.created_at, r.title, r.oos_net, r.oos_return, r.closed_trades, r.verdict, r.tone,
       (SELECT count(*) FROM holdout_views v WHERE v.report_id = r.id) AS holdout_views
FROM reports r
ORDER BY r.created_at DESC, r.id
LIMIT $1 OFFSET $2;

-- name: CountReports :one
SELECT count(*) FROM reports;

-- name: CopyTrades :copyfrom
INSERT INTO trades (report_id, run, seq, instrument, opened_at, closed_at, qty, entry_ref, exit_ref, gross,
                    slippage, fees, net, exit_reason, ambiguous_bars, open_qty, mark_value)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);

-- name: CopyFills :copyfrom
INSERT INTO fills (report_id, run, seq, decision_id, at, instrument, side, kind, qty, ref_price, price, quote,
                   ref_value, value, slippage, fee, ref_value_usdt, slippage_usdt, fee_usdt, ambiguous)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);

-- name: CopyDecisions :copyfrom
INSERT INTO decisions (report_id, run, id, at, input_symbol, input_bar_open, instrument, target, stop_loss,
                       take_profit, reason, model_id, recipe_version, outcome, detail)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);

-- name: ListTrades :many
SELECT * FROM trades WHERE report_id = $1 AND run = $2 ORDER BY seq LIMIT $3 OFFSET $4;

-- name: CountTrades :one
SELECT count(*) FROM trades WHERE report_id = $1 AND run = $2;

-- name: AllTrades :many
SELECT * FROM trades WHERE report_id = $1 AND run = $2 ORDER BY seq;

-- name: ListDecisions :many
SELECT * FROM decisions WHERE report_id = $1 AND run = $2 ORDER BY id LIMIT $3 OFFSET $4;

-- name: CountDecisions :one
SELECT count(*) FROM decisions WHERE report_id = $1 AND run = $2;

-- name: AllDecisions :many
SELECT * FROM decisions WHERE report_id = $1 AND run = $2 ORDER BY id;

-- name: AllFills :many
SELECT * FROM fills WHERE report_id = $1 AND run = $2 ORDER BY seq;

-- name: InsertHoldoutView :exec
INSERT INTO holdout_views (report_id) VALUES ($1);

-- name: CountHoldoutViews :one
SELECT count(*) FROM holdout_views WHERE report_id = $1;
