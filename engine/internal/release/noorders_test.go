// Package release holds checks of the v1 release gate that span the whole code
// base. It has no code of its own.
package release

import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

// Order and trading endpoints of the exchange (spot, margin, futures, user data)
// and the marks of a signed request.
var orderEndpoint = regexp.MustCompile(`(?i)(/order|/sapi/|/fapi/|/dapi/|/papi/|userDataStream|newOrder|/account|/myTrades|X-MBX-APIKEY|signature=)`)

// violations lists what in one Go file could send an order: a string naming an
// order or account endpoint, a POST helper, or an outbound request that is not a GET.
func violations(name string, src any) ([]string, error) {
	f, err := parser.ParseFile(token.NewFileSet(), name, src, 0)
	if err != nil {
		return nil, err
	}
	var out []string
	ast.Inspect(f, func(n ast.Node) bool {
		switch x := n.(type) {
		case *ast.BasicLit:
			if s, _ := strconv.Unquote(x.Value); x.Kind == token.STRING && orderEndpoint.MatchString(s) {
				out = append(out, fmt.Sprintf("%s: string %q names an order or account endpoint", name, s))
			}
		case *ast.CallExpr:
			sel, ok := x.Fun.(*ast.SelectorExpr)
			if !ok {
				return true
			}
			switch sel.Sel.Name {
			case "Post", "PostForm":
				out = append(out, fmt.Sprintf("%s: %s call", name, sel.Sel.Name))
			case "NewRequest", "NewRequestWithContext":
				i := 0
				if sel.Sel.Name == "NewRequestWithContext" {
					i = 1
				}
				if len(x.Args) <= i || !isGet(x.Args[i]) {
					out = append(out, fmt.Sprintf("%s: outbound request that is not a GET", name))
				}
			}
		}
		return true
	})
	return out, nil
}

func isGet(e ast.Expr) bool {
	switch x := e.(type) {
	case *ast.BasicLit:
		s, _ := strconv.Unquote(x.Value)
		return s == "GET"
	case *ast.SelectorExpr:
		return x.Sel.Name == "MethodGet"
	}
	return false
}

// Release gate: no code path can send a real order. Every outbound HTTP request
// in the engine is a GET, nothing posts, no source names an order or account
// endpoint, and the API has no RPC that could ask for one.
func TestNoCodePathCanSendARealOrder(t *testing.T) {
	root := filepath.Join("..", "..")
	files := 0
	err := filepath.WalkDir(root, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() && (d.Name() == "gen" || d.Name() == "testdata" || d.Name() == "release") {
			return filepath.SkipDir
		}
		if d.IsDir() || !strings.HasSuffix(path, ".go") || strings.HasSuffix(path, "_test.go") {
			return nil
		}
		files++
		v, err := violations(path, nil)
		require.NoError(t, err)
		require.Empty(t, v)
		return nil
	})
	require.NoError(t, err)
	require.Greater(t, files, 50, "the scan saw the engine")

	protos, err := filepath.Glob(filepath.Join(root, "..", "proto", "lab", "v1", "*.proto"))
	require.NoError(t, err)
	require.NotEmpty(t, protos)
	rpc := regexp.MustCompile(`(?m)^\s*rpc\s+(\w+)`)
	for _, p := range protos {
		b, err := os.ReadFile(p)
		require.NoError(t, err)
		for _, m := range rpc.FindAllStringSubmatch(string(b), -1) {
			require.NotRegexp(t, `(?i)order|execute|submit|place|send`, m[1], "%s: rpc %s", p, m[1])
		}
	}
}

// The scan is live: a planted order call is caught.
func TestScanCatchesAnOrderCall(t *testing.T) {
	v, err := violations("probe.go", `package probe
import "net/http"
func f(c *http.Client) {
	http.Post("https://api.binance.com/api/v3/order", "application/json", nil)
	req, _ := http.NewRequest(http.MethodPost, "https://example.com", nil)
	req.Header.Set("X-MBX-APIKEY", "k")
	c.Do(req)
}`)
	require.NoError(t, err)
	require.Len(t, v, 4, "%v", v) // the URL, the Post call, the POST request, the API-key header
}
