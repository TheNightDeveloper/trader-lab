-- +goose Up
ALTER TABLE assistant_runs RENAME COLUMN snapshot_sha256 TO evidence_sha256;
ALTER TABLE assistant_runs
    ALTER COLUMN opportunity_id DROP NOT NULL,
    ADD COLUMN report_ids text[],
    ADD CONSTRAINT assistant_runs_scope_check CHECK (
        (opportunity_id IS NOT NULL AND report_ids IS NULL) OR
        (opportunity_id IS NULL AND report_ids IS NOT NULL AND cardinality(report_ids) BETWEEN 1 AND 6)
    ),
    DROP CONSTRAINT assistant_runs_focus_check,
    ADD CONSTRAINT assistant_runs_focus_check CHECK (
        focus = '' OR
        (opportunity_id IS NOT NULL AND focus IN ('rule', 'snapshot', 'report')) OR
        (report_ids IS NOT NULL AND focus IN ('total_return', 'max_drawdown', 'closed_trades'))
    );

DROP INDEX assistant_runs_evidence;
CREATE INDEX assistant_runs_evidence ON assistant_runs (evidence_sha256, model, prompt_version, (coalesce(opportunity_id, 0)), id DESC)
    WHERE status IN ('running', 'succeeded');

-- +goose Down
-- Setting NOT NULL first refuses a downgrade that would discard research audit rows.
ALTER TABLE assistant_runs ALTER COLUMN opportunity_id SET NOT NULL;
DROP INDEX assistant_runs_evidence;
ALTER TABLE assistant_runs
    DROP CONSTRAINT assistant_runs_scope_check,
    DROP CONSTRAINT assistant_runs_focus_check,
    DROP COLUMN report_ids,
    ADD CONSTRAINT assistant_runs_focus_check CHECK (focus IN ('', 'rule', 'snapshot', 'report'));
ALTER TABLE assistant_runs RENAME COLUMN evidence_sha256 TO snapshot_sha256;
CREATE INDEX assistant_runs_evidence ON assistant_runs (opportunity_id, snapshot_sha256, model, prompt_version, id DESC)
    WHERE status IN ('running', 'succeeded');
