DATABASE_URL ?= postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable
# -race needs cgo (gcc on Windows). Without it: make test RACE=
RACE ?= -race

.PHONY: dev-db gen migrate test lint golden run ci web

dev-db:
	docker compose up -d --wait db

gen:
	buf lint
	buf generate
	cd engine && sqlc generate

migrate:
	cd engine && goose -dir migrations postgres "$(DATABASE_URL)" up

test:
	cd engine && go test $(RACE) ./...
	cd app && flutter test

lint:
	cd engine && golangci-lint run ./...
	sh scripts/check-depguard.sh
	cd app && dart analyze --fatal-infos

golden:
	cd engine && go test $(RACE) -run Golden ./...

web:
	cd app && flutter build web --release --no-web-resources-cdn

run: web
	cd engine && go run ./cmd/engine

ci:
	sh scripts/ci.sh
