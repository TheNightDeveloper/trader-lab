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

## Simulator fill model and P&L (M2) — `sim`

All values are int64 at scale 8; rates (fee, slippage, target) are parts per million
(`money.Ratio`, 1 bps = 100). Rounding is always against the trader.

### Fill reference and timing
- A decision is made when its input bar becomes available (`AvailableAt`).
- It fills at the open of the bar `LatencyBars` (default 1) after the decision bar of the
  same instrument; a bar that had already closed at decision time is skipped (late,
  backfilled data never fills in the past). Unfilled after `IntentTTL` (default 10 m) → expired.
- Bars available at the same instant are processed in three phases: fills and exits
  (valued with earlier closes only), then closes are recorded, then strategies decide.

### One leg (quote asset)
| | buy | sell |
|---|---|---|
| fill price | `ceil(ref × (1 + slip))` | `floor(ref × (1 − slip))` |
| ref value | `ceil(qty × ref)` | `floor(qty × ref)` |
| value | `ceil(qty × price)` | `floor(qty × price)` |
| slippage | `value − ref value` | `ref value − value` |
| fee | `ceil(fee_rate × value)` | `ceil(fee_rate × value)` |
| cash | `−(value + fee)` | `value − fee` |

Each leg is also stored in USDT: `ref value`, `slippage` and `fee` are each converted at the
quote→USDT cross rate available at fill time (half-even). For USDT pairs the rate is 1.

### Trade (round trip, flat → flat), USDT
- `entry cost = Σ buys (ref + slippage + fee)`, `exit proceeds = Σ sells (ref − slippage − fee)`
- `gross = Σ exit ref − Σ entry ref` (difference of the rounded leg ref values)
- `slippage = Σ leg slippage`, `fees = Σ leg fees`, `net = exit proceeds − entry cost`
- `net = gross − slippage − fees` holds exactly by construction and is checked on every close.
- Open at the end: the open quantity is marked at the last close with no exit costs
  (`mark_value`); gross and net are unrealized and obey the same identity.
- Tests: `sim/TestRoundTripFillsAtNextOpen` (hand-checked), `sim/TestLedgerReconcilesProperty`
  (1,000 random runs), golden `round-trip-fees`.

### Sizing
- Target exposure `t ∈ [0, 1]`; base = current equity (default, compounding) or `fixed_usdt`.
- `delta = t × base − position value at the fill reference` (USDT).
- Buy quantity = `floor_lot(delta / price)`, capped by free cash of the quote asset
  (`balance − coins backing open positions`) including the fee; must meet min notional.
- Sell quantity = `floor_lot(|delta| / ref)`, capped at the position; `t = 0` sells everything.
  Min notional is enforced on entries, increases and partial reductions, not on full exits.

### Stop / take
- Levels from the entry fill price: `stop = floor(fill × (1 − stop_loss))`,
  `take = ceil(fill × (1 + take_profit))`; exits sell the whole position.
- Exit reference: stop `min(stop, open)`, take `max(take, open)` (a gap through the level
  fills at the open). Both inside one bar → stop assumed, `ambiguous` flagged on fill and trade.

### Equity
- Marked at every batch close: cash in each asset via `<ASSET>USDT`, positions via their own
  pair then quote → USDT, all with prices available at that moment (Floor).
- Points are skipped while some held asset has no rate yet; the run fails only if the final
  equity cannot be valued.
