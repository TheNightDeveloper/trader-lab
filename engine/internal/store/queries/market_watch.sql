-- name: LatestMarketCandles :many
-- Read the bounded watchlist in one statement so it shares a DB snapshot.
SELECT candle.symbol, candle.open_time, candle.close_time, candle.available_at, candle.revision, candle.c
FROM unnest(@symbols::text[]) AS watched(name)
CROSS JOIN LATERAL (
    SELECT symbol, open_time, close_time, available_at, revision, c
    FROM candles
    WHERE symbol = watched.name AND source = 'rest'
      AND open_time < @as_of AND close_time <= @as_of AND available_at <= @as_of
    ORDER BY open_time DESC, revision DESC
    LIMIT 1
) AS candle;
