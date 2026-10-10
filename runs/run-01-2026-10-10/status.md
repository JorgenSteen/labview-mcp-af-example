# Run status: run-01-2026-10-10

state: open            # open | closed
last updated: 2026-10-10 17:12 by the manager session (phase 01)
next phase: 01 packages, step e (apply icons; launched 17:13)
open items: F3 (library count 13 vs 14) still unanswered, not blocking. Items for the user in the IDE accumulate in the section below. 01b was cut off by the user's usage limit at about 16:15 (HTTP 429) and resumed by SendMessage at 16:22; it finished at 16:32 (report-01b-pc-methods-library.md).

## Machine facts (from lvai_status at the start of each session, never from memory)

- LabVIEW: 2026 Q3 32-bit (log `LabVIEW_32_26.3.1f1`), `C:\Program Files (x86)\National Instruments\LabVIEW 2026\LabVIEW.exe`; started by this session 2026-10-10 15:06 via lvai_ensure_labview (PID 2428, launchMethod breakaway, 42.7 s); port 57742; Nigel chat not needed; lvai_status ok at 15:08, up 44 s, dwarnCount 0
- labview-mcp: server 1.9.5-local.20261010-1430 (f9ee41d9), scripts `C:\project\claude\labview-mcp-local-plugin\labview-mcp\bin\scripts`; the plugin reconnected after the user ran /mcp at about 15:05
- LVAutoSave path: C:SERSJORGEN.STEENONEDRIVE - VIRINCO ASDOKUMENTERabview datavautosave (count 0; ensure_labview reported the store already empty)

## Phases

| # | phase | state | started | ended | commit | result in one line |
|---|---|---|---|---|---|---|
| 00 | setup | done | 2026-10-10 14:40 | 2026-10-10 15:45 | d0ef347 (project), 15b56f9 (.labview) | product skeleton, LabVIEW 2026 Q3 32-bit answers, .labview complete (10 decided rules, configuration off), empty project with six folders, save version 26.0; one LabVIEW crash on the way (F2) |
| 01 | packages | running | 2026-10-10 15:46 | | 63c4179..0148c39 (01a), a2e395f..c42836d (01b) | 01a-01c done: 3 classes, 24 member VIs exactly as 02 §7.1, library under common, overrides with Call Parent + setType hook, ZM-TST-tests.lvlib + T1 Pass (round 1), Clean Up Diagram on 25 VIs, icon rules on 02 names, preview generated; 01e (apply icons) waits for the preview approval |
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
| T1 ZM-TST-packages Pass | pass (2026-10-10 16:45, cold, round 1) | reports/evidence-01c-checks.txt: Pass T, error 0, all ten *_ok T; commit 0a55fe6 |
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

- A test VI (or any loose VI) must be a project item BEFORE the library helper runs `Library.Create` + `AddItem`:
  `lvproj_add_toplevel.py` first, then the helper (project open and active), then `lvproj_move.py` into the folder
  (project closed). Otherwise the close writes no library and drops a loose VI entry (report-01c, item 2).
- `Match Regular Expression` is an XNode and cannot be authored in AIXML: use `Match Pattern` with an anchored
  character-class pattern (report-01c, item 6). `Equal?` on clusters is element-wise: `Cluster To Array` + `And Array
  Elements` for a scalar.
- Evidence files under `proof/` are git-ignored by design; the manager copies each test's evidence into
  `runs/<run>/reports/evidence-<step>-checks.txt` (report-01c, item 6).
- A hook placed after Call Parent (shape B-after) in a DYNAMIC override of a plain class must take and return
  the PARENT class type (`ZM-PC-package in`/`out`), never the child type and never a To More Specific Class cast:
  otherwise the override and every caller of the dispatch method read state 0 cold with only "VI is not
  executable". Cost ~20 calls to find (report-01b-pc-methods-library.md, item 9, T1). Applies to HW and CP child
  hooks in phases 03-05.
