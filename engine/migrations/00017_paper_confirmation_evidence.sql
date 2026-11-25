-- +goose Up
-- Retain the actual quote that passed revalidation even when market data is revised.
CREATE TABLE paper_confirmation_evidence (
    event_id      bigint      PRIMARY KEY REFERENCES paper_execution_events,
    open_time     timestamptz NOT NULL,
    close_time    timestamptz NOT NULL CHECK (close_time > open_time),
    available_at  timestamptz NOT NULL CHECK (available_at >= close_time),
    revision      int         NOT NULL CHECK (revision > 0),
    close_price   bigint      NOT NULL CHECK (close_price > 0)
);

-- +goose Down
DROP TABLE paper_confirmation_evidence;
