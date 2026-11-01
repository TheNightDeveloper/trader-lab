-- name: UpsertAlgorithm :exec
INSERT INTO algorithms (id, family, description) VALUES ($1, $2, $3)
ON CONFLICT (id) DO UPDATE SET family = EXCLUDED.family, description = EXCLUDED.description;

-- name: LatestAlgorithmVersion :one
SELECT * FROM algorithm_versions WHERE algorithm_id = $1 ORDER BY version DESC LIMIT 1;

-- name: InsertAlgorithmVersion :exec
INSERT INTO algorithm_versions (id, algorithm_id, version, content_hash, definition, state)
VALUES ($1, $2, $3, $4, $5, $6);

-- name: GetAlgorithmVersion :one
SELECT * FROM algorithm_versions WHERE id = $1;

-- name: ListAlgorithms :many
SELECT * FROM algorithms ORDER BY id;

-- name: ListAlgorithmVersions :many
SELECT * FROM algorithm_versions WHERE algorithm_id = $1 ORDER BY version DESC;

-- name: SetVersionState :exec
UPDATE algorithm_versions SET state = $2 WHERE id = $1;

-- name: InsertLifecycleEvent :exec
INSERT INTO lifecycle_events (version_id, from_state, to_state, note, actor) VALUES ($1, $2, $3, $4, $5);

-- name: ListLifecycleEvents :many
SELECT * FROM lifecycle_events WHERE version_id = $1 ORDER BY at DESC, id DESC;

-- name: InsertExperiment :exec
INSERT INTO experiments (id, name, definition, status) VALUES ($1, $2, $3, 'running');

-- name: GetExperiment :one
SELECT * FROM experiments WHERE id = $1;

-- name: ListExperiments :many
SELECT * FROM experiments ORDER BY created_at DESC, id LIMIT $1 OFFSET $2;

-- name: CountExperiments :one
SELECT count(*) FROM experiments;

-- name: SetExperimentStatus :execrows
UPDATE experiments SET status = @to_status,
    finished_at = CASE WHEN @to_status = 'cancelled' THEN now() ELSE finished_at END
WHERE id = @id AND status = ANY(@from_statuses::text[]);

-- Moves a running experiment with nothing left to run into finalizing (once).
-- name: BeginFinalize :many
UPDATE experiments e SET status = 'finalizing'
WHERE e.status = 'running'
  AND NOT EXISTS (SELECT 1 FROM attempts a WHERE a.experiment_id = e.id AND a.status IN ('queued', 'running'))
RETURNING e.id;

-- name: ListFinalizing :many
SELECT id FROM experiments WHERE status = 'finalizing' ORDER BY created_at;

-- name: FinishExperiment :exec
UPDATE experiments SET status = @status, result = @result, error = @error, finished_at = now()
WHERE id = @id AND status = 'finalizing';

-- name: CopyAttempts :copyfrom
INSERT INTO attempts (experiment_id, seq, candidate, params, dataset_id, symbol, status)
VALUES ($1, $2, $3, $4, $5, $6, $7);

-- Claims the next queued attempt of any running experiment (oldest first).
-- name: ClaimAttempt :one
UPDATE attempts a SET status = 'running', started_at = now(), runs = a.runs + 1, claim_token = @claim_token
FROM (
    SELECT at.experiment_id, at.seq
    FROM attempts at JOIN experiments e ON e.id = at.experiment_id
    WHERE at.status = 'queued' AND e.status = 'running'
    ORDER BY e.created_at, at.experiment_id, at.seq
    LIMIT 1
    FOR UPDATE OF at SKIP LOCKED
) n
WHERE a.experiment_id = n.experiment_id AND a.seq = n.seq
RETURNING a.*;

-- Re-read after the worker registers its cancellation handler. Cancelling before
-- registration is still observed durably, even if the notification was missed.
-- name: GetClaimedAttempt :one
SELECT a.* FROM attempts a JOIN experiments e ON e.id = a.experiment_id
WHERE a.experiment_id = @experiment_id AND a.seq = @seq AND a.claim_token = @claim_token
  AND a.status = 'running' AND e.status IN ('running', 'paused');

-- name: CompleteAttempt :exec
UPDATE attempts SET status = 'done', metrics = @metrics, eligible = @eligible, violations = @violations,
    cache = @cache, cache_key = @cache_key, finished_at = now()
WHERE experiment_id = @experiment_id AND seq = @seq AND status = 'running' AND claim_token = @claim_token
  AND EXISTS (SELECT 1 FROM experiments e WHERE e.id = attempts.experiment_id AND e.status IN ('running', 'paused'));

-- name: EndAttempt :exec
UPDATE attempts SET status = @status, failure = @failure, finished_at = now()
WHERE experiment_id = @experiment_id AND seq = @seq AND status = 'running' AND claim_token = @claim_token;

-- With the exclusive scheduler session held, recover dead claims. Paused work
-- stays queued, and terminal experiments cannot regain runnable attempts.
-- name: RequeueRunning :execrows
UPDATE attempts a SET
    status = CASE WHEN e.status IN ('running', 'paused') THEN 'queued' ELSE 'cancelled' END,
    failure = CASE WHEN e.status IN ('running', 'paused') THEN '' ELSE 'بازیابی: آزمایش پایان یافته است' END,
    finished_at = CASE WHEN e.status IN ('running', 'paused') THEN NULL ELSE now() END,
    claim_token = ''
FROM experiments e
WHERE e.id = a.experiment_id
  AND (a.status = 'running' OR (a.status = 'queued' AND e.status NOT IN ('running', 'paused')));

-- name: CancelExperimentAttempts :execrows
UPDATE attempts SET status = 'cancelled', failure = @failure, finished_at = now(), claim_token = ''
WHERE experiment_id = @experiment_id AND status IN ('queued', 'running');

-- name: CancelQueued :execrows
UPDATE attempts SET status = 'cancelled', failure = @failure, finished_at = now()
WHERE experiment_id = @experiment_id AND status = 'queued';

-- name: AttemptCounts :many
SELECT status, count(*)::int AS n FROM attempts WHERE experiment_id = $1 GROUP BY status ORDER BY status;

-- name: CacheHits :one
SELECT count(*) FILTER (WHERE cache = 'hit')::int AS hits, count(*) FILTER (WHERE cache <> '')::int AS looked
FROM attempts WHERE experiment_id = $1;

-- name: ListAttempts :many
SELECT * FROM attempts
WHERE experiment_id = @experiment_id AND (sqlc.narg(status)::text IS NULL OR status = sqlc.narg(status))
ORDER BY seq DESC
LIMIT @lim OFFSET @off;

-- name: CountAttempts :one
SELECT count(*) FROM attempts
WHERE experiment_id = @experiment_id AND (sqlc.narg(status)::text IS NULL OR status = sqlc.narg(status));

-- name: AllAttempts :many
SELECT * FROM attempts WHERE experiment_id = $1 ORDER BY seq;

-- name: ListStartedExperiments :many
SELECT id, definition, created_at FROM experiments WHERE status = 'running';

-- name: GetRunCache :one
SELECT metrics FROM run_cache WHERE key = $1;

-- name: PutRunCache :exec
INSERT INTO run_cache (key, metrics) VALUES ($1, $2) ON CONFLICT (key) DO NOTHING;

-- name: ReportExists :one
SELECT EXISTS (SELECT 1 FROM reports WHERE id = $1);
