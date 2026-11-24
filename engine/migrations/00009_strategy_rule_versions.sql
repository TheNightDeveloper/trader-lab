-- +goose Up
-- Each save appends a research version. Reports can refer to the version they actually ran.
CREATE TABLE strategy_rule_versions (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title text NOT NULL CHECK (char_length(title) BETWEEN 1 AND 100),
    content_hash text NOT NULL,
    definition jsonb NOT NULL,
    parent_id bigint REFERENCES strategy_rule_versions (id),
    other_parent_id bigint REFERENCES strategy_rule_versions (id),
    template_key text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (other_parent_id IS NULL OR (parent_id IS NOT NULL AND other_parent_id <> parent_id))
);

-- +goose Down
DROP TABLE strategy_rule_versions;
