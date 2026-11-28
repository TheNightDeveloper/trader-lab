-- +goose Up
-- One active background rule per symbol bounds work to the configured watchlist.
CREATE TABLE market_scan_subscriptions (
    symbol            text        PRIMARY KEY REFERENCES instruments,
    rule_version_id   bigint      NOT NULL REFERENCES strategy_rule_versions,
    report_id         text        NOT NULL REFERENCES reports,
    last_closed_at    timestamptz,
    last_state        int         NOT NULL DEFAULT 0 CHECK (last_state BETWEEN 0 AND 3),
    CHECK ((last_state = 0) = (last_closed_at IS NULL))
);

-- +goose Down
DROP TABLE market_scan_subscriptions;