- A plain `.lvlib` is created by a helper derived from the kit's `lvai_create_actor_library.xml` (Library.Create,
  AddItem Type LVClass per class, Save All This Library), run with the project OPEN AND ACTIVE (it reads
  Project:Active Project); the close then lists the library at top level plus a stray class item: `lvproj_drop.py`
  + `lvproj_move.py` into the right folder, project closed. `lvai_add_to_library` needs an existing `.lvlib`.
  Source: `proof/ZMP-01b/zm_create_package_library.xml` (report-01b, item 4).
- `lvai_add_class_method` with the parent's pane and `dispatchTerminals` makes a dynamic-dispatch override of a
  plain-class method with its own body (no Call Parent); measured (report-01b, item 5).
- `lvai_placeholder_subvi` writes stub VIs into `<LabVIEW>\user.lib\LV_MCP\` (the tool's own cache, outside the
  product folder by design; 17 added in 01b). `sweep_paths.py` writes `paths.txt` into the current folder by
  default: pass `--out` (report-01b, item 9).
- No labview-mcp tool sets a class description (`NI.Lib.Description`); no tool adds a `.ctl` to a class; no tool
  places a member in a `Methods`/`TypeDefs` virtual folder. The accessor tool's `virtualFolderName` does create
  `Accessors`. `lvai_create_class` with `typedefFieldsJson` and `projectPath` binds at creation (`boundInFile` true) and
  closes the project itself; a child created with `parentClassPath` did NOT add a duplicate parent entry to the
  `.lvproj` on labview-mcp 1.9.5 (report-01a-pc-classes.md, items 2, 6, 8).
- `icon-spec.json` (`.labview/conventions/`) carries the pilot's `rules` patterns in snake_case (`get_data_as_json`,
  ...) and an empty `planned`; the icons step of each phase must revisit the patterns for the camelCase names of `02`
  before generating (report-00a-conventions.md, item 6).
- Opening and closing a project writes `src/.Zuehlke MCP.UserState/debug.lvprojstate`; now git-ignored by
  `*.UserState/` in the product `.gitignore` (report-00b-project.md, item 6).
- `lvai_describe_project` does not list virtual folders; folders are verified from the `.lvproj` XML
  (report-00b-project.md, item 3). AIXML spellings that create a project and virtual folders are in item 2 of that
  report (Project.New, My Computer, AddItem with Type "Folder" and a required empty Path, Save with Path, Close).
- The runner's own helper `lvai_run_and_read_typed.vi` was a 14-byte stub and answered error 1059; pass
  `regenerateHelper: true` once when that happens (report-00b-project.md, item 2e-f).
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

- 2026-10-10, phase 01 (icons): the icons follow the skill's generator as it is today, not the letter of
  `icons.banner` (black Small Fonts text) and `icons.class-glyph` (class glyph at the right): the banner text is
  white 3x5 and the library glyph sits at the left. Approved by the user (go-ahead above). Applies to every phase.
- 2026-10-10, phase 00: the card's step order 6 (conventions) then 7 (project) is swapped to 00b (project) then 00a
  (conventions), because `lvai_status` reports no save version and the card wants it measured, not from memory.
  Two commits instead of one. Not asked; a harness detail, not a product deviation.

## Go-aheads from the user

- User go-ahead (2026-10-10 15:22): "You may restart LabVIEW when needed. close anything you are using labview all by yourself for the whole session, not restrictions" - scope: the whole session; restarting, closing and starting LabVIEW, and closing projects this run opened, need no further question. Extended by the user (2026-10-10 15:30): "Agents can restart labview themselves too, no need to ask me" - every brief from 00b on carries a hard-rules line letting the agent start or restart LabVIEW itself per the skill's session/start.md, reporting each start. The manager relayed it into brief 00b's continuation and sets `restart_go_ahead` to `always` in `project.json` (brief 00a) with this quote as the note.

- User decision (2026-10-10 16:00): "option 1 then and log that answer into the documentation to so if someone wants to try to rerun this later, then do not need this clearification" - the manager's option 1: class descriptions, `.ctl` membership and `Methods`/`TypeDefs`/`Helpers`
  folder placement are done by the user in the IDE; agents list them; written into `CLAUDE.md` ("Defaults that
  need no question") and `orchestration/plan.md` on the user's instruction (commit fcac3e0), and into the product's
  `decisions.md` as D38 by the 01b agent.

- User decision (2026-10-10 17:10): "Approve as is, option 1, continue, but note this down so any clean start also does the same, without this prompt" - the icon preview `reports/icon-preview-01d.png` is approved as the kit draws it; written into
  `CLAUDE.md` ("The icon preview is approved in advance") and `orchestration/plan.md` on the user's instruction, and
  into the product's `decisions.md` as D39 by the 01e agent.

## For the user in the IDE (decided 2026-10-10: things no tool does)

Do these in LabVIEW's Project Explorer at the end of a phase or before phase 12, then commit. Each line names
the class, the item and the file that holds the text.

- ZM-PC-package: class description (text in briefs/brief-01a-pc-classes.md, "Descriptions"); move
  `ZM-PC-PACKAGE_TYPE.ctl`, `ZM-PC-DESTINATION.ctl`, `ZM-PC-HEADER.ctl` into the class, folder `TypeDefs`.
- ZM-PC-TP-test_package: class description (same brief); `ZM-PC-TP-DATA.ctl` into the class, folder `TypeDefs`.
- ZM-PC-EP-error_package: class description (same brief); `ZM-PC-EP-DATA.ctl` into the class, folder `TypeDefs`.
- All three classes: the 12 non-accessor members (`ZM-PC-init`, `ZM-PC-getDataAsJson`, `ZM-PC-getTypeName`,
  `ZM-PC-getDestinationName`, `ZM-PC-getTimestampString`, `ZM-PC-getHeader`; TP: `ZM-PC-init`, `ZM-PC-getDataAsJson`,
  `ZM-PC-TP-setType`, `ZM-PC-TP-create`; EP: the same four with `EP`) into a `Methods` virtual folder of their class
  (report-01b, item 2).

## Side effects outside src/

Files written outside `zuehlke-mcp-af-test-results/src/` and this run's folder (error-code file into user.lib, LabVIEW
restarts, projects closed), one line each with the user's go-ahead quoted and dated.

- 2026-10-10 15:06: LabVIEW 2026 32-bit started by the manager (`lvai_ensure_labview`, PID 2428); the skill's
  start routine allows it with no go-ahead (no LabVIEW was running, LVAutoSave empty). Crashed 15:13:55 (F2).
- 2026-10-10 16:00-16:30 (01b): 17 placeholder stub VIs written by `lvai_placeholder_subvi` into
  `C:\Program Files (x86)\National Instruments\LabVIEW 2026\user.lib\LV_MCP\` (the plugin's pre-existing cache folder,
  145 stubs before). The tool's design, not the agent's choice; nothing of the user's touched.
- 2026-10-10 15:24: LabVIEW 2026 32-bit started again by the manager (`lvai_ensure_labview`, PID 14040, port 59552,
  21.8 s, LVAutoSave already empty), under the user's standing go-ahead above.

## Where the next session starts

Phase 00 is done. Phase 01 (packages) is split into 01a classes, 01b methods and library, 01c test, 01d icons,
cleanup, sweep. Briefs are written one step ahead; check `briefs/` for the highest step with no matching report in
`reports/`: that is the running or next step. Each step commits its own product files.

Last product commit: `chore: empty project Zuehlke MCP.lvproj with six virtual folders` (d0ef347). Nothing is
half done in LabVIEW: no project is open. First check that the labview-mcp plugin is connected (the
`lvai_*` tools are listed) and run `lvai_status`; if it does not answer, follow the skill's
`session/start.md` (LabVIEW was not running at 14:44 on 2026-10-10). Then write the machine facts
above, fill the `<<FILL ...>>` markers in `briefs/brief-00a-conventions.md` and `briefs/brief-00b-project.md`
(drafted 2026-10-10, not yet launched), commit them, and launch 00a (docs-only, general-purpose agent), then
00b (LabVIEW, general-purpose agent), one after the other (steps 6 to 8 of `orchestration/phases/00-setup.md`). Defaults in force: agents inherit the manager's model,
error-code file stays in the repository, no standing restart go-ahead, never push.
