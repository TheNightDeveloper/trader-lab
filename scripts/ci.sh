#!/bin/sh
# CI: generated code is current, lint, tests (race), golden scenarios.
set -eu
cd "$(dirname "$0")/.."
# CI must fail rather than silently skip DB tests or disable the race detector.
export REQUIRE_DB=1
mkdir -p artifacts
python3 -m unittest discover -s scripts -p '*_test.py'

buf lint
buf generate
(cd engine && sqlc generate)
if [ -n "$(git status --porcelain --untracked-files=all -- engine/internal/gen engine/internal/store/db app/lib/gen)" ]; then
  echo "generated code is stale: run 'make gen' and commit" >&2
  exit 1
fi

(cd engine && gofmt -l . | grep -v '^internal/gen' | (! grep .)) || { echo "gofmt needed" >&2; exit 1; }
(cd engine && golangci-lint run ./...)
sh scripts/check-depguard.sh
(cd app && dart analyze --fatal-infos)

# Save JSON before summarizing so a failed pipeline cannot hide the Go exit status.
status=0
(cd engine && go test -count=1 -race -json ./...) > artifacts/go-tests.jsonl || status=$?
python3 scripts/test_summary.py artifacts/go-tests.jsonl || status=1
[ "$status" -eq 0 ] || exit "$status"
(cd engine && go test -count=1 -race -run Golden ./...)
(cd app && flutter test)
echo "ci: ok (database required, race enabled)"
