-- +goose Up
ALTER TABLE shadow_deployments
    ADD COLUMN user_track boolean NOT NULL DEFAULT false,
    ADD COLUMN model_input_per_million bigint,
    ADD COLUMN model_output_per_million bigint,
    ADD CHECK ((model_input_per_million IS NULL) = (model_output_per_million IS NULL)),
    ADD CHECK (model_input_per_million >= 0 AND model_output_per_million >= 0);

CREATE TABLE shadow_user_decisions (
    hour_id bigint PRIMARY KEY REFERENCES shadow_hours,
    allow boolean NOT NULL,
    decided_at timestamptz NOT NULL
);

-- +goose Down
-- The prerequisite prevents discarding recorded user decisions or frozen rates.
-- +goose StatementBegin
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM shadow_deployments WHERE user_track OR model_input_per_million IS NOT NULL) THEN
        RAISE EXCEPTION 'shadow attribution settings already recorded';
    END IF;
END $$;
-- +goose StatementEnd
DROP TABLE shadow_user_decisions;
ALTER TABLE shadow_deployments DROP COLUMN user_track, DROP COLUMN model_input_per_million, DROP COLUMN model_output_per_million;
