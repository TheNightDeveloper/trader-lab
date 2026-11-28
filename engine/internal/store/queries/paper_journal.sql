-- Bound the page before aggregating events, including on accounts with long histories.
-- name: ListPaperJournal :many
SELECT sqlc.embed(paper_entries),
       coalesce(p.quantity, 0)::bigint AS open_quantity,
       totals.fees_paid, totals.realized_pnl
FROM paper_entries
LEFT JOIN paper_positions p ON p.entry_id = paper_entries.id
CROSS JOIN LATERAL (
    SELECT coalesce(sum(fee), 0)::text AS fees_paid,
           coalesce(sum(realized_pnl), 0)::text AS realized_pnl
    FROM paper_execution_events WHERE entry_id = paper_entries.id
) totals
WHERE paper_entries.id IN (
    SELECT e.id FROM paper_entries e
    WHERE e.account_id = @account_id AND (@before_id::bigint = 0 OR e.id < @before_id)
    ORDER BY e.id DESC LIMIT @page_limit
)
ORDER BY paper_entries.id DESC;

-- name: LatestPaperJournalNote :one
SELECT * FROM paper_journal_notes WHERE entry_id = $1 ORDER BY revision DESC LIMIT 1;

-- The primary key also enforces one winner when concurrent requests read the same revision.
-- name: AppendPaperJournalNote :one
WITH input AS (
    SELECT sqlc.arg(receipt_id)::bigint AS receipt_id, sqlc.arg(expected_revision)::bigint AS expected_revision,
           sqlc.arg(note_body)::text AS note_body, sqlc.arg(note_time)::timestamptz AS note_time
)
INSERT INTO paper_journal_notes (entry_id, revision, body, recorded_at)
SELECT receipt_id, expected_revision + 1, note_body, note_time FROM input
WHERE expected_revision = coalesce((
    SELECT max(n.revision) FROM paper_journal_notes n WHERE n.entry_id = input.receipt_id
), 0)
ON CONFLICT DO NOTHING
RETURNING *;
