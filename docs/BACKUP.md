# Backup and restore

## Nightly backup (automatic)
The engine runs `pg_dump --format=custom --no-owner` once a day after `backup_hour_utc`
(default 02:00 UTC) into `backup_dir` (default `../backups`, relative to the engine's
working directory), as `lab-YYYYMMDD.dump`. The dump is written to a `.partial` file and
renamed only when complete; the newest `backup_keep` files (default 14) are kept. A failure
is logged (`nightly backup failed`) and retried on the next check (every 10 minutes).
Empty `backup_dir` disables it. `pg_dump` must be on PATH (PostgreSQL 18 client tools).

Manual backup at any time:

    pg_dump --format=custom --no-owner --file=backups/lab-manual.dump "postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable"

## Restore (disaster recovery)
1. Stop the engine.
2. The target database must be **UTF8** (Persian text in descriptions, names and summaries;
   a WIN1252 database rejects it — see the drill below). Create it empty if needed:
   `createdb -E UTF8 -T template0 lab` (as a role with CREATEDB).
3. Restore:

       pg_restore --exit-on-error --clean --if-exists --no-owner --no-privileges \
         -d "postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable" backups/lab-YYYYMMDD.dump

4. Verify before starting the engine:

       cd engine && go run ./cmd/verifydb -db "postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable"

   It re-hashes every dataset version (bars must still hash to their ID), re-checks every
   model artifact against its content ID, and prints row counts. It prints `OK` or `FAIL: …`.
5. Start the engine. Migrations newer than the dump are applied on start.

## Drill
`sh scripts/restore-drill.sh [dump-file]` restores into a throwaway cluster (temporary
directory, port 5499, current OS user — nothing changes on the real server), runs
`verifydb`, compares row counts of user-action tables with the source, and deletes the
cluster. With a file argument it restores that file (e.g. last night's backup).

| Date | Dump | Result |
|---|---|---|
| 2026-10-28 | live database, 8.8 MB | First run **failed**: `initdb` on Windows created a WIN1252 cluster and Persian text could not be restored. Fixed by creating the cluster and database as UTF8; documented above. |
| 2026-10-28 | live database, 8.8 MB | **OK**: 30 tables restored, 4 datasets re-hashed and verified, user-action tables equal to the source (6 reports, 804 decisions, 402 trades, 19 attempts, 6 versions), 315,891 candles. |
