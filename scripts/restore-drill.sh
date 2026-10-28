#!/bin/sh
# Backup/restore drill (plan M6.5). Dumps the database, restores the dump into a
# throwaway PostgreSQL cluster (temporary directory and port, run as the current
# OS user: nothing changes on the real server), verifies the copy with
# cmd/verifydb (dataset and model content hashes, row counts), compares counts
# with the source, and deletes the cluster. Needs pg_dump, pg_restore, initdb,
# pg_ctl and createdb on PATH.
#
#   sh scripts/restore-drill.sh [dump-file]
# With a dump file, restores that file (e.g. last night's backup) instead.
set -eu
SRC=${DATABASE_URL:-postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable}
PORT=${DRILL_PORT:-5499}
cd "$(dirname "$0")/../engine"
work=$(mktemp -d)
cleanup() {
  pg_ctl -D "$work/data" -m fast stop >/dev/null 2>&1 || true
  rm -rf "$work"
}
trap cleanup EXIT

dump=${1:-}
if [ -z "$dump" ]; then
  dump="$work/lab.dump"
  pg_dump --format=custom --no-owner --file="$dump" "$SRC"
fi
echo "dump: $dump ($(wc -c <"$dump") bytes)"
go run ./cmd/verifydb -db "$SRC" >"$work/source.txt"

# UTF8 explicitly: initdb on Windows defaults to WIN1252, which cannot hold
# Persian text (the first drill failed on exactly that).
initdb -D "$work/data" -U drill -A trust -E UTF8 --no-locale >/dev/null
pg_ctl -D "$work/data" -o "-p $PORT" -l "$work/pg.log" -w start >/dev/null
createdb -h 127.0.0.1 -p "$PORT" -U drill -E UTF8 -T template0 lab
pg_restore --exit-on-error --no-owner --no-privileges -h 127.0.0.1 -p "$PORT" -U drill -d lab "$dump"
go run ./cmd/verifydb -db "postgres://drill@127.0.0.1:$PORT/lab?sslmode=disable" >"$work/restored.txt"

# Tables the engine changes only on user actions must match exactly. Live
# ingestion may add candles between the dump and the source count, so those are
# reported, not compared. (Skipped when restoring an older dump file.)
if [ -z "${1:-}" ]; then
  for t in datasets reports trades fills decisions experiments attempts learning_cycles \
    cycle_candidates model_artifacts promotions lifecycle_events fx_rates algorithm_versions; do
    a=$(grep "^table $t " "$work/source.txt" || true)
    b=$(grep "^table $t " "$work/restored.txt" || true)
    if [ "$a" != "$b" ]; then
      echo "MISMATCH $t: source '$a', restored '$b'"
      exit 1
    fi
  done
fi
cat "$work/restored.txt"
echo "restore drill: OK"
