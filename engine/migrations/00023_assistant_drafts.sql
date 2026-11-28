-- +goose Up
ALTER TABLE assistant_runs
    ADD COLUMN rule_draft boolean NOT NULL DEFAULT false,
    DROP CONSTRAINT assistant_runs_scope_check,
    DROP CONSTRAINT assistant_runs_focus_check,
    ADD CONSTRAINT assistant_runs_scope_check CHECK (
        (rule_draft AND opportunity_id IS NULL AND report_ids IS NULL) OR
        (NOT rule_draft AND (
            (opportunity_id IS NOT NULL AND report_ids IS NULL) OR
            (opportunity_id IS NULL AND report_ids IS NOT NULL AND cardinality(report_ids) BETWEEN 1 AND 6)
        ))
    ),
    ADD CONSTRAINT assistant_runs_focus_check CHECK (
        focus = '' OR
        (rule_draft AND focus IN ('draft', 'needs_definition')) OR
        (opportunity_id IS NOT NULL AND focus IN ('rule', 'snapshot', 'report')) OR
        (report_ids IS NOT NULL AND focus IN ('total_return', 'max_drawdown', 'closed_trades'))
    );

-- +goose Down
-- This constraint refuses downgrade while draft audit rows exist.
ALTER TABLE assistant_runs
    DROP CONSTRAINT assistant_runs_scope_check,
    DROP CONSTRAINT assistant_runs_focus_check,
    ADD CONSTRAINT assistant_runs_scope_check CHECK (
        (opportunity_id IS NOT NULL AND report_ids IS NULL) OR
        (opportunity_id IS NULL AND report_ids IS NOT NULL AND cardinality(report_ids) BETWEEN 1 AND 6)
    ),
    ADD CONSTRAINT assistant_runs_focus_check CHECK (
        focus = '' OR
        (opportunity_id IS NOT NULL AND focus IN ('rule', 'snapshot', 'report')) OR
        (report_ids IS NOT NULL AND focus IN ('total_return', 'max_drawdown', 'closed_trades'))
    ),
    DROP COLUMN rule_draft;
