package sim

import (
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// Invariant 3: no float in accounting. Fails if any non-test file of the judge's
// accounting packages mentions float32/float64. Strategies may use floats for
// indicator math; the ledger may not.
func TestNoFloatInAccounting(t *testing.T) {
	for _, dir := range []string{".", "../money", "../metrics"} {
		files, err := filepath.Glob(filepath.Join(dir, "*.go"))
		if err != nil {
			t.Fatal(err)
		}
		if len(files) == 0 {
			if _, err := os.Stat(dir); os.IsNotExist(err) {
				continue // package not written yet (metrics arrives in M3)
			}
		}
		for _, f := range files {
			if strings.HasSuffix(f, "_test.go") {
				continue
			}
			fs := token.NewFileSet()
			file, err := parser.ParseFile(fs, f, nil, 0)
			if err != nil {
				t.Fatal(err)
			}
			ast.Inspect(file, func(n ast.Node) bool {
				if id, ok := n.(*ast.Ident); ok && (id.Name == "float64" || id.Name == "float32") {
					t.Errorf("%s: %s in accounting code", fs.Position(id.Pos()), id.Name)
				}
				return true
			})
		}
	}
}
