# Metric and P&L definitions

P0 F08 execution scope (2026-11-02): application research is limited to known instruments
quoted in USDT, authorized by the server registry. Data/chart inspection and FX valuation
remain general. Display conversion alone does not establish quote funding or full cross-asset
execution. Historical saved figures remain readable; unsupported recomputation is rejected.
This eligibility gate leaves evaluation p0.3, training causal-features/v1 and golden outputs unchanged.

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
- Resampled bar (manifest `resample_version: 2`): maximum of all included members'
  `AvailableAt` and the bucket close plus the last member's ingest delay. When a later bar
  is the evidence that a partial bucket closed, its `AvailableAt` also bounds the result.
  Missing members set `FlagPartial`; trailing still-open buckets are not emitted.
- Old manifests (absent version or version 1) retain legacy reconstruction so their content
  hashes remain readable. Re-import/version the data to use corrected aggregation; reading
  a historical dataset does not retrofit its availability timestamps.
- Forward-filled bar (gap policy `ffill`): `O=H=L=C = previous close`, volume 0,
  `AvailableAt = CloseTime + ingest_delay`.

### Persistent dataset membership (P0 FIX-05)
- New manifests use `format_version: 1`, retain `resample_version: 2`, and record the raw
  member count. `dataset_members` pins each raw 1m open time and revision in one
  repeatable-read transaction; synthetic gap bars are derived, never raw members.
- Snapshot ID covers spec, raw and resampled values, close times and revision identities.
  Load checks membership/count/hash rather than rerunning a timestamp membership query.
  A late-committing ingest cannot change an existing new-format version.
- Legacy manifests with no format_version keep their original IDs and cutoff semantics.
  They are never silently upgraded; a newly created snapshot has a distinct ID namespace.
- Ingest stores later availability/closure changes as revisions. Same-value archive reimports
  cannot move a previously observed availability earlier. Concurrent revision allocation is
  serialized per symbol, and concurrent initial month partition creation is serialized.
- Test evidence includes late commits both hidden and visible in aggregation, metadata-only
  corrections, concurrent dedup/ingest, missing-member corruption, atomic write failure and
  a legacy-record migration down/up in an isolated schema. See ADR-046.

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
- New reports record `fill_model: "causal-next-open/v1"` and evaluation `p0.3`.
  Eligibility requires both a target bar index at least `LatencyBars` beyond the highest
  target index observed when deciding, and `OpenTime >= Decision.At`. The first qualifying
  bar processed fills at its open, provided `OpenTime <= Decision.At + IntentTTL`.
  A zero-delay close can share the next open's timestamp; a 2-second delay on 1m bars
  skips that already-open candle and fills at the following eligible open.
- Decision time is input `AvailableAt`; eligibility is the index/time/TTL predicate above;
  `Fill.Time` is the qualifying candle's `OpenTime`. This is a declared bar-open model,
  not a guarantee of executable live quotes. Default TTL is `(LatencyBars + 9)` input
  timeframes, not always ten wall-clock minutes.
- Delayed ranges cannot trigger stop/take exits against a newer position state. History
  contains all and only observed candles, sorted by open time, with capacity capped.
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

## Report metrics (M3) — `metrics.Compute`, all integer

Current evaluation p0.3 attributes equity changes and observed fill costs to `(start, end]`;
opening cohorts are `[start, end)`. Initial equity is the last mark at/before start; final
equity is the last mark at/before end. USDT at scale 8, ratios in ppm, Sharpe at scale 2.
`metrics.Compute` remains the standalone trade-statistics primitive; eval applies the period
ledger below. A last candle available after end is not retroactively marked into that period.

