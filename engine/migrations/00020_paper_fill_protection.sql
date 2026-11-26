-- +goose Up
-- Each v2 buy has its own first eligible protection candle.
CREATE TABLE paper_fill_protection (
    entry_id       bigint      NOT NULL REFERENCES paper_positions(entry_id) ON DELETE CASCADE,
    fill_event_id  bigint      NOT NULL REFERENCES paper_execution_events(id),
    eligible_at    timestamptz NOT NULL,
    quantity       bigint      NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (entry_id, fill_event_id)
);

-- +goose Down
DROP TABLE paper_fill_protection;
