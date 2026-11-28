package api

import (
	"context"
	"errors"
	"fmt"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
)

const paperAccountID = "paper-usdt"

type Paper struct{ Market *Market }

func paperAccountRef() *labv1.AccountRef {
	return &labv1.AccountRef{Environment: labv1.Environment_ENVIRONMENT_PAPER, AccountId: paperAccountID}
}

func paperAccountMatches(ref *labv1.AccountRef) bool {
	return ref.GetEnvironment() == labv1.Environment_ENVIRONMENT_PAPER && ref.GetAccountId() == paperAccountID
}

func (p *Paper) GetPaperAccount(ctx context.Context, _ *connect.Request[labv1.GetPaperAccountRequest]) (*connect.Response[labv1.GetPaperAccountResponse], error) {
	book, err := p.readPaperBook(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(book), nil
}

func (p *Paper) SetPaperEntryPause(ctx context.Context, req *connect.Request[labv1.SetPaperEntryPauseRequest]) (*connect.Response[labv1.SetPaperEntryPauseResponse], error) {
	if !paperAccountMatches(req.Msg.GetAccount()) || req.Msg.Paused == nil {
		return nil, invalid("حساب مجازی و وضعیت ورود را مشخص کنید")
	}
	paused := req.Msg.GetPaused()
	err := p.Market.Store.InTx(ctx, func(q *db.Queries) error {
		if err := q.LockPaperAccount(ctx, paperAccountID); err != nil {
			return err
		}
		wasPaused, err := q.PaperEntriesPaused(ctx, paperAccountID)
		if errors.Is(err, pgx.ErrNoRows) {
			return connect.NewError(connect.CodeNotFound, errors.New("حساب مجازی پیدا نشد"))
		}
		if err != nil {
			return err
		}
		now := p.Market.Clock.Now()
		if wasPaused && !paused {
			// A resume admits only candles opened after the resume decision.
			if err := q.SkipPausedPaperCandles(ctx, db.SkipPausedPaperCandlesParams{AccountID: paperAccountID, ResumeAt: firstFullPaperMinute(now)}); err != nil {
				return err
			}
		}
		return q.SetPaperEntryPause(ctx, db.SetPaperEntryPauseParams{ID: paperAccountID, Paused: paused, RecordedAt: now})
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.SetPaperEntryPauseResponse{Paused: paused}), nil
}

func (p *Paper) InitializePaperAccount(ctx context.Context, req *connect.Request[labv1.InitializePaperAccountRequest]) (*connect.Response[labv1.InitializePaperAccountResponse], error) {
	input := req.Msg
	readings := []*labv1.Money{input.GetCapital(), input.GetMaxLossPerTrade(), input.GetMaxOpenLoss(), input.GetMaxSpotExposure()}
	var amounts [4]int64
	for i, reading := range readings {
		amount, present, err := usdtIn(reading, "paper policy")
		if err != nil || !present || amount.V <= 0 {
			return nil, invalid("سرمایه و حدود ریسک باید مبلغ مثبت USDT باشند")
		}
		amounts[i] = amount.V
	}
	capital, maxLoss, maxOpenLoss, maxExposure := amounts[0], amounts[1], amounts[2], amounts[3]
	if maxLoss > maxOpenLoss || maxOpenLoss > maxExposure || maxExposure > capital {
		return nil, invalid("سقف زیان هر معامله باید حداکثر برابر زیان باز، سقف زیان باز حداکثر برابر سقف مواجهه و مواجهه حداکثر برابر سرمایه باشد")
	}
	now := p.Market.Clock.Now()
	var row db.ReadPaperAccountRow
	err := p.Market.Store.InTx(ctx, func(q *db.Queries) error {
		inserted, err := q.InitializePaperAccount(ctx, db.InitializePaperAccountParams{ID: paperAccountID, CreatedAt: now, InitialCapital: capital})
		if err != nil {
			return err
		}
		if inserted == 1 {
			// Funding and the initial risk policy become visible with the account.
			err = q.InsertPaperPolicy(ctx, db.InsertPaperPolicyParams{
				AccountID: paperAccountID, Revision: 1, EffectiveAt: now, MaxLoss: maxLoss, MaxOpenLoss: maxOpenLoss,
				MaxExposure: maxExposure, FeePpm: 1_000, SlippagePpm: 1_000, MaxCostPpm: 10_000, EntryDriftPpm: 5_000,
			})
			if err != nil {
				return err
			}
			if err := q.InsertPaperPosting(ctx, db.InsertPaperPostingParams{
				AccountID: paperAccountID, EventKey: "initial-funding", RecordedAt: now, Asset: "USDT",
				Source: "clearing", Destination: "available", Amount: capital,
			}); err != nil {
				return err
			}
		}
		row, err = q.ReadPaperAccount(ctx, paperAccountID)
		if err != nil {
			return err
		}
		if row.InitialCapital != capital || row.MaxLoss != maxLoss || row.MaxOpenLoss != maxOpenLoss || row.MaxExposure != maxExposure {
			return connect.NewError(connect.CodeAlreadyExists, errors.New("حساب مجازی قبلاً با سیاست دیگری ایجاد شده است"))
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	book, err := p.readPaperBook(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.InitializePaperAccountResponse{PaperAccount: book.PaperAccount}), nil
}

func (p *Paper) readPaperBook(ctx context.Context) (*labv1.GetPaperAccountResponse, error) {
	book := &labv1.GetPaperAccountResponse{}
	err := p.Market.Store.InTxOptions(ctx, pgx.TxOptions{IsoLevel: pgx.RepeatableRead, AccessMode: pgx.ReadOnly}, func(q *db.Queries) error {
		row, err := q.ReadPaperAccount(ctx, paperAccountID)
		if errors.Is(err, pgx.ErrNoRows) {
			return nil
		}
		if err != nil {
			return err
		}
		positions, err := q.ListPaperPositions(ctx, row.ID)
		if err != nil {
			return err
		}
		now := p.Market.Clock.Now()
		ledger, err := q.ReconcilePaperBook(ctx, row.ID)
		if err != nil {
			return err
		}
		book.Reconciliation = paperReconciliationP(ledger, now)
		var equity int64
		matched := paperReconciled(ledger)
		if matched {
			equity, err = money.AddInt64(row.CashAvailable, row.CashReserved)
			if err != nil {
				return err
			}
		}
		var stale bool
		for _, position := range positions {
			entry, err := readPaperEntry(ctx, q, position.EntryID)
			if err != nil {
				return err
			}
			plan, err := readPaperPlan(ctx, q, entry.PlanHash)
			if err != nil {
				return err
			}
			spec, ok := paperExecutionSpec(plan.GetInstrument())
			if !ok {
				return fmt.Errorf("paper position %d has an unknown instrument revision", position.EntryID)
			}
			view := &labv1.PaperPosition{
				ReceiptId: position.EntryID, Symbol: position.Symbol,
				Quantity: moneyP(money.Amount{Asset: spec.Base, V: position.Quantity}), CostBasis: usdtP(position.CostBasis),
				Revision: position.Revision, Lot: moneyP(money.Amount{Asset: spec.Base, V: spec.Lot.V}),
			}
			reduction, err := q.PendingPaperReduction(ctx, position.EntryID)
			if err == nil {
				view.PendingReduction = paperReductionP(position.Symbol, reduction)
			} else if !errors.Is(err, pgx.ErrNoRows) {
				return err
			}
			if !ledger.PositionsMatch {
				view.MarketValue = invalidPaperValue()
				book.Positions = append(book.Positions, view)
				continue
			}
			candle, err := p.paperCandle(ctx, q, position.Symbol, now, time.Time{})
			if errors.Is(err, errMarketFeed) {
				stale = true
				view.MarketValue = stalePaperValue()
			} else {
				if err != nil {
					return err
				}
				value, err := money.MulScaled(position.Quantity, spec.Base.Scale, candle.C, instrument.Scale, instrument.Scale, money.Floor)
				if err != nil {
					return err
				}
				if matched {
					equity, err = money.AddInt64(equity, value)
					if err != nil {
						return err
					}
				}
				view.MarketValue = paperMoneyValue(value)
			}
			book.Positions = append(book.Positions, view)
		}
		mark := paperMoneyValue(equity)
		if stale {
			mark = stalePaperValue()
		}
		if !matched {
			mark = invalidPaperValue()
		}
		book.PaperAccount = paperAccountP(row, now, mark)
		if !ledger.CashMatches || !ledger.ReservationsMatch {
			book.PaperAccount.Snapshot.AvailableBalance = invalidPaperValue()
			book.PaperAccount.ReservedBalance = nil
		}
		entries, err := q.RecentPaperEntries(ctx, row.ID)
		if err != nil {
			return err
		}
		for _, entry := range entries {
			book.RecentReceipts = append(book.RecentReceipts, paperReceiptP(entry))
		}
		return nil
	})
	return book, err
}

func paperPolicyP(row db.ReadPaperAccountRow) *labv1.RiskPolicyVersion {
	return &labv1.RiskPolicyVersion{PolicyId: row.ID, Revision: row.PolicyRevision, EffectiveFromUnixMs: ms(row.EffectiveAt)}
}

func paperAccountP(row db.ReadPaperAccountRow, now time.Time, equity *labv1.MoneyReading) *labv1.PaperAccount {
	return &labv1.PaperAccount{
		Snapshot: &labv1.AccountSnapshot{
			Account: paperAccountRef(), Revision: row.Revision, AsOfUnixMs: ms(now), AccountingAsset: instrument.USDT.Code,
			Equity:           equity,
			AvailableBalance: paperMoneyValue(row.CashAvailable),
			RiskPolicy:       paperPolicyP(row),
		},
		InitialCapital: usdtP(row.InitialCapital), ReservedBalance: usdtP(row.CashReserved),
		MaxLossPerTrade: usdtP(row.MaxLoss), MaxOpenLoss: usdtP(row.MaxOpenLoss), MaxSpotExposure: usdtP(row.MaxExposure),
		FeeRate: ratioP(money.Ratio(row.FeePpm)), SlippageRate: ratioP(money.Ratio(row.SlippagePpm)),
		EntriesPaused: row.EntriesPaused,
	}
}

func paperMoneyValue(amount int64) *labv1.MoneyReading {
	return &labv1.MoneyReading{Result: &labv1.MoneyReading_Value{Value: usdtP(amount)}}
}

func stalePaperValue() *labv1.MoneyReading {
	return &labv1.MoneyReading{Result: &labv1.MoneyReading_Unavailable{Unavailable: &labv1.UnavailableMoney{
		Reason: labv1.MoneyAvailability_MONEY_AVAILABILITY_STALE, Detail: "برای ارزش‌گذاری موقعیت، قیمت تازه در دسترس نیست",
	}}}
}

func invalidPaperValue() *labv1.MoneyReading {
	return &labv1.MoneyReading{Result: &labv1.MoneyReading_Unavailable{Unavailable: &labv1.UnavailableMoney{
		Reason: labv1.MoneyAvailability_MONEY_AVAILABILITY_INVALID, Detail: "ارزش حساب هنوز با دفتر تطبیق ندارد",
	}}}
}