| Key | Formula | Invalid when |
|---|---|---|
| net_pnl, period_pnl | final equity − starting equity; includes carried positions | aggregate overflow |
| gross_pnl | period_pnl + period fees + period slippage | aggregate overflow |
| fees, slippage | costs of fills observed during (start, end], regardless of reference fill time | aggregate overflow |
| cohort_lifetime_pnl | Σ lifetime net of trades opened in [start, end), through the complete run end; may contain later exits | aggregate overflow |
| unrealized_pnl | as-of marked net of all still-open positions, including carried positions; not the lifetime value from a later close | overflow fails simulator valuation |
| final_equity | last equity mark (or the initial equity if none) | never |
| total_return | (final − initial) / initial, half-even | initial = 0 |
| max_drawdown | max over marks of (running peak − equity) / peak | never (0 if none) |
| max_drawdown_duration | longest time below a previous peak, to recovery or the end | never |
| sharpe | mean / sample sd of period returns × √periods_per_year; risk-free 0; period 24 h, 365 per year; equity sampled at each period end (last mark at or before it); returns at scale 9; math/big with an integer square root (10⁶ extra precision), truncated | < 30 samples, zero variance, equity ≤ 0 |
| exposure | length of the union of open-trade intervals ∩ window / window length | empty window |
| trades | count of observed trades opened in this cohort, open and closed | never |
| closed_trades | this cohort's trades with a close observed by end | never |
| win_rate | closed with net > 0 / closed | < 5 closed trades |
| profit_factor | Σ winning nets / −Σ losing nets | < 5 closed trades, or no losing trade |
| avg_win, avg_loss | mean net of winners / losers, half-even | < 5 closed trades, or none of that kind |
| best_trade, worst_trade | max / min closed net | no closed trade |
| avg_holding | mean (closed − opened) of closed trades, seconds | no closed trade |

Invalid metrics carry a Persian reason and **no value**; the UI shows «نامعتبر» with the
reason. Tests: `metrics/*` (Sharpe matches a float reference: 6.28 for the 40-day series).

## Walk-forward evaluation (M3) — `eval`

- Split: the range minus a final holdout share (default 20%) is cut into `folds + 1` equal
  chunks at bar boundaries; chunk 0 is the first train window, chunks 1..n are test windows.
  Train = everything before the test (expanding) or the previous chunk (rolling), minus the
  embargo. Folds never touch the holdout (property test).
- Main run: one continuous simulation from the first bar to the holdout start; intents before
  the first test window are dropped (warm-up primes indicators, never trades). Report metrics
  use the OOS window; fold metrics are slices of the same run (trades attributed to the fold in
  which they opened), so folds sum exactly to the report.
- Holdout run: separate simulation gated at the holdout start; stored, shown only through a
  logged view.
- Stress: fee × 2, slippage × 3, latency + 1 bar, same intents logic, same window.
- Parameter neighbourhood: the first two signal parameters at −10%, 0, +10% (integers ±max(1,
  round(10%))); total return per cell; stability = cells with positive return / valid cells.
- Benchmarks: buy-and-hold (equal split across symbols, bought at the OOS start) and cash.
- Verdict: «هنوز قابل اتکا نیست» below 30 closed OOS trades; otherwise by the sign of net.

## Calculator (M3) — `sim.CalcTrade`, `sim.BreakEvenExit`, `sim.BreakEvenFee`

- Single trade: buy quantity = floor(amount / ceil(entry × (1 + s))) at scale 8 (no lot
  rounding); both legs by the simulator leg math; return = net / (buy value + buy fee).
- Break-even exit: `entry × (1 + s)(1 + f) / ((1 − s)(1 − f))`, rounded up. This replaces the
  plan's `entry × (1 + s) / ((1 − f)² × (1 − s))`, which assumes the buy fee is taken from the
  coins; here the buy fee is charged on top in the quote asset (ADR-019). Per-leg rounding can
  leave the net a few units from zero (test: within 3 units).
- Break-even fee of a run: `(gross − slippage) / Σ leg values (USDT)`, floored; undefined when
  gross − slippage ≤ 0. Holds trades and slippage fixed.
- Recalculate: replays the recorded OOS intents with overridden capital, fee, slippage and a
  position-size multiplier on non-zero targets (capped at 100%). With no overrides it
  reproduces the report fill for fill (tests: `eval/TestReplayReproducesNetExactly`,
  `report/TestCreateLoadViewRecalculate`, `api/TestReportAndPnlServices`).
