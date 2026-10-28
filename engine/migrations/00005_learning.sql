-- +goose Up

-- Trained models, content-addressed (invariant 7). Only frozen models are stored
-- (a cycle's challenger and baseline); per-fold models are recomputed on demand.
CREATE TABLE model_artifacts (
    id           text PRIMARY KEY, -- m_ + content hash
    algorithm_id text        NOT NULL REFERENCES algorithms,
    recipe_hash  text        NOT NULL,
    as_of        timestamptz NOT NULL,
    cycle_id     bigint,
    body         jsonb       NOT NULL,
    created_at   timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX model_artifacts_by_algorithm ON model_artifacts (algorithm_id, created_at DESC);

-- The champion: the model serving the active version. Changed only by a user's
-- approval or rollback (invariant 9).
ALTER TABLE algorithms ADD COLUMN active_model text REFERENCES model_artifacts;

-- One row per learning cycle; never deleted. doc holds the pre-registered config
-- (gate, budgets) fixed at start, and everything the cycle found.
CREATE TABLE learning_cycles (
    id             bigserial PRIMARY KEY,
    algorithm_id   text        NOT NULL REFERENCES algorithms,
    trigger        text        NOT NULL CHECK (trigger IN ('schedule', 'manual')),
    state          text        NOT NULL CHECK (state IN ('collect', 'labels', 'generate', 'train', 'walk_forward', 'forward_test', 'decision', 'done')),
    -- '' while running | skipped | failed | not_better | gate_failed | recommended | approved | rejected
    outcome        text        NOT NULL DEFAULT '',
    reason         text        NOT NULL DEFAULT '',
    doc            jsonb       NOT NULL,
    -- End of the forward data this cycle's decision used: later cycles may train on
    -- it but never test on it (invariant 8).
    consumed_until timestamptz,
    started_at     timestamptz NOT NULL,
    finished_at    timestamptz
);
CREATE UNIQUE INDEX learning_cycles_one_open ON learning_cycles (algorithm_id) WHERE state <> 'done';

-- Every candidate a cycle generated: the cycle's attempt registry (invariant 6).
CREATE TABLE cycle_candidates (
    cycle_id    bigint NOT NULL REFERENCES learning_cycles,
    seq         int    NOT NULL,
    change      text   NOT NULL, -- what differs from the parent recipe
    recipe      jsonb  NOT NULL,
    recipe_hash text   NOT NULL,
    status      text   NOT NULL CHECK (status IN ('queued', 'done', 'failed', 'cancelled')),
    failure     text   NOT NULL DEFAULT '',
    result      jsonb,
    PRIMARY KEY (cycle_id, seq)
);

CREATE TABLE promotions (
    id              bigserial PRIMARY KEY,
    algorithm_id    text        NOT NULL REFERENCES algorithms,
    action          text        NOT NULL CHECK (action IN ('promote', 'rollback')),
    version_id      text        NOT NULL REFERENCES algorithm_versions,
    model_id        text        NOT NULL REFERENCES model_artifacts,
    prev_version_id text REFERENCES algorithm_versions,
    prev_model_id   text REFERENCES model_artifacts,
    cycle_id        bigint REFERENCES learning_cycles,
    note            text        NOT NULL DEFAULT '',
    at              timestamptz NOT NULL DEFAULT now()
);

-- +goose Down
DROP TABLE promotions;
DROP TABLE cycle_candidates;
DROP TABLE learning_cycles;
ALTER TABLE algorithms DROP COLUMN active_model;
DROP TABLE model_artifacts;
