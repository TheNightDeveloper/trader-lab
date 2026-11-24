-- +goose Up
-- A long archive history should not slow down the latest feed lookup.
CREATE INDEX candles_rest_latest_idx ON candles (symbol, open_time DESC, revision DESC) WHERE source = 'rest';

-- +goose Down
DROP INDEX candles_rest_latest_idx;