- Toman: only for an explicit stored rate id, `usdt × rate`, half-even to whole TOMAN; USDT
  values and stored reports are identical across rates (`api/TestReportAndPnlServices`).

## Experiments and search (M4) — `search`

- Candidates: grid = every combination of the listed values, parameters in the version's
  declared order; random = seeded PCG draws without repeats, at most
  `max_attempts / pairs` candidates. Parameters not in the space keep the version defaults.
  At most 5,000 candidates; candidates × pairs must fit the attempt budget, checked before
  anything is queued.
- Attempt = one candidate on one pair (one dataset version). Statuses: queued, running,
  done, failed, cancelled. Every attempt counts toward "attempts" shown with a winner.
- FIX-05: cancellation durably closes every queued/running row, even if its worker missed
  the notification. Current claim tokens fence completion and failure. Recovery resumes
  running/paused work, cancels terminal-experiment orphans, and preserves retry runs.
  A per-schema scheduler session lock protects recovery from another live scheduler.
  Computation may repeat after interruption; the registry/result effect is conditional
  and idempotent. Terminal learning cycles retain no queued candidate; partial generation
  counts come from the actual durable rows. See ADR-047.
- Hard constraints (`Check`): each is `metric >= value` or `metric <= value`, compared as
  integers at the metric's own scale (ratios as fractions: 0.25 = 25%). An invalid metric
  (too few samples) fails its constraint: an unknown value never satisfies a hard limit.
- Selection (`Select`): a candidate is eligible only if every one of its attempts is done
  and passes every constraint. Among eligible candidates, the objective is the mean of the
  objective metric over its pairs (integer, half-even); maximize or minimize as declared.
  Ties go to the lower candidate number. No eligible candidate is a valid result with a
  Persian reason. The winner carries `Origin{experiment, attempts, candidates}` into its
  report, and Compare uses that attempt count.
- Run cache key: SHA-256 of JSON `{v, engine build hash (SHA-256 of the binary), dataset
  ids (content hashes), timeframe, strategy, every parameter, normalized sim config (capital,
  fee, slippage, latency, TTL, sizing), split plan}`. A cached OOS result is reused only on
  an exact key match (test `search/TestCacheKeyCoversEveryInput`, 17 single-input
  variations, all distinct). Constraints and objective are not run inputs; they are
  re-applied to cached metrics.
- Estimate (Builder, display only): `max bars of the chosen datasets × attempts × 700 ns /
  research slots`, at least 1 s. 700 ns/bar comes from the 1M-bar benchmark.
- Research slots: `floor(cpus × share%)`, at most `cpus − 1` when there is more than one
  CPU, at least 1. Default share 75%.

## Learning (M5) — `feature`, `model`, `model/train`, `loop`

Floats are allowed here (model math); nothing in this section touches the ledger.

### Features (of bar i, computed from its trailing history only)
Availability is the maximum AvailableAt of the trailing Lookback window, including bar i;
a late earlier dependency cannot be hidden by the final bar's timestamp.
- `ret_k` (k = 1, 4, 24, 72): `close[i] / close[i−k] − 1`. k counts bars, not hours: with
  gaps (gap policy "flag") the window spans more time.
- `vol_24`: population standard deviation of the last 24 one-bar simple returns.
- `rsi_14`: Σgains / (Σgains + Σlosses) over the last 14 close changes, as a fraction 0..1
  (simple averages, not Wilder smoothing); 0.5 when flat.
- `sma_gap_24`: `close / mean(last 24 closes) − 1`.
- `range_24`: `(max high − min low) over 24 bars / close`.

### Labels
- Forward return over the recipe horizon h: `close[i+h] / close[i] − 1`, `ReadyAt` =
  maximum availability of bars i and i+h. A training row enters a fit only if its features and label were
  available at the fit's as-of time; fits re-check this and fail otherwise (look-ahead).

### Models
- Transform: z-score per feature, fit on the training rows only (a constant feature gets
  spread 1, i.e. stays 0).
- Ridge: `(ZᵀZ + α·n·I) w = Zᵀ(y − ȳ)`, intercept ȳ (not penalized). Predicts the h-bar
  forward return. Solved by Cholesky (gonum).
