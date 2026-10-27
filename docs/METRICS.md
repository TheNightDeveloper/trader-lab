# Metric and P&L definitions

Source of truth for every number the engine reports. Start from IMPLEMENTATION_PLAN.md §4 and expand each entry with: formula, units, frequency/annualization, minimum samples, invalid conditions, and the test that covers it.

## Valuation and display (M1)

### USDT valuation of an asset — `fx.ToUSDT`
- Formula: `amount × close(<ASSET>USDT)`, where the close is from the last 1m bar with
  `AvailableAt <= as_of`. USDT values itself.
- Units: USDT at scale 8. Rounding mode is chosen by the caller (ledger: Floor for
  holdings value).
- Invalid: no bar available yet → `ErrNoRate` (never a zero value).
- Test: `fx/TestToUSDTIdentityAndMissingPair`.

### Position value for a non-USDT pair — `fx.PositionUSDT`
- Formula: `qty × close(pair)` in the quote asset, then quote → USDT by `ToUSDT`.
  ETHBTC: `qty_ETH × close(ETHBTC) × close(BTCUSDT)`, both closes available at `as_of`.
- Test: `fx/TestETHBTCValuedWithRatesAvailableAtTheTime` (rate switches exactly at
  the new bars' `AvailableAt`).

### Toman display — `fx.ToToman`
- Formula: `usdt_value × rate(fx_rate_id)`, half-even to whole TOMAN (1 TOMAN = 10 IRR).
- Display/export only. Input must be USDT; the result never enters strategy, ledger,
  metrics or comparisons.
- Test: `fx/TestToToman`.

### Bar availability — `data.ParseKlinesCSV`, `data.Live`, `data.Resample`
- 1m bar from the archive: `AvailableAt = CloseTime + ingest_delay` (CloseTime exclusive = open + 1m).
- 1m bar from the live feed: `AvailableAt = max(CloseTime + ingest_delay, received_at)`; backfilled
  bars after an outage are late on purpose (ADR-011). Test: `data/TestLiveCatchUpOutageAndBackfill`.
- Resampled bar: `max(last member AvailableAt, bucket close + ingest_delay)`; only closed
  buckets are emitted, missing members set `FlagPartial`.
- Forward-filled bar (gap policy `ffill`): `O=H=L=C = previous close`, volume 0,
  `AvailableAt = CloseTime + ingest_delay`.

## Data quality rules (M1) — `data.Clean`, `data.Gaps`

| Issue | Rule | Effect |
|---|---|---|
| gap | expected 1m open time missing inside the data or at the requested range edges | reported; gap policy decides (flag / stop / ffill) |
| out_of_order | a row earlier than the row before it in the source | sorted, reported |
| duplicate | same open time twice in one source | first kept, reported |
| bad_price | any OHLC <= 0, or high/low not containing open/close, or negative volume | bar dropped (then also a gap), reported |
| zero_volume | run of >= 5 consecutive zero-volume bars | kept, reported once per run; shorter runs are normal on quiet pairs |
| correction | stored bar's values differ from a re-imported source | new revision, reported |
| outage | live feed failed and recovered | reported once per outage; bars backfilled with late availability |

Tests: `data/TestCleanDetectsPlantedProblems`, `data/TestZeroVolumeRuns`, `data/TestGapPolicies`,
`data/TestCorrectionCreatesNewVersionOldStaysReadable`.
