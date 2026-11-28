-- +goose Up
-- Existing decision evidence may predate the engine-build fields.
ALTER TABLE market_opportunities ADD COLUMN engine_build_sha256 text NOT NULL DEFAULT '';
ALTER TABLE paper_confirmation_evidence ADD COLUMN engine_build_sha256 text NOT NULL DEFAULT '';

-- +goose Down
ALTER TABLE paper_confirmation_evidence DROP COLUMN engine_build_sha256;
ALTER TABLE market_opportunities DROP COLUMN engine_build_sha256;
