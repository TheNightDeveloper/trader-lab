-- +goose Up
CREATE TABLE paper_accounts (
    id              text        PRIMARY KEY,
    created_at      timestamptz NOT NULL,
    revision        bigint      NOT NULL DEFAULT 1 CHECK (revision > 0),
    policy_revision bigint      NOT NULL DEFAULT 1 CHECK (policy_revision > 0),
    initial_capital bigint      NOT NULL CHECK (initial_capital > 0),
    cash_available  bigint      NOT NULL CHECK (cash_available >= 0),
    cash_reserved   bigint      NOT NULL DEFAULT 0 CHECK (cash_reserved >= 0)
);

CREATE TABLE paper_policy_versions (
    account_id        text        NOT NULL REFERENCES paper_accounts,
    revision          bigint      NOT NULL CHECK (revision > 0),
    effective_at      timestamptz NOT NULL,
    max_loss          bigint      NOT NULL CHECK (max_loss > 0),
    max_open_loss     bigint      NOT NULL CHECK (max_open_loss >= max_loss),
    max_exposure      bigint      NOT NULL CHECK (max_exposure > 0),
    fee_ppm           bigint      NOT NULL CHECK (fee_ppm BETWEEN 0 AND 999999),
    slippage_ppm      bigint      NOT NULL CHECK (slippage_ppm BETWEEN 0 AND 999999),
    max_cost_ppm      bigint      NOT NULL CHECK (max_cost_ppm BETWEEN 1 AND 1000000),
    entry_drift_ppm   bigint      NOT NULL CHECK (entry_drift_ppm BETWEEN 0 AND 1000000),
    PRIMARY KEY (account_id, revision)
);

-- A posting transfers an exact amount between two buckets of the same asset.
CREATE TABLE paper_postings (
    account_id  text        NOT NULL REFERENCES paper_accounts,
    event_key   text        NOT NULL,
    leg         int         NOT NULL CHECK (leg >= 0),
    recorded_at timestamptz NOT NULL,
    asset       text        NOT NULL,
    source      text        NOT NULL,
    destination text        NOT NULL CHECK (destination <> source),
    amount      bigint      NOT NULL CHECK (amount > 0),
    PRIMARY KEY (account_id, event_key, leg)
);

-- Keep the exact serialized terms that were hashed and shown for review.
CREATE TABLE paper_trade_plans (
    hash           text        PRIMARY KEY,
    account_id     text        NOT NULL REFERENCES paper_accounts,
    opportunity_id bigint      NOT NULL REFERENCES market_opportunities,
    expires_at     timestamptz NOT NULL,
    body           bytea       NOT NULL
);

-- +goose Down
DROP TABLE paper_trade_plans;
DROP TABLE paper_postings;
DROP TABLE paper_policy_versions;
DROP TABLE paper_accounts;
