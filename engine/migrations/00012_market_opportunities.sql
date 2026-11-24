-- +goose Up
-- One immutable entry observation per version, symbol and closed hour.
CREATE TABLE market_opportunities (
    id                bigserial PRIMARY KEY,
    symbol            text        NOT NULL REFERENCES instruments,
    rule_version_id   bigint      NOT NULL REFERENCES strategy_rule_versions,
    report_id         text        NOT NULL REFERENCES reports,
    spec_revision     text        NOT NULL,
    candle_closed_at  timestamptz NOT NULL,
    observed_at       timestamptz NOT NULL CHECK (observed_at >= candle_closed_at),
    expires_at        timestamptz NOT NULL CHECK (expires_at > observed_at),
    reference_close   bigint      NOT NULL CHECK (reference_close > 0),
    reason            text        NOT NULL,
    snapshot          bytea       NOT NULL, -- retain the exact hashed bytes for replay
    snapshot_sha256   text        NOT NULL,
    UNIQUE (rule_version_id, symbol, candle_closed_at)
);

-- +goose Down
DROP TABLE market_opportunities;
