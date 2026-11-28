-- +goose Up
CREATE TABLE shadow_deployments (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    symbol text NOT NULL REFERENCES instruments,
    rule_version_id bigint NOT NULL REFERENCES strategy_rule_versions,
    rule_content_hash text NOT NULL,
    report_id text NOT NULL REFERENCES reports,
    registered_at timestamptz NOT NULL,
    start_at timestamptz NOT NULL CHECK (start_at > registered_at),
    end_at timestamptz NOT NULL CHECK (end_at > start_at),
    settled_at timestamptz,
    state text NOT NULL DEFAULT 'active' CHECK (state IN ('active', 'complete', 'stopped', 'gap', 'build_changed')),
    sim_config jsonb NOT NULL,
    spec_revision text NOT NULL,
    runtime_policy text NOT NULL,
    fill_model text NOT NULL,
    ai_model text NOT NULL,
    ai_prompt_version text NOT NULL,
    engine_build text NOT NULL,
    CHECK ((settled_at IS NULL) = (state = 'active'))
);

-- Keep the initial worker and provider budget bounded to one active deployment.
CREATE UNIQUE INDEX shadow_one_active ON shadow_deployments (state) WHERE state = 'active';

CREATE TABLE shadow_hours (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    deployment_id bigint NOT NULL REFERENCES shadow_deployments,
    closed_at timestamptz NOT NULL,
    observed_at timestamptz NOT NULL CHECK (observed_at >= closed_at),
    decision_at timestamptz NOT NULL CHECK (decision_at > observed_at),
    bar bytea NOT NULL,
    warmup bytea,
    reason text NOT NULL,
    gate text NOT NULL CHECK (gate IN ('no_signal', 'running', 'allow', 'block', 'unavailable')),
    gate_resolved_at timestamptz,
    UNIQUE (deployment_id, closed_at)
);

ALTER TABLE assistant_runs
    ADD COLUMN shadow_hour_id bigint REFERENCES shadow_hours,
    DROP CONSTRAINT assistant_runs_scope_check,
    DROP CONSTRAINT assistant_runs_focus_check,
    ADD CONSTRAINT assistant_runs_scope_check CHECK (
        (shadow_hour_id IS NOT NULL AND NOT rule_draft AND opportunity_id IS NULL AND report_ids IS NULL) OR
        (shadow_hour_id IS NULL AND (
            (rule_draft AND opportunity_id IS NULL AND report_ids IS NULL) OR
            (NOT rule_draft AND opportunity_id IS NOT NULL AND report_ids IS NULL) OR
            (NOT rule_draft AND opportunity_id IS NULL AND report_ids IS NOT NULL AND cardinality(report_ids) BETWEEN 1 AND 6)
        ))
    ),
    ADD CONSTRAINT assistant_runs_focus_check CHECK (
        focus = '' OR
        (shadow_hour_id IS NOT NULL AND focus IN ('allow', 'block')) OR
        (rule_draft AND focus IN ('draft', 'needs_definition')) OR
        (opportunity_id IS NOT NULL AND focus IN ('rule', 'snapshot', 'report')) OR
        (report_ids IS NOT NULL AND focus IN ('total_return', 'max_drawdown', 'closed_trades'))
    );

CREATE INDEX assistant_runs_shadow ON assistant_runs (shadow_hour_id) WHERE shadow_hour_id IS NOT NULL;

-- +goose Down
-- Restoring the original scope refuses rollback while shadow audit rows exist.
ALTER TABLE assistant_runs
    DROP CONSTRAINT assistant_runs_scope_check,
    DROP CONSTRAINT assistant_runs_focus_check,
    ADD CONSTRAINT assistant_runs_scope_check CHECK (
        (rule_draft AND opportunity_id IS NULL AND report_ids IS NULL) OR
        (NOT rule_draft AND opportunity_id IS NOT NULL AND report_ids IS NULL) OR
        (NOT rule_draft AND opportunity_id IS NULL AND report_ids IS NOT NULL AND cardinality(report_ids) BETWEEN 1 AND 6)
    ),
    ADD CONSTRAINT assistant_runs_focus_check CHECK (
        focus = '' OR
        (rule_draft AND focus IN ('draft', 'needs_definition')) OR
        (opportunity_id IS NOT NULL AND focus IN ('rule', 'snapshot', 'report')) OR
        (report_ids IS NOT NULL AND focus IN ('total_return', 'max_drawdown', 'closed_trades'))
    ),
    DROP COLUMN shadow_hour_id;
DROP TABLE shadow_hours;
DROP TABLE shadow_deployments;
