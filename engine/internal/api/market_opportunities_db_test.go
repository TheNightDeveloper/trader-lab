package api

import (
	"context"
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"net/http"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"golang.org/x/sync/errgroup"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
	"tradinglab/engine/internal/strategy"
)

func TestMarketOpportunityIsCausalAndDurable(t *testing.T) {
	ctx := context.Background()
	st := storetest.Open(t)
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	minute := make([]data.Bar, 120)
	price := money.Price{V: 42_00000000, Scale: instrument.Scale}
	for i := range minute {
		open := now.Add(time.Duration(i-120) * time.Minute)
		close := open.Add(time.Minute)
		minute[i] = data.Bar{Instrument: "BTCUSDT", OpenTime: open, CloseTime: close, AvailableAt: close, O: price, H: price, L: price, C: price}
	}
	_, err := data.UpsertBars(ctx, st, "BTCUSDT", "rest", "test", minute[:100])
	require.NoError(t, err)
	_, err = data.UpsertBars(ctx, st, "BTCUSDT", "rest", "test", minute[101:])
	require.NoError(t, err)
	dataset, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{
		Symbol: "BTCUSDT", Timeframe: data.TF1h, From: minute[0].OpenTime, To: minute[59].CloseTime, GapPolicy: data.GapStop,
	})
	require.NoError(t, err)
	threshold := 40.0
	entry := strategy.Rule{Op: "gt", Left: &strategy.RuleValue{Kind: "close"}, Right: &strategy.RuleValue{Kind: "constant", Number: &threshold}}
	exit := entry
	exit.Op = "lt"
	def := strategy.RuleDefinition{Format: strategy.RuleFormatV1, Exposure: money.RatioOne, Entry: entry, Exit: exit, BaseTimeframe: data.TF1h}
	defJSON, err := json.Marshal(def)
	require.NoError(t, err)
	wall := clock.NewVirtual(now.Add(time.Minute))
	market := &Market{Store: st, Clock: wall, Symbols: []string{"BTCUSDT", "ETHUSDT"}, Live: fakeLive{data.LiveStatus{
		Symbols: []data.LiveSymbolStatus{{Symbol: "BTCUSDT", State: data.LiveFresh, LastClose: now}},
	}}}
	srv := serve(t, func(mux *http.ServeMux) {
		mux.Handle(labv1connect.NewMarketServiceHandler(market))
		mux.Handle(labv1connect.NewLibraryServiceHandler(&Library{Store: st}))
	})
	lib := labv1connect.NewLibraryServiceClient(srv.Client(), srv.URL)
	version, err := lib.SaveRuleVersion(ctx, connect.NewRequest(&labv1.SaveRuleVersionRequest{Title: "Spot rule", DefinitionJson: string(defJSON)}))
	require.NoError(t, err)
	id := version.Msg.GetVersion().GetId()
	client := labv1connect.NewMarketServiceClient(srv.Client(), srv.URL)
	scan := func(symbol string) (*connect.Response[labv1.ScanMarketOpportunityResponse], error) {
		return client.ScanMarketOpportunity(ctx, connect.NewRequest(&labv1.ScanMarketOpportunityRequest{Symbol: symbol, RuleVersionId: id}))
	}
	_, err = scan("BTCUSDT")
	require.Equal(t, connect.CodeFailedPrecondition, code(err))
	spec, err := json.Marshal(map[string]any{"rule_version_id": id, "timeframe": "1h", "dataset_ids": []string{dataset.ID}})
	require.NoError(t, err)
	empty := []byte(`{}`)
	require.NoError(t, st.InsertReport(ctx, db.InsertReportParams{ID: "evidence", Spec: spec, Split: empty, Evaluation: empty, Holdout: empty}))
	_, err = scan("ETHUSDT")
	require.ErrorContains(t, err, "بک‌تست یک‌ساعته")
	incomplete, err := scan("BTCUSDT")
	require.NoError(t, err)
	require.Equal(t, labv1.MarketScanState_MARKET_SCAN_STATE_INCOMPLETE_DATA, incomplete.Msg.GetState())

	// The missing minute is now available. Two clients can only record one match.
	_, err = data.UpsertBars(ctx, st, "BTCUSDT", "rest", "test", minute[100:101])
	require.NoError(t, err)
	var group errgroup.Group
	var opportunities [2]*labv1.MarketOpportunity
	for i := range opportunities {
		group.Go(func() error {
			res, err := scan("BTCUSDT")
			if err != nil {
				return err
			}
			opportunities[i] = res.Msg.GetOpportunity()
			return nil
		})
	}
	require.NoError(t, group.Wait())
	require.Positive(t, opportunities[0].GetId())
	require.Equal(t, opportunities[0].GetId(), opportunities[1].GetId())
	require.Equal(t, "evidence", opportunities[0].GetReportId())
	require.Equal(t, "4200000000", opportunities[0].GetReferenceClose().GetUnits())
	require.True(t, opportunities[0].GetCurrent())
	var snapshot []byte
	var digest string
	require.NoError(t, st.Pool.QueryRow(ctx, "SELECT snapshot, snapshot_sha256 FROM market_opportunities WHERE id = $1", opportunities[0].GetId()).Scan(&snapshot, &digest))
	require.Equal(t, fmt.Sprintf("%x", sha256.Sum256(snapshot)), digest)
	var replay []data.Bar
	require.NoError(t, json.Unmarshal(snapshot, &replay))
	intent, ready, err := def.ProbeEntry(replay)
	require.NoError(t, err)
	require.True(t, ready)
	require.Equal(t, opportunities[0].GetReason(), intent.Reason)
	for _, bar := range replay {
		require.False(t, bar.CloseTime.After(now))
	}

	require.NoError(t, wall.Set(now.Add(time.Hour)))
	_, err = scan("BTCUSDT")
	require.ErrorContains(t, err, "دادهٔ زندهٔ نماد")
	restarted := &Market{Store: st, Clock: wall}
	state, err := restarted.GetMarketSnapshot(ctx, connect.NewRequest(&labv1.GetMarketSnapshotRequest{}))
	require.NoError(t, err)
	require.Len(t, state.Msg.GetOpportunities(), 1)
	require.Equal(t, opportunities[0].GetId(), state.Msg.GetOpportunities()[0].GetId())
	require.False(t, state.Msg.GetOpportunities()[0].GetCurrent())
}
