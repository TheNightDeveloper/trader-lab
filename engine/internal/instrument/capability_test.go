package instrument

import (
	"github.com/stretchr/testify/require"
	"testing"
)

func TestResearchCapabilitiesFollowTheRegistry(t *testing.T) {
	for _, spec := range Defaults() {
		if spec.Quote == USDT {
			require.NoError(t, ResearchError(spec.Symbol))
		} else {
			require.ErrorIs(t, ResearchError(spec.Symbol), ErrResearchUnsupported)
		}
	}
	require.ErrorIs(t, ResearchError("UNKNOWNUSDT"), ErrResearchUnsupported, "a suffix is not execution permission")
}
