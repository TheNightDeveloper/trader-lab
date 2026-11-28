-- Serialize admission across processes, without holding the lock during inference.
-- name: LockAssistantBudget :exec
SELECT pg_advisory_xact_lock(314159, 4);

-- name: InterruptAssistantRuns :exec
UPDATE assistant_runs SET status = 'interrupted'
WHERE status = 'running' AND started_at <= $1;

-- name: ReusableAssistantRun :one
SELECT * FROM assistant_runs
WHERE opportunity_id = $1 AND snapshot_sha256 = $2 AND model = $3 AND prompt_version = $4
    AND status IN ('running', 'succeeded')
ORDER BY id DESC LIMIT 1;

-- name: CountAssistantRuns :one
SELECT count(*) FROM assistant_runs WHERE started_at >= @day_start AND started_at < @day_end;

-- name: ReserveAssistantRun :one
INSERT INTO assistant_runs (opportunity_id, snapshot_sha256, model, prompt_version, started_at)
VALUES ($1, $2, $3, $4, $5) RETURNING id;

-- name: FinishAssistantRun :execrows
UPDATE assistant_runs SET status = $2, focus = $3, input_tokens = $4, output_tokens = $5, latency_ms = $6
WHERE id = $1 AND status = 'running';
