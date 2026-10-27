#!/bin/sh
# CI: generated code is current, lint, tests (race), golden scenarios.
set -eu
cd "$(dirname "$0")/.."
RACE="${RACE--race}"

buf lint
buf generate
(cd engine && sqlc generate)
if [ -d .git ] && ! git diff --quiet -- engine/internal/gen engine/internal/store/db app/lib/gen; then
  echo "generated code is stale: run 'make gen' and commit" >&2
  exit 1
fi

(cd engine && gofmt -l . | grep -v '^internal/gen' | (! grep .)) || { echo "gofmt needed" >&2; exit 1; }
(cd engine && golangci-lint run ./...)
sh scripts/check-depguard.sh
(cd app && dart analyze --fatal-infos)

(cd engine && go test $RACE ./...)
(cd engine && go test $RACE -run Golden ./...)
(cd app && flutter test)
echo "ci: ok"
