# Run status: run-01-2026-10-10

state: open            # open | closed
last updated: 2026-10-10 15:20 by the manager session (phase 00)
next phase: 00 setup, steps 4 to 8 (steps 1 to 3 done)
open items: 00b returned CANNOT PROCEED (LabVIEW crashed 15:13:55 in lvai_validate_aixml; report-00b-project.md). Waiting for the user: (1) go-ahead to start LabVIEW again, (2) whether VI Server names may be probed at all, or the helper is generated straight from the lvserver.rsc spellings

## Machine facts (from lvai_status at the start of each session, never from memory)

- LabVIEW: 2026 Q3 32-bit (log `LabVIEW_32_26.3.1f1`), `C:\Program Files (x86)\National Instruments\LabVIEW 2026\LabVIEW.exe`; started by this session 2026-10-10 15:06 via lvai_ensure_labview (PID 2428, launchMethod breakaway, 42.7 s); port 57742; Nigel chat not needed; lvai_status ok at 15:08, up 44 s, dwarnCount 0
- labview-mcp: server 1.9.5-local.20261010-1430 (f9ee41d9), scripts `C:\project\claude\labview-mcp-local-plugin\labview-mcp\bin\scripts`; the plugin reconnected after the user ran /mcp at about 15:05
- LVAutoSave path: C:SERSJORGEN.STEENONEDRIVE - VIRINCO ASDOKUMENTERabview datavautosave (count 0; ensure_labview reported the store already empty)

## Phases

| # | phase | state | started | ended | commit | result in one line |
|---|---|---|---|---|---|---|
| 00 | setup | running | 2026-10-10 14:40 | | | steps 1 to 4 done; 00b failed: LabVIEW crashed during a validate_aixml probe, no .lvproj created; 00a not launched; waiting for the user |
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

- Never probe a VI Server name with `lvai_validate_aixml`: an invented method on {LV.Application} crashed LabVIEW
  2026 Q3 (DWarn 0x762E6013 in invoke.cpp, minidump fd529ccf-601a-49a4-d740-28409e75b42d). Take spellings from
  `resource\lvserver.rsc` and NI's shipped helpers, commit first, generate the real helper directly, and expect a
  possible crash on the convert too (report-00b-project.md, item 6).
- The project-creation vocabulary found offline in `lvserver.rsc`: {LV.Application} Invoke `Project.New` (no inputs),
  `Project.Open` (Path); {LV.Project} property `My Computer`, Invoke `Save` (optional Path), `Close`;
  {LV.ProjectItem} Invoke `AddItem` (Name, Path, Type; Type "Folder" for a virtual folder, as in the plugin's
  lvai_add_one_to_library.xml). The output terminal name of `Project.New` is unmeasured (report-00b-project.md, item 2).
- No labview-mcp tool creates a `.lvproj` or an empty virtual folder; `lvproj_move.py --create` needs an item to
  move (skill `knowledge/labview-mcp.md`, "lvai_add_to_library"; `kit/lvproj_move.py` header). Brief 00b marks the
  project creation as unmeasured.

## Deviations and fallbacks

Where the build differs from `02-specification.md`, with why, and whether the user agreed.

- 2026-10-10, phase 00: the card's step order 6 (conventions) then 7 (project) is swapped to 00b (project) then 00a
  (conventions), because `lvai_status` reports no save version and the card wants it measured, not from memory.
  Two commits instead of one. Not asked; a harness detail, not a product deviation.

## Side effects outside src/

Files written outside `zuehlke-mcp-af-test-results/src/` and this run's folder (error-code file into user.lib, LabVIEW
restarts, projects closed), one line each with the user's go-ahead quoted and dated.

- 2026-10-10 15:06: LabVIEW 2026 32-bit started by the manager (`lvai_ensure_labview`, PID 2428); the skill's
  start routine allows it with no go-ahead (no LabVIEW was running, LVAutoSave empty). This session may close it.

## Where the next session starts

Phase 00 is blocked on the user's answer to the CANNOT PROCEED of 00b (see open items). Once answered: start
LabVIEW per `session/start.md` (if the user allows), `lvai_status`, then continue the SAME 00b agent with
SendMessage (not a re-spawn) with the user's words, or a fresh agent on brief 00b with UPDATES if the old one
is gone. Everything below is the state before 00b.

Last commit: `chore: product folder skeleton` (phase 00 step 3). Nothing is half done in LabVIEW: no
LabVIEW call has been made in this run. First check that the labview-mcp plugin is connected (the
`lvai_*` tools are listed) and run `lvai_status`; if it does not answer, follow the skill's
`session/start.md` (LabVIEW was not running at 14:44 on 2026-10-10). Then write the machine facts
above, fill the `<<FILL ...>>` markers in `briefs/brief-00a-conventions.md` and `briefs/brief-00b-project.md`
(drafted 2026-10-10, not yet launched), commit them, and launch 00a (docs-only, general-purpose agent), then
00b (LabVIEW, general-purpose agent), one after the other (steps 6 to 8 of `orchestration/phases/00-setup.md`). Defaults in force: agents inherit the manager's model,
error-code file stays in the repository, no standing restart go-ahead, never push.
