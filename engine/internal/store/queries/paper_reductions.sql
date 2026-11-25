-- name: InsertPaperReduction :one
INSERT INTO paper_reductions (entry_id, position_revision, quantity, requested_at, next_open_at)
VALUES ($1, $2, $3, $4, $5) RETURNING *;

-- name: PaperReductionAtRevision :one
SELECT * FROM paper_reductions WHERE entry_id = $1 AND position_revision = $2;

-- name: PendingPaperReduction :one
SELECT * FROM paper_reductions WHERE entry_id = $1 AND state = 1;

-- name: LatestPaperReduction :one
SELECT * FROM paper_reductions WHERE entry_id = $1 ORDER BY id DESC LIMIT 1;

-- name: FinishPaperReduction :exec
UPDATE paper_reductions SET state = $2, result_event_id = $3 WHERE id = $1;
