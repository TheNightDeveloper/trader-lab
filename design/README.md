# Design

- `screens/` — artboards exported from the canvas "Trading Research Platform UI". Source reference only; they render on the canvas, not standalone.
- `png/` — one screenshot per artboard (add these from the canvas; name them like the screen file, e.g. `Report.png`).
- `tokens.json` — colors, spacing, radii, type. Mirrored in `app/lib/core/theme/tokens.dart`.

Workflow: change the design on the canvas → re-export the changed screen here → update the PNG → ask Claude Code to update that screen and its golden test.
