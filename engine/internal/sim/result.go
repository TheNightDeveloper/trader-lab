package sim

import (
	"time"

	"tradinglab/engine/internal/money"
)

// Outcome of a decision.
type Outcome string

const (
	OutcomeFilled     Outcome = "filled"
	OutcomeRejected   Outcome = "rejected"
	OutcomeExpired    Outcome = "expired"
	OutcomeSuperseded Outcome = "superseded"
	OutcomeNoChange   Outcome = "no_change"
	OutcomeUnfilled   Outcome = "unfilled" // run ended before a fill was possible
)

// Decision records every intent, accepted or not.
type Decision struct {
	ID int `json:"id"`
	// At is the virtual time of the decision (the input bar's AvailableAt).
	At time.Time `json:"at"`
	// The input snapshot: the bar the strategy was called with.
	InputSymbol   string      `json:"input_symbol"`
	InputBarOpen  time.Time   `json:"input_bar_open"`
	Instrument    string      `json:"instrument"`
	Target        money.Ratio `json:"target"`
	StopLoss      money.Ratio `json:"stop_loss"`
	TakeProfit    money.Ratio `json:"take_profit"`
	Reason        string      `json:"reason"`
	ModelID       string      `json:"model_id,omitempty"`
	RecipeVersion string      `json:"recipe_version,omitempty"`
	Outcome       Outcome     `json:"outcome"`
	Detail        string      `json:"detail,omitempty"`
}

type Side string

const (
	Buy  Side = "buy"
	Sell Side = "sell"
)

// Fill is one execution. Quote-asset amounts plus their USDT values at fill time.
type Fill struct {
	DecisionID int          `json:"decision_id,omitempty"` // 0 for stop/take exits
	Time       time.Time    `json:"time"`
	Instrument string       `json:"instrument"`
	Side       Side         `json:"side"`
	Kind       string       `json:"kind"` // signal | stop | take
	Qty        money.Qty    `json:"qty"`
	RefPrice   money.Price  `json:"ref_price"`
	Price      money.Price  `json:"price"`
	RefValue   money.Amount `json:"ref_value"`
	Value      money.Amount `json:"value"`
	Slippage   money.Amount `json:"slippage"`
	Fee        money.Amount `json:"fee"`
	// USDT at the cross rate available at fill time.
	RefValueUSDT money.Amount `json:"ref_value_usdt"`
	SlippageUSDT money.Amount `json:"slippage_usdt"`
	FeeUSDT      money.Amount `json:"fee_usdt"`
	Ambiguous    bool         `json:"ambiguous,omitempty"` // stop and take both inside the bar; stop assumed
}

// Trade is one round trip, flat → flat, in USDT. Net = Gross − Slippage − Fees exactly.
// For a trade still open at the end, Gross and Net are unrealized: the open
// quantity is marked at the last close with no exit costs.
type Trade struct {
	Instrument    string       `json:"instrument"`
	OpenedAt      time.Time    `json:"opened_at"`
	ClosedAt      *time.Time   `json:"closed_at"` // nil while open
	Qty           money.Qty    `json:"qty"`       // total bought
	EntryRef      money.Amount `json:"entry_ref"`
	ExitRef       money.Amount `json:"exit_ref"`
	Gross         money.Amount `json:"gross"`
	Slippage      money.Amount `json:"slippage"`
	Fees          money.Amount `json:"fees"`
	Net           money.Amount `json:"net"`
	ExitReason    string       `json:"exit_reason,omitempty"`
	AmbiguousBars int          `json:"ambiguous_bars,omitempty"`
	// Open trades only: remaining quantity valued at the last close (no exit costs).
	OpenQty   money.Qty     `json:"open_qty"`
	MarkValue *money.Amount `json:"mark_value,omitempty"`
}

type EquityPoint struct {
	Time   time.Time    `json:"time"` // bar close
	Equity money.Amount `json:"equity"`
}

type Balance struct {
	Asset  string       `json:"asset"`
	Amount money.Amount `json:"amount"`
}

type Result struct {
	Decisions     []Decision    `json:"decisions"`
	Fills         []Fill        `json:"fills"`
	Trades        []Trade       `json:"trades"`
	Equity        []EquityPoint `json:"equity"`
	Balances      []Balance     `json:"balances"`
	FinalEquity   money.Amount  `json:"final_equity"`
	AmbiguousBars int           `json:"ambiguous_bars"`
	Bars          int           `json:"bars"`
}
