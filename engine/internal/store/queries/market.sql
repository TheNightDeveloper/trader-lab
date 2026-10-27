-- name: UpsertInstrument :exec
INSERT INTO instruments (symbol, base, quote, base_scale, quote_scale, price_scale, tick, lot, min_notional)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
ON CONFLICT (symbol) DO UPDATE SET
    base = EXCLUDED.base, quote = EXCLUDED.quote,
    base_scale = EXCLUDED.base_scale, quote_scale = EXCLUDED.quote_scale, price_scale = EXCLUDED.price_scale,
    tick = EXCLUDED.tick, lot = EXCLUDED.lot, min_notional = EXCLUDED.min_notional;

-- name: ListInstruments :many
SELECT * FROM instruments ORDER BY symbol;

-- name: EnsureCandlePartition :exec
SELECT ensure_candle_partition(@ts::timestamptz);

-- UpsertCandles inserts new bars as revision 1, skips bars identical to their
-- current revision, and inserts revision+1 for bars whose values changed
-- (a source correction). Returns what was inserted.
-- name: UpsertCandles :many
WITH input AS (
    -- Parallel unnest in the select list zips the arrays row by row.
    SELECT unnest(@open_times::timestamptz[])    AS open_time,
           unnest(@close_times::timestamptz[])   AS close_time,
           unnest(@available_ats::timestamptz[]) AS available_at,
           unnest(@os::bigint[])                 AS o,
           unnest(@hs::bigint[])                 AS h,
           unnest(@ls::bigint[])                 AS l,
           unnest(@cs::bigint[])                 AS c,
           unnest(@volumes::bigint[])            AS volume
), cur AS (
    SELECT DISTINCT ON (k.open_time) k.open_time, k.revision, k.o, k.h, k.l, k.c, k.volume
    FROM candles k
    WHERE k.symbol = @symbol
      AND k.open_time >= (SELECT min(open_time) FROM input)
      AND k.open_time <= (SELECT max(open_time) FROM input)
    ORDER BY k.open_time, k.revision DESC
)
INSERT INTO candles (symbol, open_time, revision, close_time, available_at, o, h, l, c, volume, source, source_ref)
SELECT @symbol, i.open_time, COALESCE(cur.revision, 0) + 1, i.close_time, i.available_at,
       i.o, i.h, i.l, i.c, i.volume, @source, @source_ref
FROM input i
LEFT JOIN cur ON cur.open_time = i.open_time
WHERE cur.open_time IS NULL
   OR (cur.o, cur.h, cur.l, cur.c, cur.volume) IS DISTINCT FROM (i.o, i.h, i.l, i.c, i.volume)
RETURNING open_time, revision;

-- CandlesAsOf is the only read path for bars: the latest revision of each 1m bar
-- that was ingested by known_at and available by as_of.
-- name: CandlesAsOf :many
SELECT DISTINCT ON (open_time) open_time, close_time, available_at, o, h, l, c, volume
FROM candles
WHERE symbol = @symbol
  AND open_time >= @from_time AND open_time < @to_time
  AND available_at <= @as_of
  AND ingested_at <= @known_at
ORDER BY open_time, revision DESC;

-- name: LastCloseAsOf :one
SELECT c FROM candles
WHERE symbol = @symbol AND available_at <= @as_of
ORDER BY open_time DESC, revision DESC
LIMIT 1;

-- CoverageDays: bars per symbol per UTC day; the API merges consecutive days into
-- segments so holes show as holes.
-- ponytail: full scan per call; materialize per-day counts if this gets slow.
-- name: CoverageDays :many
SELECT symbol,
       (date_trunc('day', open_time AT TIME ZONE 'UTC') AT TIME ZONE 'UTC')::timestamptz AS day,
       min(open_time)::timestamptz AS first_open,
       max(open_time)::timestamptz AS last_open,
       count(DISTINCT open_time) AS bars
FROM candles
GROUP BY 1, 2
ORDER BY 1, 2;

-- name: InsertQualityIssue :exec
INSERT INTO quality_issues (symbol, kind, at, until, detail)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (symbol, kind, at) DO NOTHING;

-- name: ListQualityIssues :many
SELECT * FROM quality_issues
WHERE (sqlc.narg(symbol)::text IS NULL OR symbol = sqlc.narg(symbol))
ORDER BY at DESC, id DESC
LIMIT $1 OFFSET $2;

-- name: CountQualityIssues :one
SELECT count(*) FROM quality_issues
WHERE (sqlc.narg(symbol)::text IS NULL OR symbol = sqlc.narg(symbol));

-- name: RecordImportFile :exec
INSERT INTO import_files (sha256, symbol, url, rows) VALUES ($1, $2, $3, $4)
ON CONFLICT (sha256) DO NOTHING;

-- name: InsertDataset :exec
INSERT INTO datasets (id, symbol, timeframe, range_from, range_to, gap_policy, known_at, bar_count, manifest)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
ON CONFLICT (id) DO NOTHING;

-- name: GetDataset :one
SELECT * FROM datasets WHERE id = $1;

-- name: ListDatasets :many
SELECT * FROM datasets ORDER BY created_at DESC, id LIMIT $1 OFFSET $2;

-- name: CountDatasets :one
SELECT count(*) FROM datasets;

-- name: InsertFxRate :one
INSERT INTO fx_rates (pair, rate_date, rate, rate_scale, source)
VALUES ('USDT/TOMAN', $1, $2, $3, $4)
RETURNING *;

-- name: ListFxRates :many
SELECT * FROM fx_rates ORDER BY rate_date DESC, id DESC LIMIT $1;

-- name: LatestFxRate :one
SELECT * FROM fx_rates ORDER BY rate_date DESC, id DESC LIMIT 1;

-- name: LastCandleOpen :one
SELECT open_time FROM candles WHERE symbol = $1 ORDER BY open_time DESC LIMIT 1;

-- Outages are stored once per symbol; count each (at, until) once.
-- name: OutagesSince :one
SELECT count(*)::int AS outages,
       COALESCE(sum(extract(epoch FROM until - at)), 0)::bigint AS seconds
FROM (SELECT DISTINCT at, until FROM quality_issues WHERE kind = 'outage' AND at >= @since) o;

-- name: DatabaseSize :one
SELECT pg_database_size(current_database())::bigint;

-- name: ProblemRanges :many
SELECT symbol, at, until FROM quality_issues
WHERE kind IN ('gap', 'bad_price')
ORDER BY symbol, at;

-- DBNow is the database clock; known_at cutoffs compare against ingested_at,
-- which the database stamps, so both must come from the same clock.
-- name: DBNow :one
SELECT now()::timestamptz;
