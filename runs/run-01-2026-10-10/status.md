# Run status: run-01-2026-10-10

state: open            # open | closed
last updated: 2026-10-10 14:50 by the manager session (phase 00)
next phase: 00 setup, steps 4 to 8 (steps 1 to 3 done)
open items: the labview-mcp MCP server failed to connect at session start and LabVIEW is not running; lvai_status could not be called; the user must reconnect the plugin or restart the session before step 4

## Machine facts (from lvai_status at the start of each session, never from memory)

- LabVIEW: not read yet (lvai_status unavailable on 2026-10-10; LabVIEW process count 0 per kit/lv_windows.ps1 at 14:44)
- labview-mcp: not read yet (MCP server failed to connect on 2026-10-10)
- LVAutoSave path: C:SERSJORGEN.STEENONEDRIVE - VIRINCO ASDOKUMENTERabview datavautosave (from kit/lv_windows.ps1, count 0; lvai_status still to confirm)

## Phases

| # | phase | state | started | ended | commit | result in one line |
|---|---|---|---|---|---|---|
| 00 | setup | running | 2026-10-10 14:40 | | | steps 1 to 3 done (run folder, product skeleton); stopped before step 4: labview-mcp server not connected, LabVIEW not running |
| 01 | packages | todo | | | | |
| 02 | common utilities | todo | | | | |
| 03 | hardware | todo | | | | |
| 04 | protocol + file logger | todo | | | | |
| 05 | UDP + multi protocol | todo | | | | |
| 06 | pipeline test | todo | | | | |
| 07 | interface + message | todo | | | | |
| 08 | CM actor | todo | | | | |
| 09 | HWM actor | todo | | | | |
| 10 | ROOT actor | todo | | | | |
| 11 | launchers + receiver | todo | | | | |
| 12 | runs + structural checks | todo | | | | |
| 13 | close | todo | | | | |

state: todo | running | done | failed | skipped (say why in the result column)

## Checks (from requirements/03-acceptance.md)

| check | state | evidence |
|---|---|---|
| T1 ZM-TST-packages Pass | | |
| T2 ZM-TST-log Pass | | |
| T3 ZM-TST-hardware Pass | | |
| T4 ZM-TST-protocol Pass | | |
| T5 ZM-TST-udp Pass | | |
| T6 ZM-TST-pipeline Pass | | |
| T7 ZM-TST-routing Pass | | |
| R-normal ×3 | | |
| R-error | | |
| R-interactive | | |
| R-receiver | | |
| R-viewer | | |
| R-close-order | | |
| R-stop-reset | | |
| R-pli-failure | | |
| structural checks (03 §3), one line per row that failed | | |

## Traps carried forward

Facts the next brief must repeat, each by its content with its source (report file and section).

- No labview-mcp tool creates a `.lvproj` or an empty virtual folder; `lvproj_move.py --create` needs an item to
  move (skill `knowledge/labview-mcp.md`, "lvai_add_to_library"; `kit/lvproj_move.py` header). Brief 00b marks the
  project creation as unmeasured.

## Deviations and fallbacks

Where the build differs from `02-specification.md`, with why, and whether the user agreed.

- (none yet)

## Side effects outside src/

Files written outside `zuehlke-mcp-af-test-results/src/` and this run's folder (error-code file into user.lib, LabVIEW
restarts, projects closed), one line each with the user's go-ahead quoted and dated.

- (none yet)

## Where the next session starts

Last commit: `chore: product folder skeleton` (phase 00 step 3). Nothing is half done in LabVIEW: no
LabVIEW call has been made in this run. First check that the labview-mcp plugin is connected (the
`lvai_*` tools are listed) and run `lvai_status`; if it does not answer, follow the skill's
`session/start.md` (LabVIEW was not running at 14:44 on 2026-10-10). Then write the machine facts
above, fill the `<<FILL ...>>` markers in `briefs/brief-00a-conventions.md` and `briefs/brief-00b-project.md`
(drafted 2026-10-10, not yet launched), commit them, and launch 00a (docs-only, general-purpose agent), then
00b (LabVIEW, general-purpose agent), one after the other (steps 6 to 8 of `orchestration/phases/00-setup.md`). Defaults in force: agents inherit the manager's model,
error-code file stays in the repository, no standing restart go-ahead, never push.
