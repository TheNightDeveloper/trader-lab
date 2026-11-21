-- +goose Up
-- Keep bounded audit reads within the requested strategy version's history.
CREATE INDEX lifecycle_events_version_sequence ON lifecycle_events (version_id, id DESC);

-- +goose Down
DROP INDEX lifecycle_events_version_sequence;
