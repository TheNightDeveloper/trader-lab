-- +goose Up
-- Exact rule-version evidence also works for reports stored before this index.
CREATE INDEX reports_rule_version_created_idx
    ON reports ((spec->>'rule_version_id'), created_at DESC, id)
    WHERE (spec->>'rule_version_id') IS NOT NULL;

-- +goose Down
DROP INDEX reports_rule_version_created_idx;
