-- +goose Up
-- Annotations are versioned independently of the immutable execution evidence.
CREATE TABLE paper_journal_notes (
    entry_id    bigint      NOT NULL REFERENCES paper_entries,
    revision    bigint      NOT NULL CHECK (revision > 0),
    body        text        NOT NULL CHECK (char_length(body) <= 1000),
    recorded_at timestamptz NOT NULL,
    PRIMARY KEY (entry_id, revision)
);

-- +goose Down
DROP TABLE paper_journal_notes;
