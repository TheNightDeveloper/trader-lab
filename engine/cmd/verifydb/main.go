// Command verifydb checks a database's integrity after a restore: every dataset
// version still hashes to its ID, every model artifact still matches its content
// ID, and it prints the row count of every table (for comparison with the source).
//
//	go run ./cmd/verifydb -db postgres://…
package main

import (
	"context"
	"flag"
	"fmt"
	"os"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

func main() {
	url := flag.String("db", "postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable", "database URL")
	flag.Parse()
	if err := run(context.Background(), *url); err != nil {
		fmt.Fprintln(os.Stderr, "FAIL:", err)
		os.Exit(1)
	}
	fmt.Println("OK")
}

func run(ctx context.Context, url string) error {
	st, err := store.Open(ctx, url)
	if err != nil {
		return err
	}
	defer st.Close()

	rows, err := st.Pool.Query(ctx, `SELECT tablename FROM pg_tables WHERE schemaname = current_schema() ORDER BY tablename`)
	if err != nil {
		return err
	}
	var tables []string
	for rows.Next() {
		var t string
		if err := rows.Scan(&t); err != nil {
			return err
		}
		tables = append(tables, t)
	}
	if err := rows.Err(); err != nil {
		return err
	}
	for _, t := range tables {
		var n int64
		if err := st.Pool.QueryRow(ctx, fmt.Sprintf(`SELECT count(*) FROM %q`, t)).Scan(&n); err != nil {
			return err
		}
		fmt.Printf("table %s %d\n", t, n)
	}

	for off := int32(0); ; off += 100 {
		ds, err := st.ListDatasets(ctx, db.ListDatasetsParams{Limit: 100, Offset: off})
		if err != nil {
			return err
		}
		for _, d := range ds {
			if _, _, err := data.LoadDataset(ctx, st, d.ID); err != nil {
				return err // includes a hash mismatch
			}
		}
		fmt.Printf("datasets verified %d\n", int(off)+len(ds))
		if len(ds) < 100 {
			break
		}
	}

	algs, err := st.ListAlgorithms(ctx)
	if err != nil {
		return err
	}
	n := 0
	for _, a := range algs {
		arts, err := st.ListArtifacts(ctx, db.ListArtifactsParams{AlgorithmID: a.ID, Limit: 100_000})
		if err != nil {
			return err
		}
		for _, r := range arts {
			if _, err := model.Load(r.Body); err != nil {
				return err
			}
			n++
		}
	}
	fmt.Printf("models verified %d\n", n)
	return nil
}
