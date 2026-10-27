package api

import (
	"context"
	"errors"
	"strconv"
	"strings"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/fx"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

// rateScale: TOMAN rates are entered with at most 2 decimals.
const rateScale = 2

type Fx struct {
	Store *store.Store
	Clock clock.Clock
}

func (f *Fx) ListRates(ctx context.Context, req *connect.Request[labv1.ListRatesRequest]) (*connect.Response[labv1.ListRatesResponse], error) {
	rows, err := f.Store.ListFxRates(ctx, pageSize(req.Msg.GetLimit()))
	if err != nil {
		return nil, err
	}
	res := &labv1.ListRatesResponse{}
	for _, r := range rows {
		res.Rates = append(res.Rates, rateProto(r))
	}
	return connect.NewResponse(res), nil
}

func (f *Fx) AddRate(ctx context.Context, req *connect.Request[labv1.AddRateRequest]) (*connect.Response[labv1.AddRateResponse], error) {
	m := req.Msg
	date, err := time.Parse(time.DateOnly, m.GetDate())
	if err != nil {
		return nil, invalid("date: want YYYY-MM-DD")
	}
	if date.After(f.Clock.Now().UTC()) {
		return nil, invalid("date: cannot be in the future")
	}
	v, err := money.Parse(strings.TrimSpace(m.GetTomanPerUsdt()), rateScale)
	if err != nil || v <= 0 {
		return nil, invalid("toman_per_usdt: a positive number with at most 2 decimals")
	}
	src := strings.TrimSpace(m.GetSource())
	if src == "" {
		src = "manual"
	}
	if len(src) > 200 {
		return nil, invalid("source: at most 200 characters")
	}
	row, err := f.Store.InsertFxRate(ctx, db.InsertFxRateParams{RateDate: date, Rate: v, RateScale: rateScale, Source: src})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.AddRateResponse{Rate: rateProto(row)}), nil
}

// LatestDisplayRate feeds the sidebar; nil when no rate was entered.
func (f *Fx) LatestDisplayRate(ctx context.Context) (*labv1.DisplayRate, error) {
	r, err := f.Store.LatestFxRate(ctx)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	p := rateProto(r)
	return &labv1.DisplayRate{RateId: strconv.FormatInt(r.ID, 10), TomanPerUsdt: p.TomanPerUsdt, AsOfDate: p.Date, Source: r.Source}, nil
}

func rateProto(r db.FxRate) *labv1.FxRate {
	return &labv1.FxRate{
		Id: r.ID, Date: r.RateDate.Format(time.DateOnly), Source: r.Source, EnteredUnixMs: r.EnteredAt.UnixMilli(),
		TomanPerUsdt: &labv1.Money{Units: strconv.FormatInt(r.Rate, 10), Scale: r.RateScale, Asset: fx.Toman.Code},
	}
}
