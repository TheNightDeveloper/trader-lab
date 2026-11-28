-- name: ReadDailyReviewStatus :one
SELECT * FROM daily_review_status WHERE singleton;

-- name: SetDailyReviewReminder :one
UPDATE daily_review_status SET reminder_enabled = $1 WHERE singleton RETURNING *;

-- name: MarkDailyReviewRead :one
UPDATE daily_review_status
SET reviewed_day = greatest(reviewed_day, @day_start::timestamptz)
WHERE singleton RETURNING *;

-- A day retains expired observations across midnight while bounding each preview.
-- name: DailyReviewOpportunities :many
WITH ranked AS (
    SELECT o.id, o.symbol, o.rule_version_id, o.report_id, o.candle_closed_at, o.observed_at,
           o.expires_at, o.reference_close, o.reason, (o.expires_at <= @as_of) AS expired,
           count(*) OVER status AS total,
           row_number() OVER (status ORDER BY o.observed_at DESC, o.id DESC) AS rank
    FROM market_opportunities o
    WHERE o.expires_at >= @day_start AND o.observed_at <= @as_of
    WINDOW status AS (PARTITION BY (o.expires_at <= @as_of))
)
SELECT r.*, v.title AS rule_title
FROM ranked r JOIN strategy_rule_versions v ON v.id = r.rule_version_id
WHERE r.rank <= 5
ORDER BY r.expired, r.rank;

-- name: DailyReviewEvents :many
SELECT symbol, kind, detected_at, detail FROM quality_issues
WHERE symbol = ANY(@symbols::text[]) AND detected_at BETWEEN @day_start AND @as_of
ORDER BY detected_at DESC, id DESC
LIMIT 5;
