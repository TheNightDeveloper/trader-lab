-- +goose Up

-- Spot pairs. All prices and quantities are fixed-point bigint at the given scales.
CREATE TABLE instruments (
    symbol       text PRIMARY KEY,
    base         text NOT NULL,
    quote        text NOT NULL,
    base_scale   int  NOT NULL,
    quote_scale  int  NOT NULL,
    price_scale  int  NOT NULL,
    tick         bigint NOT NULL CHECK (tick > 0),
    lot          bigint NOT NULL CHECK (lot > 0),
    min_notional bigint NOT NULL CHECK (min_notional >= 0)
);

-- Closed 1m bars. Higher timeframes are resampled in the engine.
-- Rows are never updated: a source correction inserts revision + 1, so older
-- dataset versions (cut off by ingested_at) stay readable.
CREATE TABLE candles (
    symbol       text        NOT NULL REFERENCES instruments,
    open_time    timestamptz NOT NULL,
    revision     int         NOT NULL CHECK (revision >= 1),
    close_time   timestamptz NOT NULL,
    available_at timestamptz NOT NULL,
    o            bigint      NOT NULL,
    h            bigint      NOT NULL,
    l            bigint      NOT NULL,
    c            bigint      NOT NULL,
    volume       bigint      NOT NULL,
    source       text        NOT NULL, -- archive | rest
    source_ref   text        NOT NULL, -- archive file checksum, or rest
    ingested_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (symbol, open_time, revision),
    CHECK (available_at >= close_time)
) PARTITION BY RANGE (open_time);

-- Creates the month partition holding ts if it does not exist yet.
-- +goose StatementBegin
CREATE FUNCTION ensure_candle_partition(ts timestamptz) RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
    m    timestamptz := date_trunc('month', ts AT TIME ZONE 'UTC') AT TIME ZONE 'UTC';
    name text := format('candles_%s', to_char(m AT TIME ZONE 'UTC', 'YYYY_MM'));
BEGIN
    EXECUTE format(
        'CREATE TABLE IF NOT EXISTS %I PARTITION OF candles FOR VALUES FROM (%L) TO (%L)',
        name, m, m + interval '1 month');
END;
$$;
-- +goose StatementEnd

CREATE TABLE quality_issues (
    id          bigserial PRIMARY KEY,
    symbol      text        NOT NULL REFERENCES instruments,
    kind        text        NOT NULL, -- gap | out_of_order | duplicate | bad_price | zero_volume | correction | outage
    at          timestamptz NOT NULL, -- first affected bar open time
    until       timestamptz,          -- end of the affected range (gaps, outages)
    detail      text        NOT NULL,
    detected_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (symbol, kind, at)
);

-- Archive files already imported (idempotency and provenance).
CREATE TABLE import_files (
    sha256      text PRIMARY KEY,
    symbol      text        NOT NULL REFERENCES instruments,
    url         text        NOT NULL,
    rows        int         NOT NULL,
    imported_at timestamptz NOT NULL DEFAULT now()
);

-- Content-addressed dataset versions. id = hash of the bars and policy.
CREATE TABLE datasets (
    id           text PRIMARY KEY,
    symbol       text        NOT NULL REFERENCES instruments,
    timeframe    text        NOT NULL,
    range_from   timestamptz NOT NULL,
    range_to     timestamptz NOT NULL,
    gap_policy   text        NOT NULL,
    known_at     timestamptz NOT NULL, -- candle rows ingested after this are not part of the version
    bar_count    int         NOT NULL,
    manifest     jsonb       NOT NULL,
    created_at   timestamptz NOT NULL DEFAULT now()
);

-- USDT/TOMAN display rates. Append-only; reports store the id they used.
CREATE TABLE fx_rates (
    id         bigserial PRIMARY KEY,
    pair       text        NOT NULL CHECK (pair = 'USDT/TOMAN'),
    rate_date  date        NOT NULL,
    rate       bigint      NOT NULL CHECK (rate > 0),
    rate_scale int         NOT NULL,
    source     text        NOT NULL,
    entered_at timestamptz NOT NULL DEFAULT now()
);

-- +goose Down
DROP TABLE fx_rates;
DROP TABLE datasets;
DROP TABLE import_files;
DROP TABLE quality_issues;
DROP FUNCTION ensure_candle_partition(timestamptz);
DROP TABLE candles;
DROP TABLE instruments;
