#!/bin/sh
# Proves depguard is live: plants an import of the optimizer (search) in a fresh
# package under internal/sim and expects lint to fail through depguard. A
# sub-package is used because search itself imports sim: a probe in sim would be
# an import cycle, not a depguard finding.
set -eu
cd "$(dirname "$0")/../engine"

dir=internal/sim/zzdepguardprobe
if [ -e "$dir" ]; then
  echo "$dir already exists; remove it first" >&2
  exit 1
fi
cleanup() { rm -rf "$dir"; }
trap cleanup EXIT

mkdir -p "$dir"
printf 'package zzdepguardprobe\n\nimport "tradinglab/engine/internal/search"\n\nvar _ = search.MaxCandidates\n' > "$dir/probe.go"

if out=$(golangci-lint run "./$dir/..." 2>&1); then
  echo "depguard did NOT reject an optimizer import under internal/sim" >&2
  exit 1
fi
echo "$out" | grep -q depguard || { echo "lint failed, but not via depguard:" >&2; echo "$out" >&2; exit 1; }
echo "depguard: bad import rejected (ok)"
