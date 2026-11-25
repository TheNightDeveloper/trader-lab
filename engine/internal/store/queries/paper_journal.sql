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
