package data

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strconv"
	"time"
)

// DatasetSpec is what a dataset version is made of, besides its bars.
type DatasetSpec struct {
	Symbol    string
	Timeframe Timeframe
	From, To  time.Time // [From, To)
	GapPolicy GapPolicy
}

// HashDataset is the legacy canonical bar hash, also a component of new snapshot
// IDs: SHA-256 over the spec and bars in a fixed text form.
// Same inputs give the same hash on every run and machine; any changed value,
// added bar or different ingest delay gives a new hash.
func HashDataset(s DatasetSpec, bars []Bar) string {
	h := sha256.New()
	_, _ = fmt.Fprintf(h, "dataset/v1\n%s\n%s\n%d\n%d\n%s\n", s.Symbol, s.Timeframe, s.From.UnixMicro(), s.To.UnixMicro(), s.GapPolicy)
	buf := make([]byte, 0, 160)
	for _, b := range bars {
		buf = buf[:0]
		for _, v := range []int64{b.OpenTime.UnixMicro(), b.AvailableAt.UnixMicro(), b.O.V, b.H.V, b.L.V, b.C.V, b.Volume.V, int64(b.Flags)} {
			buf = strconv.AppendInt(buf, v, 10)
			buf = append(buf, ',')
		}
		buf[len(buf)-1] = '\n'
		_, _ = h.Write(buf)
	}
	return hex.EncodeToString(h.Sum(nil))
}

// New snapshots use a separate namespace, covering raw values and revision
// identities even when a higher-timeframe aggregation hides a correction.
func hashSnapshot(s DatasetSpec, bars, raw []Bar, revisions []int32) string {
	h := sha256.New()
	rawSpec := s
	rawSpec.Timeframe = TF1m
	_, _ = fmt.Fprintf(h, "dataset/snapshot/v1\n%s\n%s\n", HashDataset(s, bars), HashDataset(rawSpec, raw))
	for i, b := range raw {
		_, _ = fmt.Fprintf(h, "%d,%d,%d\n", b.OpenTime.UnixMicro(), b.CloseTime.UnixMicro(), revisions[i])
	}
	return hex.EncodeToString(h.Sum(nil))
}
