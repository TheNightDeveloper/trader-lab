// Package migrations embeds the goose SQL migrations so the engine applies them on start.
package migrations

import "embed"

//go:embed *.sql
var FS embed.FS
