-- +goose Up

CREATE TABLE algorithms (
    id          text PRIMARY KEY, -- strategy name, e.g. trend-ema
    family      text NOT NULL,    -- trend | mean_reversion | learning | hybrid | benchmark
    description text NOT NULL
);

-- A version is content-addressed: a changed rule or parameter set is a new version.
CREATE TABLE algorithm_versions (
    id           text PRIMARY KEY, -- <algorithm>@v<n>
    algorithm_id text        NOT NULL REFERENCES algorithms,
    version      int         NOT NULL,
    content_hash text        NOT NULL,
    definition   jsonb       NOT NULL,
    state        text        NOT NULL CHECK (state IN ('research', 'validation', 'forward_test', 'active', 'stopped', 'retired')),
    created_at   timestamptz NOT NULL DEFAULT now(),
    UNIQUE (algorithm_id, version),
    UNIQUE (algorithm_id, content_hash)
);

-- Every lifecycle change, with who decided (invariant 9: only a person activates).
CREATE TABLE lifecycle_events (
    id         bigserial PRIMARY KEY,
    version_id text        NOT NULL REFERENCES algorithm_versions,
    from_state text        NOT NULL,
    to_state   text        NOT NULL,
    note       text        NOT NULL,
    actor      text        NOT NULL, -- user | system
    at         timestamptz NOT NULL DEFAULT now()
);

-- Experiments are locked on start: the definition never changes (invariant 7).
CREATE TABLE experiments (
    id          text PRIMARY KEY, -- content id of the definition
    name        text        NOT NULL,
    definition  jsonb       NOT NULL,
    status      text        NOT NULL CHECK (status IN ('running', 'paused', 'finalizing', 'done', 'cancelled', 'failed')),
    created_at  timestamptz NOT NULL DEFAULT now(),
    finished_at timestamptz,
    result      jsonb,
    error       text        NOT NULL DEFAULT ''
);

-- One row per candidate × pair. Never deleted (invariant 6).
CREATE TABLE attempts (
    experiment_id text        NOT NULL REFERENCES experiments,
    seq           int         NOT NULL,
    candidate     int         NOT NULL,
    params        jsonb       NOT NULL,
    dataset_id    text        NOT NULL,
    symbol        text        NOT NULL,
    status        text        NOT NULL CHECK (status IN ('queued', 'running', 'done', 'failed', 'cancelled')),
    failure       text        NOT NULL DEFAULT '',
    cache         text        NOT NULL DEFAULT '', -- hit | miss
    cache_key     text        NOT NULL DEFAULT '',
    metrics       jsonb,
    eligible      boolean,
    violations    jsonb,
    runs          int         NOT NULL DEFAULT 0, -- >1 when an engine restart re-ran it
    started_at    timestamptz,
    finished_at   timestamptz,
    PRIMARY KEY (experiment_id, seq)
);
CREATE INDEX attempts_queued ON attempts (status, experiment_id, seq);

-- Full-run reuse: key = hash of every input (data, code, strategy, params, costs, split).
CREATE TABLE run_cache (
    key        text PRIMARY KEY,
    metrics    jsonb       NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- +goose Down
DROP TABLE run_cache;
DROP TABLE attempts;
DROP TABLE experiments;
DROP TABLE lifecycle_events;
DROP TABLE algorithm_versions;
DROP TABLE algorithms;
