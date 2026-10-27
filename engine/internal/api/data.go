package api

import (
	"context"
	"errors"
	"fmt"
	"slices"
	"time"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

type Data struct {
	Store    *store.Store
	Importer data.Importer
	Live     *data.Live // nil when live data is off
	Clock    clock.Clock
}

func (d *Data) GetOverview(ctx context.Context, _ *connect.Request[labv1.GetOverviewRequest]) (*connect.Response[labv1.GetOverviewResponse], error) {
	now := d.Clock.Now()
	out, err := d.Store.OutagesSince(ctx, now.Truncate(24*time.Hour))
	if err != nil {
		return nil, err
	}
	size, err := d.Store.DatabaseSize(ctx)
	if err != nil {
		return nil, err
	}
	ins, err := d.Store.ListInstruments(ctx)
	if err != nil {
		return nil, err
	}
	res := &labv1.GetOverviewResponse{
		OutagesToday: out.Outages, OutageSecondsToday: out.Seconds, StorageBytes: size,
		LiveSource: "REST · data-api.binance.vision",
	}
	if d.Live != nil {
		res.LiveSymbols = int32(len(d.Live.Symbols))
	}
	for _, i := range ins {
		res.Symbols = append(res.Symbols, i.Symbol)
	}
	return connect.NewResponse(res), nil
}

func (d *Data) ListDatasets(ctx context.Context, req *connect.Request[labv1.ListDatasetsRequest]) (*connect.Response[labv1.ListDatasetsResponse], error) {
	rows, err := d.Store.ListDatasets(ctx, db.ListDatasetsParams{Limit: pageSize(req.Msg.GetPageSize()), Offset: max(0, req.Msg.GetOffset())})
	if err != nil {
		return nil, err
	}
	res := &labv1.ListDatasetsResponse{}
	for _, r := range rows {
		ds, err := datasetProto(r)
		if err != nil {
			return nil, err
		}
		res.Datasets = append(res.Datasets, ds)
	}
	return connect.NewResponse(res), nil
}

func datasetProto(r db.Dataset) (*labv1.Dataset, error) {
	m, err := data.ParseManifest(r.Manifest)
	if err != nil {
		return nil, err
	}
	return &labv1.Dataset{
		Id: r.ID, Symbol: r.Symbol, Timeframe: r.Timeframe, GapPolicy: r.GapPolicy,
		FromUnixMs: r.RangeFrom.UnixMilli(), ToUnixMs: r.RangeTo.UnixMilli(),
		BarCount: r.BarCount, Gaps: int32(m.Gaps), Filled: int32(m.Filled), CreatedUnixMs: r.CreatedAt.UnixMilli(),
	}, nil
}

func (d *Data) GetCoverage(ctx context.Context, _ *connect.Request[labv1.GetCoverageRequest]) (*connect.Response[labv1.GetCoverageResponse], error) {
	cov, err := d.Store.Coverage(ctx)
	if err != nil {
		return nil, err
	}
	probs, err := d.Store.ProblemRanges(ctx)
	if err != nil {
		return nil, err
	}
	byID := map[string]*labv1.Coverage{}
	res := &labv1.GetCoverageResponse{}
	for _, c := range cov {
		p := &labv1.Coverage{Symbol: c.Symbol, FirstOpenUnixMs: c.FirstOpen.UnixMilli(), LastOpenUnixMs: c.LastOpen.UnixMilli(), Bars: c.Bars}
		byID[c.Symbol] = p
		res.Coverage = append(res.Coverage, p)
	}
	for _, p := range probs {
		c, ok := byID[p.Symbol]
		if !ok {
			continue
		}
		r := &labv1.TimeRange{FromUnixMs: p.At.UnixMilli(), UntilUnixMs: p.At.Add(time.Minute).UnixMilli()}
		if p.Until != nil {
			r.UntilUnixMs = p.Until.UnixMilli()
		}
		c.Problems = append(c.Problems, r)
	}
	return connect.NewResponse(res), nil
}

func (d *Data) ListQualityIssues(ctx context.Context, req *connect.Request[labv1.ListQualityIssuesRequest]) (*connect.Response[labv1.ListQualityIssuesResponse], error) {
	sym := db.ListQualityIssuesParams{Limit: pageSize(req.Msg.GetPageSize()), Offset: max(0, req.Msg.GetOffset())}
	if s := req.Msg.GetSymbol(); s != "" {
		sym.Symbol.String, sym.Symbol.Valid = s, true
	}
	rows, err := d.Store.ListQualityIssues(ctx, sym)
	if err != nil {
		return nil, err
	}
	total, err := d.Store.CountQualityIssues(ctx, sym.Symbol)
	if err != nil {
		return nil, err
	}
	res := &labv1.ListQualityIssuesResponse{Total: total}
	for _, r := range rows {
		q := &labv1.QualityIssue{Id: r.ID, Symbol: r.Symbol, Kind: r.Kind, AtUnixMs: r.At.UnixMilli(), Detail: r.Detail}
		if r.Until != nil {
			q.UntilUnixMs = r.Until.UnixMilli()
		}
		res.Issues = append(res.Issues, q)
	}
	return connect.NewResponse(res), nil
}

// Import runs the archive import for each symbol, then snapshots a dataset version.
func (d *Data) Import(ctx context.Context, req *connect.Request[labv1.ImportRequest], s *connect.ServerStream[labv1.ImportResponse]) error {
	m := req.Msg
	from, err := time.Parse(time.DateOnly, m.GetFromDate())
	if err != nil {
		return invalid("from_date: want YYYY-MM-DD")
	}
	to, err := time.Parse(time.DateOnly, m.GetToDate())
	if err != nil {
		return invalid("to_date: want YYYY-MM-DD")
	}
	to = to.AddDate(0, 0, 1) // inclusive day → exclusive bound
	today := d.Clock.Now().UTC().Truncate(24 * time.Hour)
	if !from.Before(to) || from.After(today) {
		return invalid("range: from must be on or before to, and not in the future")
	}
	to = minTime(to, d.Clock.Now().UTC())
	tf, err := data.ParseTimeframe(m.GetTimeframe())
	if err != nil {
		return invalid(err.Error())
	}
	gp, err := data.ParseGapPolicy(m.GetGapPolicy())
	if err != nil {
		return invalid(err.Error())
	}
	ins, err := d.Store.ListInstruments(ctx)
	if err != nil {
		return err
	}
	known := make([]string, len(ins))
	for i, in := range ins {
		known[i] = in.Symbol
	}
	if len(m.GetSymbols()) == 0 {
		return invalid("symbols: choose at least one")
	}
	for _, sym := range m.GetSymbols() {
		if !slices.Contains(known, sym) {
			return invalid(fmt.Sprintf("symbols: unknown %q", sym))
		}
	}

	for _, sym := range m.GetSymbols() {
		var sendErr error
		_, err := d.Importer.Import(ctx, sym, from, to, func(p data.ImportProgress) {
			if sendErr == nil {
				sendErr = s.Send(&labv1.ImportResponse{Event: &labv1.ImportResponse_Progress{Progress: progressProto(sym, p)}})
			}
		})
		if err := errors.Join(err, sendErr); err != nil {
			return fmt.Errorf("import %s: %w", sym, err)
		}
		ds, _, err := data.CreateDataset(ctx, d.Store, data.DatasetSpec{Symbol: sym, Timeframe: tf, From: from, To: to, GapPolicy: gp})
		if errors.Is(err, data.ErrGap) {
			return connect.NewError(connect.CodeFailedPrecondition, err)
		}
		if err != nil {
			return err
		}
		row, err := d.Store.GetDataset(ctx, ds.ID)
		if err != nil {
			return err
		}
		p, err := datasetProto(row)
		if err != nil {
			return err
		}
		if err := s.Send(&labv1.ImportResponse{Event: &labv1.ImportResponse_Dataset{Dataset: p}}); err != nil {
			return err
		}
	}
	return nil
}

func progressProto(sym string, p data.ImportProgress) *labv1.ImportProgress {
	return &labv1.ImportProgress{
		Symbol: sym, File: p.File, FilesDone: int32(p.FilesDone), FilesTotal: int32(p.FilesTotal),
		Rows: int32(p.Rows), Inserted: int32(p.Inserted), Corrections: int32(p.Corrections), Missing: int32(p.Missing),
	}
}

func invalid(msg string) error { return connect.NewError(connect.CodeInvalidArgument, errors.New(msg)) }

// pageSize clamps client page sizes to 1..200 (default 50).
func pageSize(n int32) int32 {
	switch {
	case n <= 0:
		return 50
	case n > 200:
		return 200
	}
	return n
}

func minTime(a, b time.Time) time.Time {
	if a.Before(b) {
		return a
	}
	return b
}
