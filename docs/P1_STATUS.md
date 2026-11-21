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
| Account contract | The account snapshot DTO identifies the account, environment, revision and effective risk policy. Money readings carry an exact value or a typed reason for unavailability. |
| Lifecycle audit | The Library reads 20 audit events per page. Each event includes its typed actor, timestamp and version-scoped sequence. Older clients retain the original full-history response. |

The runtime keeps the research-only deployment and the existing deep links. Older
clients can still use `RunMode` and symbol strings. The new UI reads legacy research
mode when a server predates the workspace fields. The signal and account reference
contracts confer no execution authority. Migration `00008` adds the lifecycle
audit index. Before reverting to a binary that predates this migration, roll
back `00008` with the current migration set. The rollback drops the index
independently of the event records.

## State matrix

| State | Research shell | Paper prototype |
| --- | --- | --- |
| Waiting for first heartbeat | The mode is unknown. The sidebar shows a loading state. | The demo opens with a prepared example snapshot. |
| Recent heartbeat | The header shows the confirmed environment. The sidebar distinguishes configured feed states from connection status. | The example order can be reviewed with visible account, risk and estimated cost. |
| Stale feed | The sidebar identifies stale market data and shows its age when available. | The stale opportunity explains the block. |
| Connection lost after a heartbeat | The current route and last confirmed environment stay visible. The banner shows the last heartbeat time. | The last snapshot stays visible. Deployment and order actions are disabled across the demo. |
| Connection restored | A fresh heartbeat clears the banner in place. | A new snapshot must be received before deployment and order actions are enabled. |

## Local verification

- PostgreSQL was required for the final Go suite. It passed 372 tests and subtests with zero failures or skips, including all 11 simulator goldens. `golangci-lint` and `go vet` passed.
- Commit `f93f48b` also passed the complete Go suite with `-race`, `-count=1`, `-p=1` and PostgreSQL required. The Go 1.26.4 Linux/amd64 container used the local PostgreSQL instance. All 372 tests and subtests passed across 22 packages, with zero failures or skips. The local log is `artifacts/p1-linux-race-f93f48b.jsonl`.
- Buf lint and compatibility against the P0 contract passed. Dart analysis was clean, all 57 Flutter tests passed, and the release web build succeeded with the existing CupertinoIcons warning.
- Chrome checked the runtime shell at 390, 768, 1024 and 1440 px. Tab reached the 44 × 44 px menu control, Enter opened the RTL drawer, and Escape closed it and restored focus. Dropping `HealthService.Watch` left the active route and last heartbeat visible. Reconnect cleared the banner in place.
- Firefox 159 rendered the same four widths and opened and dismissed the drawer at 390 px.
- Chrome ran J1, J2 and J5 in the prototype. It checked heading focus, the sample receipt, blocked actions across routes during disconnect, and layout at the same four widths.
- The three prototype flows also passed at 390 px with 200% text in Chrome. Enter activated the focused controls. The snapshot time and UTC label stayed on one line, and actions stayed disabled until fresh account data was acknowledged.
- The report RPC test verifies the recorded dataset and instrument keys and the legacy status without rewriting either the stored specification or evaluation. The focused Dart report and contract suite passed.
- Go and Dart decode the same account fixture. The tests check the distinction between an exact zero and unavailable money, and preserve a revision above JavaScript's safe integer range.
- The lifecycle RPC regression verifies cursor scope, the original full-history response and paging after a newer event arrives between reads. Chrome paged back and forth through a temporary history of more than 20 events at 390 px.
- Hosted CI and representative-user acceptance remain open. The fresh 200% Flutter shell check was blocked by Windows executable policy. The 200% result above covers the standalone Paper prototype.

## Remaining acceptance work

- Connect Paper risk presentation to server-owned values when account data is available.
- Review the Paper prototype with representative users and record results. Its sample receipt demonstrates the proposed flow. Paper execution belongs to P3.

### Prototype review

Open the [Paper prototype](../design/p1/workspace.html) directly from the repository.
Use a fresh page for each participant. Ask them to think aloud and record whether
they complete each task without a hint. Include a narrow viewport and a keyboard
pass within the review.

| Flow | Task to give the participant | Evidence to record |
| --- | --- | --- |
| J1 — setup | «یک الگو را برای حساب مجازی آماده کنید و پیش از فعال‌سازی شواهد آزمون را بررسی کنید.» | Participant checks the evidence and identifies the environment as a demonstration. |
| J2 — opportunity | «یک فرصت قابل بررسی پیدا کنید. قبل از تأیید، زیان برنامه‌ریزی‌شده و هزینه را پیدا کنید و رسید را بررسی کنید.» | Participant locates the risk and estimated cost, explains the stale opportunity, and identifies the receipt as a simulation outcome. |
| J5 — reconnect | «اتصال را قطع و دوباره برقرار کنید. بررسی کنید چه زمانی می‌توانید مرور سفارش را ادامه دهید.» | Participant recognizes the last confirmed snapshot and waits for a fresh snapshot before resuming. |

Record the build commit, browser and width, task completion, hints and any confusion
about the execution mode. The master plan targets at least 80% completion without
help and zero critical Paper/Live identification errors, with five representative
users or at least three external reviewers for a personal project. Record actual
results separately from automated browser evidence.
