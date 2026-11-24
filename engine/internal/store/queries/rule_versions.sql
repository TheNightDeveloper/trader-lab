-- name: InsertRuleVersion :one
INSERT INTO strategy_rule_versions (title, content_hash, definition, parent_id, other_parent_id, template_key)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: GetRuleVersion :one
SELECT * FROM strategy_rule_versions WHERE id = $1;

-- name: ListRuleVersionsPage :many
SELECT id, title, content_hash, parent_id, other_parent_id, template_key, created_at
FROM strategy_rule_versions
WHERE id <= sqlc.arg(through_id)
  AND strpos(lower(title), lower(sqlc.arg(query)::text)) > 0
ORDER BY id DESC
LIMIT sqlc.arg(page_limit);
