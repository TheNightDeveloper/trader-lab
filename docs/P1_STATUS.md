# P1 workspace foundations

P1 started on 2026-11-19 after the [P0 research release gate](P0_STATUS.md).
The [master plan](Trading_Lab_Master_Plan_FA.md#p1-پایه-محصول-و-طراحی-تجربه) defines the remaining acceptance work.

## Implemented stages

| Stage | Runtime behavior |
| --- | --- |
| CORE-01 | The API includes a venue, product and specification revision for registered markets. Strategy discovery advertises research evaluation on spot markets. Go and Dart read the same versioned signal fixture. |
| Workspace health | `HealthService.Watch` reports the active research environment and the enabled feed. A missing close time and a close with zero age have distinct protobuf representations. |
| Workspace shell | The environment stays visible above the active route. The right sidebar docks at 1200 px. The drawer is available below that width. Unreleased destinations are omitted from navigation. |
| UX-01 | The [clickable Paper prototype](../design/p1/workspace.html) covers setup, opportunity review and reconnect with sample data. |
| Report evidence | `GetReport` publishes the stored build, policy, dataset and instrument revisions with a typed evidence status. The report UI displays that status and retains compatibility with older engines. |

The runtime keeps the research-only deployment and the existing deep links. Older
clients can still use `RunMode` and symbol strings. The new UI reads legacy research
mode when a server predates the workspace fields. The signal and account reference
contracts confer no execution authority. No migration or dependency is required.

## State matrix

| State | Research shell | Paper prototype |
| --- | --- | --- |
| Waiting for first heartbeat | The mode is unknown. The sidebar shows a loading state. | The demo opens with a prepared example snapshot. |
| Recent heartbeat | The header shows the confirmed environment. The sidebar distinguishes configured feed states from connection status. | The example order can be reviewed with visible account, risk and estimated cost. |
| Stale feed | The sidebar identifies stale market data and shows its age when available. | The stale opportunity explains the block. |
| Connection lost after a heartbeat | The current route and last confirmed environment stay visible. The banner shows the last heartbeat time. | The last snapshot stays visible. Deployment and order actions are disabled across the demo. |
| Connection restored | A fresh heartbeat clears the banner in place. | A new snapshot must be received before deployment and order actions are enabled. |

## Local verification

- PostgreSQL was required for the Go suite. It passed 369 tests and subtests with zero failures or skips, including all 11 simulator goldens. `golangci-lint` and `go vet` passed.
- Buf lint, compatibility against the P0 contract, and regeneration parity passed. Dart analysis was clean, all 56 Flutter tests passed, and the release web build succeeded with the existing CupertinoIcons warning.
- Chrome checked the runtime shell at 390, 768, 1024 and 1440 px. Tab reached the 44 × 44 px menu control, Enter opened the RTL drawer, and Escape closed it and restored focus. Dropping `HealthService.Watch` left the active route and last heartbeat visible. Reconnect cleared the banner in place.
- Chrome ran J1, J2 and J5 in the prototype. It checked heading focus, the sample receipt, blocked actions across routes during disconnect, and layout at the same four widths.
- The report RPC test verifies the recorded dataset and instrument keys and the legacy status without rewriting either the stored specification or evaluation. The focused Dart report and contract suite passed.
- Hosted CI, the Go race detector, Firefox and representative-user acceptance remain unverified for P1.

## Remaining acceptance work

- Publish audit and cursor contracts, and the account snapshot and risk policy DTOs.
- Connect Paper risk presentation to server-owned values when account data is available.
- Review the Paper prototype with representative users and record results. Its sample receipt demonstrates the proposed flow. Paper execution belongs to P3.
