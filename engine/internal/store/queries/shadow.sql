-- name: StartShadowDeployment :one
INSERT INTO shadow_deployments (symbol, rule_version_id, rule_content_hash, report_id, registered_at, start_at,
    end_at, sim_config, spec_revision, runtime_policy, fill_model, ai_model, ai_prompt_version, engine_build)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
ON CONFLICT DO NOTHING RETURNING id;

-- name: ActiveShadowDeployment :one
SELECT * FROM shadow_deployments WHERE state = 'active';

-- name: ListShadowDeployments :many
SELECT * FROM shadow_deployments ORDER BY (state = 'active') DESC, id DESC LIMIT 12;

-- name: GetShadowDeployment :one
SELECT * FROM shadow_deployments WHERE id = $1;

-- name: LockShadowDeployment :one
SELECT * FROM shadow_deployments WHERE id = $1 FOR UPDATE;

-- name: SettleShadowDeployment :exec
UPDATE shadow_deployments SET state = $2, settled_at = $3 WHERE id = $1 AND state = 'active';

-- name: LatestShadowHour :one
SELECT * FROM shadow_hours WHERE deployment_id = $1 ORDER BY closed_at DESC LIMIT 1;

-- name: ShadowHours :many
SELECT * FROM shadow_hours WHERE deployment_id = $1 ORDER BY closed_at;

-- name: InsertShadowHour :one
INSERT INTO shadow_hours (deployment_id, closed_at, observed_at, decision_at, bar, warmup, reason, gate)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *;

-- name: ResolveShadowGate :exec
UPDATE shadow_hours SET gate = $2, gate_resolved_at = $3 WHERE id = $1 AND gate = 'running';

-- name: LockShadowGate :one
SELECT id FROM shadow_hours WHERE id = $1 AND gate = 'running' AND decision_at > @as_of FOR UPDATE;

-- name: ShadowUsage :one
SELECT coalesce(sum(a.input_tokens), 0)::bigint AS input_tokens,
       coalesce(sum(a.output_tokens), 0)::bigint AS output_tokens
FROM shadow_hours h JOIN assistant_runs a ON a.shadow_hour_id = h.id
WHERE h.deployment_id = $1;
