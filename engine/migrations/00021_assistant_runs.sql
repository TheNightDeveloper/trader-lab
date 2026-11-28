-- +goose Up
CREATE TABLE assistant_runs (
    id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    opportunity_id  bigint      NOT NULL REFERENCES market_opportunities,
    snapshot_sha256 text        NOT NULL,
    model           text        NOT NULL,
    prompt_version  text        NOT NULL,
    started_at      timestamptz NOT NULL,
    latency_ms      bigint      CHECK (latency_ms >= 0),
    status          text        NOT NULL DEFAULT 'running'
                    CHECK (status IN ('running', 'succeeded', 'invalid_output', 'provider_error', 'timed_out', 'canceled', 'interrupted')),
    focus           text        NOT NULL DEFAULT '' CHECK (focus IN ('', 'rule', 'snapshot', 'report')),
    input_tokens    integer     CHECK (input_tokens >= 0),
    output_tokens   integer     CHECK (output_tokens >= 0),
    CHECK ((status = 'succeeded') = (focus <> ''))
);

CREATE INDEX assistant_runs_budget ON assistant_runs (started_at);
CREATE INDEX assistant_runs_evidence ON assistant_runs (opportunity_id, snapshot_sha256, model, prompt_version, id DESC)
    WHERE status IN ('running', 'succeeded');

-- +goose Down
DROP TABLE assistant_runs;
