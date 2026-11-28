package api

import (
	"time"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store/db"
)

func paperReconciled(row db.ReconcilePaperBookRow) bool {
	return row.CashMatches && row.ReservationsMatch && row.PositionsMatch && row.EventsMatch
}

func paperReconciliationP(row db.ReconcilePaperBookRow, now time.Time) *labv1.PaperReconciliation {
	return &labv1.PaperReconciliation{
		CheckedAtUnixMs: ms(now), LastEventId: row.LastEventID, CashMatches: row.CashMatches,
		ReservationsMatch: row.ReservationsMatch, PositionsMatch: row.PositionsMatch, EventsMatch: row.EventsMatch,
	}
}

func paperReconciliationRestriction() *labv1.PaperRestriction {
	return paperRestriction("ledger_mismatch", "مانده‌ها یا رویدادهای حساب با دفتر تطبیق ندارند؛ ورود تازه متوقف است")
}
