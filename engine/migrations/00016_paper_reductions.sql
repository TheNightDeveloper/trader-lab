-- +goose Up
ALTER TABLE paper_positions ADD COLUMN revision bigint NOT NULL DEFAULT 1 CHECK (revision > 0);
ALTER TABLE paper_accounts ADD COLUMN entries_paused boolean NOT NULL DEFAULT false;

CREATE TABLE paper_entry_controls (
    account_id       text        NOT NULL REFERENCES paper_accounts,
    account_revision bigint      NOT NULL,
    recorded_at      timestamptz NOT NULL,
    entries_paused   boolean     NOT NULL,
    PRIMARY KEY (account_id, account_revision)
);

-- A revision can authorize one reduction. Terminal requests remain available for retries.
CREATE TABLE paper_reductions (
    id                bigserial   PRIMARY KEY,
    entry_id          bigint      NOT NULL REFERENCES paper_entries,
    position_revision bigint      NOT NULL CHECK (position_revision > 0),
    quantity          bigint      NOT NULL CHECK (quantity > 0),
    requested_at      timestamptz NOT NULL,
    next_open_at      timestamptz NOT NULL CHECK (next_open_at >= requested_at),
    state             int         NOT NULL DEFAULT 1 CHECK (state BETWEEN 1 AND 3),
    result_event_id   bigint      UNIQUE REFERENCES paper_execution_events,
    UNIQUE (entry_id, position_revision),
    CHECK ((state = 1) = (result_event_id IS NULL))
);
CREATE UNIQUE INDEX paper_pending_reduction_idx ON paper_reductions (entry_id) WHERE state = 1;

-- +goose Down
DROP TABLE paper_reductions;
DROP TABLE paper_entry_controls;
ALTER TABLE paper_accounts DROP COLUMN entries_paused;
ALTER TABLE paper_positions DROP COLUMN revision;
