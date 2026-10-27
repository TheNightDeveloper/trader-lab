#!/bin/sh
# Proves depguard is live: plants sim -> search import and expects lint to fail.
# Only removes the files it created; directories are removed only if left empty.
set -eu
cd "$(dirname "$0")/../engine"

probe_sim=internal/sim/zz_depguard_probe.go
probe_search=internal/search/zz_depguard_probe.go
if [ -e "$probe_sim" ] || [ -e "$probe_search" ]; then
  echo "probe file already exists; remove it first" >&2
  exit 1
fi
cleanup() {
  rm -f "$probe_sim" "$probe_search"
  rmdir internal/sim internal/search 2>/dev/null || true
}
trap cleanup EXIT

mkdir -p internal/sim internal/search
printf 'package search\n\nconst Probe = 1\n' > "$probe_search"
printf 'package sim\n\nimport "tradinglab/engine/internal/search"\n\nvar _ = search.Probe\n' > "$probe_sim"

if out=$(golangci-lint run ./internal/sim/... 2>&1); then
  echo "depguard did NOT reject sim -> search import" >&2
  exit 1
fi
echo "$out" | grep -q depguard || { echo "lint failed, but not via depguard:" >&2; echo "$out" >&2; exit 1; }
echo "depguard: bad import rejected (ok)"
