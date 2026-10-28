-- name: InsertArtifact :exec
INSERT INTO model_artifacts (id, algorithm_id, recipe_hash, as_of, cycle_id, body)
VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT (id) DO NOTHING;

-- name: GetArtifact :one
SELECT * FROM model_artifacts WHERE id = $1;

-- name: ListArtifacts :many
SELECT * FROM model_artifacts WHERE algorithm_id = $1 ORDER BY created_at DESC, id LIMIT $2;

-- name: GetAlgorithm :one
SELECT * FROM algorithms WHERE id = $1;

-- name: SetActiveModel :exec
UPDATE algorithms SET active_model = $2 WHERE id = $1;

-- name: InsertCycle :one
INSERT INTO learning_cycles (algorithm_id, trigger, state, doc, started_at)
VALUES ($1, $2, 'collect', $3, $4)
RETURNING id;

-- name: UpdateCycle :exec
UPDATE learning_cycles
SET state = $2, outcome = $3, reason = $4, doc = $5, consumed_until = $6, finished_at = $7
WHERE id = $1;

-- name: GetCycle :one
SELECT * FROM learning_cycles WHERE id = $1;

-- name: GetCycleForUpdate :one
SELECT * FROM learning_cycles WHERE id = $1 FOR UPDATE;

-- name: ListCycles :many
SELECT * FROM learning_cycles WHERE algorithm_id = $1 ORDER BY id DESC LIMIT $2 OFFSET $3;

-- name: CountCycles :one
SELECT count(*) FROM learning_cycles WHERE algorithm_id = $1;

-- name: OpenCycles :many
SELECT * FROM learning_cycles WHERE state <> 'done' ORDER BY id;

-- name: LastCycleStart :one
SELECT coalesce(max(started_at), '0001-01-01'::timestamptz)::timestamptz FROM learning_cycles WHERE algorithm_id = $1;

-- name: ConsumedUntil :one
SELECT coalesce(max(consumed_until), '0001-01-01'::timestamptz)::timestamptz FROM learning_cycles WHERE algorithm_id = $1;

-- name: InsertCandidate :exec
INSERT INTO cycle_candidates (cycle_id, seq, change, recipe, recipe_hash, status)
VALUES ($1, $2, $3, $4, $5, 'queued');

-- name: EndCandidate :exec
UPDATE cycle_candidates SET status = $3, failure = $4, result = $5 WHERE cycle_id = $1 AND seq = $2;

-- name: ListCandidates :many
SELECT * FROM cycle_candidates WHERE cycle_id = $1 ORDER BY seq;

-- name: InsertPromotion :exec
INSERT INTO promotions (algorithm_id, action, version_id, model_id, prev_version_id, prev_model_id, cycle_id, note)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8);

-- name: LastPromotion :one
SELECT * FROM promotions WHERE algorithm_id = $1 ORDER BY id DESC LIMIT 1;
