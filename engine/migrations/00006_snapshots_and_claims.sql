-- +goose Up

-- New snapshot manifests point to exact immutable raw candle revisions. Existing
-- timestamp-based dataset manifests remain readable without rewriting their IDs.
CREATE TABLE dataset_members (
    dataset_id text NOT NULL REFERENCES datasets,
    symbol text NOT NULL,
    open_time timestamptz NOT NULL,
    revision int NOT NULL,
    PRIMARY KEY (dataset_id, open_time),
    FOREIGN KEY (symbol, open_time, revision) REFERENCES candles (symbol, open_time, revision)
);

-- Each execution has a fresh token; an interrupted or cancelled worker cannot
-- finish a newer claim. The attempt row and its run counter remain the audit log.
ALTER TABLE attempts ADD COLUMN claim_token text NOT NULL DEFAULT '';

-- Two symbols may ingest the same new month concurrently. Only partition
-- creation is serialized; established partitions keep independent symbol writes.
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION ensure_candle_partition(ts timestamptz) RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
    m timestamptz := date_trunc('month', ts AT TIME ZONE 'UTC') AT TIME ZONE 'UTC';
    name text := format('candles_%s', to_char(m AT TIME ZONE 'UTC', 'YYYY_MM'));
BEGIN
    IF to_regclass(format('%I.%I', current_schema(), name)) IS NOT NULL THEN
        RETURN;
    END IF;
    PERFORM pg_advisory_xact_lock(hashtextextended(current_schema() || ':candle-partition:' || name, 0));
    EXECUTE format('CREATE TABLE IF NOT EXISTS %I PARTITION OF candles FOR VALUES FROM (%L) TO (%L)', name, m, m + interval '1 month');
END;
$$;
-- +goose StatementEnd

-- +goose Down
ALTER TABLE attempts DROP COLUMN claim_token;
DROP TABLE dataset_members;

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION ensure_candle_partition(ts timestamptz) RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
    m timestamptz := date_trunc('month', ts AT TIME ZONE 'UTC') AT TIME ZONE 'UTC';
    name text := format('candles_%s', to_char(m AT TIME ZONE 'UTC', 'YYYY_MM'));
BEGIN
    EXECUTE format('CREATE TABLE IF NOT EXISTS %I PARTITION OF candles FOR VALUES FROM (%L) TO (%L)', name, m, m + interval '1 month');
END;
$$;
-- +goose StatementEnd
