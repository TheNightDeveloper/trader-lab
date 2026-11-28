-- name: InsertRuleVersion :one
INSERT INTO strategy_rule_versions (title, content_hash, definition, parent_id, other_parent_id, template_key)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: GetRuleVersion :one
SELECT * FROM strategy_rule_versions WHERE id = $1;

-- name: ListRuleVersionsPage :many
SELECT v.id, v.title, v.content_hash, v.parent_id, v.other_parent_id, v.template_key, v.created_at
FROM strategy_rule_versions v
WHERE v.id <= sqlc.arg(through_id)
  AND strpos(lower(v.title), lower(sqlc.arg(query)::text)) > 0
  AND (sqlc.narg(has_report)::boolean IS NULL OR sqlc.narg(has_report)::boolean = EXISTS (
    SELECT 1 FROM reports r WHERE r.spec->>'rule_version_id' = v.id::text
  ))
ORDER BY v.id DESC
LIMIT sqlc.arg(page_limit);

-- name: LatestReportForRuleVersion :one
SELECT id, created_at, oos_return FROM reports
WHERE spec->>'rule_version_id' = sqlc.arg(rule_version)::text
ORDER BY created_at DESC, id
LIMIT 1;