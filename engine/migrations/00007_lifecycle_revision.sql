-- +goose Up
-- Serializes user lifecycle decisions and rejects stale/ABA requests.
ALTER TABLE algorithms ADD COLUMN lifecycle_revision bigint NOT NULL DEFAULT 0 CHECK (lifecycle_revision >= 0);
ALTER TABLE promotions ADD COLUMN lifecycle_revision bigint NOT NULL DEFAULT 0;
-- Fail on ambiguous legacy state rather than choosing a champion silently.
CREATE UNIQUE INDEX algorithm_one_active_version ON algorithm_versions (algorithm_id) WHERE state = 'active';

-- +goose Down
DROP INDEX algorithm_one_active_version;
ALTER TABLE promotions DROP COLUMN lifecycle_revision;
ALTER TABLE algorithms DROP COLUMN lifecycle_revision;
