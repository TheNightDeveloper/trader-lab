package api

import (
	"context"
	"errors"
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
	row, err := p.Market.Store.ReadPaperAccount(ctx, paperAccountID)
	if errors.Is(err, pgx.ErrNoRows) {
		return connect.NewResponse(&labv1.GetPaperAccountResponse{}), nil
	}
	if err != nil {
		return nil, err
	}
	account, err := paperAccountP(row, p.Market.Clock.Now())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.GetPaperAccountResponse{PaperAccount: account}), nil
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
	account, err := paperAccountP(row, now)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.InitializePaperAccountResponse{PaperAccount: account}), nil
}

func paperPolicyP(row db.ReadPaperAccountRow) *labv1.RiskPolicyVersion {
	return &labv1.RiskPolicyVersion{PolicyId: row.ID, Revision: row.PolicyRevision, EffectiveFromUnixMs: ms(row.EffectiveAt)}
}

func paperAccountP(row db.ReadPaperAccountRow, now time.Time) (*labv1.PaperAccount, error) {
	equity, err := money.AddInt64(row.CashAvailable, row.CashReserved)
	if err != nil {
		return nil, err
	}
	return &labv1.PaperAccount{
		Snapshot: &labv1.AccountSnapshot{
			Account: paperAccountRef(), Revision: row.Revision, AsOfUnixMs: ms(now), AccountingAsset: instrument.USDT.Code,
			Equity:           &labv1.MoneyReading{Result: &labv1.MoneyReading_Value{Value: usdtP(equity)}},
			AvailableBalance: &labv1.MoneyReading{Result: &labv1.MoneyReading_Value{Value: usdtP(row.CashAvailable)}},
			RiskPolicy:       paperPolicyP(row),
		},
		InitialCapital: usdtP(row.InitialCapital), ReservedBalance: usdtP(row.CashReserved),
		MaxLossPerTrade: usdtP(row.MaxLoss), MaxOpenLoss: usdtP(row.MaxOpenLoss), MaxSpotExposure: usdtP(row.MaxExposure),
		FeeRate: ratioP(money.Ratio(row.FeePpm)), SlippageRate: ratioP(money.Ratio(row.SlippagePpm)),
	}, nil
}
