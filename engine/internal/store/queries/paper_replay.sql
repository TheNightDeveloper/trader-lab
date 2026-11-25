-- name: StorePaperConfirmationEvidence :exec
INSERT INTO paper_confirmation_evidence (event_id, open_time, close_time, available_at, revision, close_price, engine_build_sha256)
VALUES ($1, $2, $3, $4, $5, $6, $7);

-- name: PaperConfirmationEvidence :one
SELECT * FROM paper_confirmation_evidence WHERE event_id = $1;

-- name: PaperReplayOpportunity :one
SELECT * FROM market_opportunities WHERE id = $1;

-- name: FirstPaperReplayEvent :one
SELECT coalesce(min(id), 0)::bigint FROM paper_execution_events WHERE entry_id = $1;

-- Each cursor can only advance within the receipt it was issued for.
-- name: PaperReplayEvent :one
SELECT sqlc.embed(paper_execution_events),
       coalesce((SELECT max(p.id) FROM paper_execution_events p WHERE p.entry_id = @receipt_id AND p.id < @event_id), 0)::bigint AS previous_id,
       coalesce((SELECT min(n.id) FROM paper_execution_events n WHERE n.entry_id = @receipt_id AND n.id > @event_id), 0)::bigint AS next_id
FROM paper_execution_events WHERE entry_id = @receipt_id AND id = @event_id;
