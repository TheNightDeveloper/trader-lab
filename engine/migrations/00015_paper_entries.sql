-- +goose Up
-- Pending rows are the durable local execution queue. Each cursor is advanced with its fill.
CREATE TABLE paper_entries (
    id               bigserial   PRIMARY KEY,
    account_id       text        NOT NULL REFERENCES paper_accounts,
    opportunity_id   bigint      NOT NULL REFERENCES market_opportunities,
    plan_hash        text        NOT NULL UNIQUE REFERENCES paper_trade_plans,
    symbol           text        NOT NULL REFERENCES instruments,
    state            int         NOT NULL DEFAULT 1 CHECK (state BETWEEN 1 AND 5),
    confirmed_at     timestamptz NOT NULL,
    expires_at       timestamptz NOT NULL CHECK (expires_at > confirmed_at),
    next_open_at     timestamptz NOT NULL CHECK (next_open_at >= confirmed_at),
    quantity         bigint      NOT NULL CHECK (quantity > 0),
    filled_quantity  bigint      NOT NULL DEFAULT 0 CHECK (filled_quantity >= 0 AND filled_quantity <= quantity),
    reserved_cash    bigint      NOT NULL CHECK (reserved_cash >= 0),
    exposure_bound   bigint      NOT NULL CHECK (exposure_bound > 0),
    loss_bound       bigint      NOT NULL CHECK (loss_bound > 0),
    UNIQUE (account_id, opportunity_id),
    CHECK ((state IN (1, 2)) = (reserved_cash > 0)),
    CHECK (state <> 1 OR filled_quantity = 0),
    CHECK (state <> 2 OR filled_quantity BETWEEN 1 AND quantity - 1),
    CHECK ((state = 3) = (filled_quantity = quantity))
);

CREATE UNIQUE INDEX paper_active_entry_symbol_idx ON paper_entries (account_id, symbol) WHERE state IN (1, 2);

CREATE TABLE paper_positions (
    entry_id     bigint      PRIMARY KEY REFERENCES paper_entries,
    quantity     bigint      NOT NULL CHECK (quantity > 0),
    cost_basis   bigint      NOT NULL CHECK (cost_basis > 0),
    next_open_at timestamptz NOT NULL
);

CREATE TABLE paper_execution_events (
    id             bigserial   PRIMARY KEY,
    entry_id       bigint      NOT NULL REFERENCES paper_entries,
    kind           text        NOT NULL,
    recorded_at    timestamptz NOT NULL,
    quantity       bigint      NOT NULL DEFAULT 0,
    reference      bigint      NOT NULL DEFAULT 0,
    fill_price     bigint      NOT NULL DEFAULT 0,
    fee            bigint      NOT NULL DEFAULT 0,
    cash           bigint      NOT NULL DEFAULT 0,
    realized_pnl   bigint      NOT NULL DEFAULT 0,
    candle_open_at timestamptz,
    candle_revision int        NOT NULL DEFAULT 0,
    UNIQUE (entry_id, kind, candle_open_at)
);
CREATE INDEX paper_execution_events_entry_idx ON paper_execution_events (entry_id, id);

-- +goose Down
DROP TABLE paper_execution_events;
DROP TABLE paper_positions;
DROP TABLE paper_entries;
