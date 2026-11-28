-- +goose Up
CREATE TABLE daily_review_status (
    singleton boolean PRIMARY KEY DEFAULT true CHECK (singleton),
    reminder_enabled boolean NOT NULL DEFAULT false,
    reviewed_day timestamptz CHECK (reviewed_day = date_trunc('day', reviewed_day, 'UTC'))
);
INSERT INTO daily_review_status DEFAULT VALUES;

CREATE INDEX market_opportunities_review_expiry ON market_opportunities (expires_at);

-- +goose Down
DROP INDEX market_opportunities_review_expiry;
DROP TABLE daily_review_status;
