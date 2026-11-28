-- Serialize admission across processes, without holding the lock during inference.
-- name: LockAssistantBudget :exec
SELECT pg_advisory_xact_lock(314159, 4);

-- name: InterruptAssistantRuns :exec
UPDATE assistant_runs SET status = 'interrupted'
WHERE status = 'running' AND started_at <= $1;

-- name: ReusableAssistantRun :one
SELECT * FROM assistant_runs
WHERE coalesce(opportunity_id, 0) = @opportunity_id::bigint
    AND evidence_sha256 = @evidence_sha256 AND model = @model AND prompt_version = @prompt_version
    AND status IN ('running', 'succeeded')
    AND (NOT rule_draft OR status = 'running')
ORDER BY id DESC LIMIT 1;

-- name: CountAssistantRuns :one
SELECT count(*) FROM assistant_runs WHERE started_at >= @day_start AND started_at < @day_end;

-- name: ReserveAssistantRun :one
INSERT INTO assistant_runs (opportunity_id, report_ids, evidence_sha256, model, prompt_version, started_at, rule_draft)
VALUES (nullif(@opportunity_id::bigint, 0), sqlc.narg(report_ids)::text[], @evidence_sha256, @model, @prompt_version, @started_at, @rule_draft) RETURNING id;

-- name: FinishAssistantRun :execrows
UPDATE assistant_runs SET status = $2, focus = $3, input_tokens = $4, output_tokens = $5, latency_ms = $6
WHERE id = $1 AND status = 'running';
