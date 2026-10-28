package experiment

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestBuiltinRecipesAreValid(t *testing.T) {
	n := 0
	for name, b := range builtins {
		if b.recipe != nil {
			require.NoError(t, b.recipe.Validate(), name)
			require.Equal(t, "learning", b.family, name)
			n++
		}
	}
	require.Equal(t, 2, n)
}
