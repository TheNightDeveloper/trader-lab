-- +goose Up

-- One evaluated configuration. Immutable once written (invariant 7).
CREATE TABLE reports (
    id            text PRIMARY KEY,
    created_at    timestamptz NOT NULL DEFAULT now(),
    title         text        NOT NULL,
    spec          jsonb       NOT NULL, -- eval.Spec: every assumption
    split         jsonb       NOT NULL, -- folds, OOS window, holdout window
    evaluation    jsonb       NOT NULL, -- OOS view, folds, stress, grid, summary
    holdout       jsonb       NOT NULL, -- hidden until explicitly viewed (logged)
    oos_net       bigint      NOT NULL, -- USDT scale 8, for lists
    oos_return    bigint      NOT NULL, -- ppm
    closed_trades int         NOT NULL,
    verdict       text        NOT NULL,
    tone          text        NOT NULL
);

-- run: 'main' (out of sample) or 'holdout'. USDT amounts at scale 8.
CREATE TABLE trades (
    report_id      text        NOT NULL REFERENCES reports,
    run            text        NOT NULL CHECK (run IN ('main', 'holdout')),
    seq            int         NOT NULL,
    instrument     text        NOT NULL,
    opened_at      timestamptz NOT NULL,
    closed_at      timestamptz,
    qty            bigint      NOT NULL,
    entry_ref      bigint      NOT NULL,
    exit_ref       bigint      NOT NULL,
    gross          bigint      NOT NULL,
    slippage       bigint      NOT NULL,
    fees           bigint      NOT NULL,
    net            bigint      NOT NULL,
    exit_reason    text        NOT NULL,
    ambiguous_bars int         NOT NULL,
    open_qty       bigint      NOT NULL,
    mark_value     bigint,
    PRIMARY KEY (report_id, run, seq)
);

CREATE TABLE fills (
    report_id      text        NOT NULL REFERENCES reports,
    run            text        NOT NULL CHECK (run IN ('main', 'holdout')),
    seq            int         NOT NULL,
    decision_id    int         NOT NULL, -- 0 for stop/take exits
    at             timestamptz NOT NULL,
    instrument     text        NOT NULL,
    side           text        NOT NULL,
    kind           text        NOT NULL,
    qty            bigint      NOT NULL,
    ref_price      bigint      NOT NULL,
    price          bigint      NOT NULL,
    quote          text        NOT NULL,
    ref_value      bigint      NOT NULL, -- quote asset
    value          bigint      NOT NULL,
    slippage       bigint      NOT NULL,
    fee            bigint      NOT NULL,
    ref_value_usdt bigint      NOT NULL,
    slippage_usdt  bigint      NOT NULL,
    fee_usdt       bigint      NOT NULL,
    ambiguous      boolean     NOT NULL,
    PRIMARY KEY (report_id, run, seq)
);

-- Every intent with its outcome (accepted or not).
CREATE TABLE decisions (
    report_id      text        NOT NULL REFERENCES reports,
    run            text        NOT NULL CHECK (run IN ('main', 'holdout')),
    id             int         NOT NULL,
    at             timestamptz NOT NULL,
    input_symbol   text        NOT NULL,
    input_bar_open timestamptz NOT NULL,
    instrument     text        NOT NULL,
    target         bigint      NOT NULL, -- ppm
    stop_loss      bigint      NOT NULL,
    take_profit    bigint      NOT NULL,
    reason         text        NOT NULL,
    model_id       text        NOT NULL,
    recipe_version text        NOT NULL,
    outcome        text        NOT NULL,
    detail         text        NOT NULL,
    PRIMARY KEY (report_id, run, id)
);

-- Invariant 8: every look at a final-holdout result is recorded.
CREATE TABLE holdout_views (
    id        bigserial PRIMARY KEY,
    report_id text        NOT NULL REFERENCES reports,
    viewed_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX holdout_views_report ON holdout_views (report_id);

-- +goose Down
DROP TABLE holdout_views;
DROP TABLE decisions;
DROP TABLE fills;
DROP TABLE trades;
DROP TABLE reports;
