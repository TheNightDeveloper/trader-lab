package eval

import (
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/instrument"
)

// Provenance records the actual inputs; absent fields on legacy reports stay unknown.
type Provenance struct {
	Version     int               `json:"version"`
	Build       BuildIdentity     `json:"build"`
	Datasets    []DatasetInput    `json:"datasets"`
	Instruments []instrument.Spec `json:"instruments"`
	Policies    Policies          `json:"policies"`
}

// BuildIdentity distinguishes release labels from the binary and its source metadata.
type BuildIdentity struct {
	BinarySHA256 string `json:"binary_sha256"`
	Commit       string `json:"commit"`
	CommitTime   string `json:"commit_time"`
	VCSKnown     bool   `json:"vcs_known"`
	Dirty        bool   `json:"dirty"`
	GoVersion    string `json:"go_version"`
	GOOS         string `json:"goos"`
	GOARCH       string `json:"goarch"`
}

type DatasetInput struct {
	ID       string        `json:"id"`
	Manifest data.Manifest `json:"manifest"`
}

// Policies supplement costs/sizing in Spec.Sim and gap/availability rules in each manifest.
type Policies struct {
	Evaluation string `json:"evaluation"`
	Fill       string `json:"fill"`
	Accounting string `json:"accounting"`
	Research   string `json:"research"`
}