- Logistic: P(y > 0), L2 `α·n` on the weights (not the intercept), Newton/IRLS, ≤ 50 steps,
  stop when the largest step < 1e−10.
- Train error (registry only): RMSE (ridge) or mean log loss (logistic), in sample.
- Signal: long `exposure` when prediction > `entry`, and (if a filter is set) the
  standardized filter feature ≤ `max`; flat otherwise. Intents only on change.
- Minimum samples per fit: max(30, 10 × features).
- Saved models reproduce predictions within 1e−12 (in practice exactly: JSON float64
  round-trips). Artifact id = `m_` + first 16 hex of SHA-256 of its JSON without the id.

### Walk-forward with retraining (learning cycle)
FIX-04 / p0.3: fold net P&L is period equity change. Lifetime opening-cohort PnL is
separate and may change with future exits; it never determines a past fold's win.
- Range: `[now − lookback, end)`, end = `now − 1 bar`, truncated to the timeframe.
- Test region starts after the first fifth of the range (minimum training), or after the
  end of the last forward window used in a decision, whichever is later; it is cut into
  `folds` equal windows (≥ 24 bars each). Training is expanding from the range start to each
  test start minus an embargo of h bars. One model per fold, valid from its test start.
- One continuous simulator run over the region (ADR-017); folds are windows of it.
- Candidate eligible: walk-forward max drawdown ≤ gate cap, return valid and greater than the
  champion's (retrained the same way on the same folds). Challenger = eligible candidate with
  the highest walk-forward return (ties: lower number). Fold wins require valid period_pnl
  exceeding the champion's over exactly the same test start/end. Missing evidence is not zero.

### Candidates (bounded, one change each, fixed order)
Add each missing feature; drop each feature (when more than two, never the filter feature);
filter max ±0.5 or no filter (or add `vol_24 ≤ 1` when absent); α × 0.1 and × 10; entry × 0.5
and × 2 (logistic: ± 0.02). Duplicates and the parent are left out; capped at the candidate
budget.

### Forward test and gate
FIX-04 / p0.3 records training_cutoff, actual model_created_at, freeze_at and trade_start
separately. Final training uses only labels ready at cutoff; model AsOf is completion time.
- Freeze is recorded after final training and model persistence. The champion keeps its
  active model (or gets a baseline); neither is scored before the next timeframe boundary
  at/after actual freeze. Learned warm-up never consumes the first tradable intent.
- Forward is bounded to trade_start + configured days. Days count the contiguous common
  prefix of complete, non-synthetic available candles across all configured symbols.
  Missing/partial data keeps it pending even after the wall-clock deadline; backfill can
  complete the same fixed window. Missing symbols are retained in the cycle's progress.
- Legacy cycles with old fold/freeze evidence cannot promote; old records remain readable.
- Gate (copied into the cycle at its start): forward and walk-forward drawdown ≤ cap;
  `forward return(challenger) − forward return(champion) ≥ min improvement`;
  `forward drawdown(challenger) − forward drawdown(champion) ≤ max degradation`;
  forward trades ≥ minimum; forward days ≥ test length; fold wins ≥ minimum. Trades and days
  are "pending" until met; at the decision anything not passed fails. All pass → recommend.
  Improvement failed → "not better"; otherwise the first failed item is the reason.
- CPU budget = research-slot minutes (wall time while holding a slot), checked before each
  candidate starts; candidates beyond it are recorded as cancelled.

## Chart indicators (M6) — `strategy.ComputeIndicator`

Computed by the engine over closes (float64, display/model math), with the same code the
strategies use; values are sent as decimal strings with 8 decimals, "" while undefined.
Indicators are computed over all bars of the source before the response keeps the last
`max_bars`, so the first shown values are already warmed up.
- `ma:n`: simple mean of the last n closes.
- `ema:n`: trend-ema's EMA: seeded with the simple mean of the first n closes, then
  `e += 2/(n+1) × (close − e)`.
- `bb:n:k`: mean-rev-bands' band: population mean and standard deviation of the last n
  closes (summed in ring-buffer order, as the strategy does); upper/lower = mean ± k·sd.
- `rsi:n`: Wilder's RSI, 0..100: first average = mean of the first n gains/losses, then
  `avg = (avg × (n−1) + x) / n`; 50 when there was no movement.
- `macd:f:s:g`: `EMA(f) − EMA(s)`; signal = EMA(g) of that line; histogram = line − signal.
- Parity: trend-ema decides exactly where the chart's EMA lines cross, mean-rev-bands exactly
  where the close re-enters the chart's lower band or reaches its middle
  (`strategy/TestIndicatorParityWithStrategies`); the API returns these values unchanged
  (`api/TestChartService`); the chart's indicator `calc` returns the engine values per bar and
  computes nothing (`app/test/chart_test.dart`).

### Markers
- Filled decision with target > 0 → entry (B); filled with target 0 → exit (S); rejected or
  expired → × . Placed on the bar the decision was made on, at its close. Stop-loss and
  take-profit exits (no decision) are exits on the bar they happened.
- Report charts end at the out-of-sample end: the holdout stays hidden.


## P0 evaluation compatibility (2026-11-01)
The first P0 batch introduced `evaluation_version: "p0.1"`. Buy-and-hold's trading state
is no longer advanced in pre-OOS or pre-holdout warm-up. Historical results remain immutable;
an absent evaluation version means legacy. Comparison blocks evaluation-version differences,
uses exact ppm costs, UTC timestamps and normalized split settings, and shows four decimal
places for cost percentages so a 1 ppm difference stays visible.

The second batch uses `evaluation_version: "p0.2"` for causal fills and marks equity at
closed-bar availability, so a delayed old candle cannot backdate a new equity point or
replace a newer close. Reports from any older evaluation version get a read-time legacy
badge and cannot be compared as current evaluations. Stored reports are never rewritten.
Period/cohort attribution (F05) and actual forward freeze/coverage (F04) were superseded
by p0.3 / FIX-04 on 2026-11-02 (ADR-044/045). F08 now restricts application research to
known USDT pairs (ADR-049); full cross-asset execution remains a later capability.

### Report provenance and reproduction (2026-11-03)
New specs record provenance v1: executable SHA-256, available VCS/compiler/platform metadata,
dataset hashes/manifests, used instrument specs and explicit policy versions (ADR-051).
The existing spec JSON export includes this metadata. Unknown metadata stays unknown.
Reproduce requires matching build/release/context, exact JSON numbers and ordered canonical
trade/fill/decision records in both main and holdout, including summary/spec/split consistency.
Record timestamps use PostgreSQL UTC microsecond precision. Equal PnL alone is insufficient;
a different binary is not certified identical even if totals match. Reproduce and calculator
replay pin recorded instrument filters; legacy calculator replay remains unpinned and warned.
Comparison blocks differing build/instrument/policy contexts using full SHA-256 identities,
not their shortened display. Historical results remain immutable. No metric formula changes;
evaluation stays p0.3, with the same simulator goldens and training version.

## P0 training and selection compatibility (2026-11-01)
- New fits record `training_version: causal-features/v1` in their content-addressed artifact.
  Feature availability is the maximum over its trailing Lookback window; label readiness is
  the maximum of its two endpoint availabilities. Both must be <= asOf. Fit rejects samples
  outside its declared [from, to), non-finite inputs and inconsistent dimensions.
- Legacy valid artifacts with no training_version retain their IDs and remain readable. They
  are not retroactively retrained. Old binaries may reject new-version artifact hashes.
- Prediction arithmetic and decision explanations are preserved; work for unchanged-target
  explanations is removed. Recipe/model validation rejects malformed numbers before execution.
- Search means use wide integer sums and half-even rounding. Only candidates with every
  registered dataset exactly once, valid scale and eligible completed results can win;
  ties use the lowest candidate number, independent of row order.
- The h-bar label still measures close-to-close price return, not executable net PnL. With
  delayed availability and h=1 its endpoint may be at/before the earliest causal fill. Aligning
  that target with execution/costs requires a separate versioned change and OOS validation.
