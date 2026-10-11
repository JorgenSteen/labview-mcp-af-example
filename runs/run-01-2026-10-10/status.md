# Run status: run-01-2026-10-10

state: open            # open | closed
last updated: 2026-10-11 10:58 by the manager session (session 2 hand-over)
next phase: 08 CM actor, step a - brief `briefs/brief-08a-cm-class.md` (filled, ready to launch); 08b, 08c drafted
open items: see "Open items" below.

# STATUS: Session 2 stopped, 2026-10-11 10:58

Session 2 (Opus 5.5, same Claude Code session as session 1) finished phases 05, 06 and 07 and stopped at the
user's choice because the manager's context was at 80% ("your context is at 80% is a handover better or do you
want to continue with phase 7?"; the manager advised finishing 07 first). Commits d5512ec..this hand-over; nothing
pushed.

- **Built:** 05a2 (UDP hooks), 05b (MX), 05c (T5, T4 complete), 05d (cleanup, icons), 06 (T6, all tests rerun),
  07 (`ZM-CI-common_interfaces.lvlib`: interface, method, message class by NI's Message Maker in a `Messages` folder).
- **Verification:** T1-T6 all PASS cold (reports/evidence-06-checks.txt); sweeps `src\protocol`+`src\tests` 41/41,
  `src\tests` 6/6, `ZM-CI` 3/3, each with control 0 7; every file at 26; icons read back 0 px; no link into the
  Actor Framework from phases 01-05, and the CI library links only to itself, `ZM-PC-package` and vi.lib.
- **Side effects:** LabVIEW PID 14040 still running (started by the manager 2026-10-10 15:24), project CLOSED,
  LVAutoSave 0 at the end of 07; stub cache grew (05a2: 3, 05b: 4); helper VIs regenerated in place
  (`lvai_create_actor_library.vi`, `lvai_create_message_class.vi`), new `zmp05c_save_orphan*.vi` in the helpers folder;
  output\ test folders (git-ignored). No item removed, nothing upgraded.
- **Leftover on purpose:** `runs/run-01-2026-10-10/notes-for-run-02.md` is UNTRACKED by the user's instruction
  (2026-10-11: "note that down in a file you do not commit"). Do not commit or delete it.
- **Open for the user:** F3 (13 vs 14 libraries), F6 (card 03), F8 (MX write-back on an element error: keep or
  change, before phase 12), F9 (one-call rule broken in four of six Opus steps), the IDE list below (now incl. the
  interface and message descriptions and the MX reentrancy check), `/cost` for sessions 1 and 2.
- **Next session: start here:** (1) read `CLAUDE.md`, `orchestration/plan.md`, this file; (2) `lv_windows.ps1`, then
  `lvai_status`; (3) a new Claude Code session needs the LabVIEW go-ahead again in its start message (the standing
  one belongs to this session); (4) launch brief 08a (filled), then fill and launch 08b and 08c; briefs 09a is
  drafted; 09b-13 are not.

# Session 2 started 2026-10-11 09:34

- The user answered the hand-over with "2" (09:34): read as "start session 2 / step 2: launch 05a2"; both readings
  lead to the same work. Same Claude Code session as session 1, so the standing LabVIEW go-ahead of 2026-10-10
  15:22/15:30 is kept in force (the manager's judgment, written into brief 05a2).
- Model: manager and agents on Opus 5.5 (`claude-opus-5-5`), the user's `/model` of 2026-10-11.
- `lvai_status` 09:35: ok, PID 14040, port 59552, labview-mcp 1.9.5-local (f9ee41d9), up 65438 s, dwarnCount 0.
  `lv_windows.ps1` 09:34: `Zuehlke MCP.lvproj` open, possible dialogs 0, LVAutoSave 2.

# STATUS: Session 1 stopped, 2026-10-11 09:40

Session 1 ran from 2026-10-10 14:40 to 2026-10-11 09:40 (one Claude Code session, three usage-limit cut-offs, one
model limit). It stopped at the user's request ("seems to have hit a limit, i suggest we try to wrap up at a good
place to have a handover", 2026-10-11) after the 05a agent hit the Fable model limit. 159 commits from start HEAD
3e52c79 to 29e2187 plus this hand-over commit; nothing pushed.

## Built or changed

| phase | what | commits |
|---|---|---|
| 00 | run folder, product skeleton, `.labview/` (10 decided rules + D38, D39 later), empty project with six folders | 732c6d7..15b56f9 |
| 01 | `ZM-PC-packages.lvlib` (3 classes, 5 typedefs, 24 VIs), `ZM-TST-tests.lvlib`, T1, cleanup, icons | 63c4179..e8790ac |
| 02 | `ZM-CU-common_utilities.lvlib` (`ZM-CU-log.vi`), T2, cleanup, icons | e2ef456..146b6cd |
| 03 | `ZM-HW-hardware.lvlib`, `ZM-HW-SIM-simulated_hardware.lvlib`, T3, cleanup, icons | de2f81c..8b596f2 |
| 04 | `ZM-CP-communication_protocol.lvlib`, `ZM-CP-FL-file_logger.lvlib`, T4 (six of seven checks), cleanup, icons | 72828e3..6936679 |
| 05a (partial) | `ZM-CP-UDP-udp_transport.lvlib` with `ZM-CP-UDP-sender` and `ZM-CP-UDP-receiver`: fields, accessors, hooks (parent-typed, cast inside), sender `publish` override, receiver `receive`, the library under `protocol`, and the four BARE overrides `ZM-CP-init`/`ZM-CP-close` (Call Parent only) | 208e74b..29e2187 |

Proof folders (git-ignored, inside the product): `proof/ZMP-00b-project/`, `proof/ZMP-01a/` .. `proof/ZMP-04c/`,
`proof/ZMP-05a/` (if the agent wrote one), `proof/icons/`, `proof/runs/`. Test evidence copied into
`reports/evidence-*.txt`.

## Verification (readings, not "green")

| check | target | reading | source |
|---|---|---|---|
| T1 `ZM-TST-packages` | cold run | Pass T, error 0, 10/10 checks T | reports/evidence-01c-checks.txt |
| T2 `ZM-TST-log` | cold run | Pass T, error 0, 3/3 checks T | reports/evidence-02a-checks.txt |
| T3 `ZM-TST-hardware` | cold run | Pass T, error 0, 5/5 checks T | reports/evidence-03b-checks.txt |
| T4 `ZM-TST-protocol` | cold run | Pass T, error 0, 6/6 checks T (`mx_placeholder_ok` not yet built) | reports/evidence-04b-checks.txt |
| cold sweep `src\common\ZM-PC-packages` + `src\tests` | 25 VIs | 25/25 state 1, control 0 7, membership 0 missing | report-01e |
| cold sweep `ZM-CU` + `src\tests` | 3 VIs | 3/3 state 1, control 0 7 | report-02b |
| cold sweep `src\hardware` + `src\tests` | 9 VIs | 9/9 state 1, control 0 7 | report-03c |
| cold sweep `src\protocol` (CP, FL) + `src\tests` | 15 VIs | 15/15 state 1, control 0 7 | report-04c |
| icons read back | phases 01-04 | 25 + 2 + 7 + 12 VIs at 0 px; 5 + 1 + 4 + 4 owners at 0 px | reports 01e, 02b, 03c, 04c |
| save version | every file under `src\` written by phases 00-04 | 26 (LabVIEW 2026 Q3) | each report's `lv_save_version.py` block |
| dependency links | phases 01-04 VIs | no link into `vi.lib\ActorFramework`; no forbidden `ZM-` link | reports 01e, 02b, 03c, 04c |
| 05a UDP, before the hooks | 18 VIs (2 classes, bare overrides) | 18/18 state 1, control 0 7, project closed (membership not yet checked) | proof/ZMP-05a/ZMP-05a-sweep-after-library-and-bare-overrides.txt |
| 05a UDP, hooks, probe, final sweep | the four overrides with hooks | **not run**: the agent reopened the project to start the hooks and was cut off; nothing after 29e2187 is committed | this file |

Not run this session: phases 05b-13, T5-T7, every R-* run, the structural review of `03` §3.

## Side effects (session 1, unshortened)

- **Items removed:** none (`git log --diff-filter=D 3e52c79..HEAD` is empty). Project items dropped by
  `lvproj_drop.py` were only the stray top-level class items the tools added (one per new library, see reports).
- **Files re-saved:** every product file written by the agents, all at version 26; libraries' Save All re-saved
  their members (committed each time). Nothing was upgraded (the project's version IS the IDE's).
- **Project files rewritten:** `src/Zuehlke MCP.lvproj` at every open/close (BOM stripped by `lvai_create_class`
  and restored by the next close; `NI.LV.All.SaveVersion` 26.0 added at the first close); `.lvlps`, `.aliases`,
  `.Zuehlke MCP.UserState\` rewritten (git-ignored; `*.UserState/` added to the product `.gitignore`, 9de0549).
- **LabVIEW:** started by the manager 2026-10-10 15:06 (PID 2428, `lvai_ensure_labview`); it crashed 15:13:55 on a
  `lvai_validate_aixml` probe (F2). Started again by the manager 15:24 (PID 14040) under the user's go-ahead. PID
  14040 is STILL RUNNING at the hand-over with `Zuehlke MCP.lvproj` OPEN in the Project Explorer and LVAutoSave
  count 2 (`NI32LV2631f1ASD2_Zuehlke MCP.lvproj`, `.txt`): unsaved edits of the project in memory, made by the 05a
  agent after its last commit or by its last open. 18 hidden unsaved windows are the tool's own `LVMCP Validate*`
  scratch VIs (not product files). No agent restarted LabVIEW.
- **Nigel chat:** not opened. **LVAutoSave cleared:** never by this session (count 0 at both starts).
- **Outside the product folder:** the plugin's stub cache `C:\Program Files (x86)\National Instruments\LabVIEW
  2026\user.lib\LV_MCP\` grew from 145 to 169 stub VIs (tool design; agents' reports name each); helper VIs left in
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`: `zm_probe_c1.vi`, `zm_new_project.vi`,
  `zm_create_package_library.vi`, `zm_create_test_library.vi`, `zm_create_class_library.vi` (plus the tool's own);
  read-back folders `...\LabVIEWMCP\rb\01e`..`rb\04c`; the tool's scratch class projects under
  `...\LabVIEWMCP\classes\`. Nothing copied into `user.lib\errors\`.
- **Run-time output:** `zuehlke-mcp-af-test-results/output/` (git-ignored): `ZM-error_log.txt` (smoke and T2 marker
  lines), `test_fl_*` folders from T4.

## Deviations

See "Deviations and fallbacks" below (D38/D39 items, T4 without the MX check, the 00a/00b order). Agent rule breaks:
none seen (no parallel LabVIEW calls reported; heredoc slips were the manager's own shell edits, no product file
touched).

## The user's decisions this session

Quoted with dates in "Go-aheads from the user" below: the standing LabVIEW go-ahead (15:22, extended 15:30), option
1 for IDE-only items (16:00, D38), the icon preview approved in advance (17:10, D39), and at the end the hand-over
request (2026-10-11). Also on 2026-10-11 the user switched the session model with `/model` to **Opus 5.5** (saved as
the default): the manager and every agent launched from now on run on `claude-opus-5-5` unless the user switches back
(`orchestration/plan.md`, "Models and effort": a later role change is its own row in `cost.md`).

## Open items

1. **The project is open in LabVIEW with unsaved edits** (LVAutoSave 2). Owner: next session, step 2 below.
2. **05a is unfinished:** the four overrides are bare; hooks, export checks, sweep, probe and the report remain.
   Owner: next session, brief `briefs/brief-05a2-cp-udp-hooks.md`.
3. **F3:** library count 13 (spec tables) vs 14 (`02` §10). Owner: the user.
4. **For the user in the IDE** (D38): the list below; to be done before phase 12.
5. **`/cost` for session 1:** the user runs `/cost` and pastes the output into `cost.md`.
6. **Knowledge files:** `project.json` names no `knowledge_files`; the measured LabVIEW facts of this run live in
   "Traps carried forward" below and in the reports. Owner: the user (where they should go), the skill's maintainer
   (proposals in `mcp-reports/session-1.md`).
7. **Phase card 03** note contradicts `02` §3.1 (F6). Owner: the user (fix the card for the next run).

## Next session: start here

1. Read `CLAUDE.md`, `orchestration/plan.md`, this file. Model: the session now defaults to Opus 5.5 (the user's
   `/model` on 2026-10-11); note in `cost.md` which model the session and its agents run on.
2. LabVIEW state without a LabVIEW call: `powershell -NoProfile -ExecutionPolicy Bypass -File
   C:\Users\jorgen.steen\.claude\skills\labview\kit\lv_windows.ps1`. Then `lvai_status`.
3. The project `Zuehlke MCP.lvproj` is probably still open with unsaved edits. Brief 05a2's agent closes it first
   (`lvai_open_file` to make it active, then `lvai_close_active_project`, which saves), then runs `git status`: any
   product file changed by that save is compared with HEAD 29e2187; a change it cannot explain is restored from git
   with the project closed. The standing go-ahead covered session 1 only (`session/close.md`): if LabVIEW must be
   restarted, ask the user at the start, unless the start message grants it again.
4. Launch the 05a2 agent (brief ready, committed). Then continue with briefs 05b, 05c, 05d, 06, 07, 08a, 09a (drafted,
   committed; each has a `<<MANAGER ...>>` slot to fill from the previous report).
5. Briefs 08b, 08c, 09b-09d, 10*, 11*, 12*, 13 are not drafted yet; the phase cards and `02` §5-§8 are the source.

## LabVIEW at the end (lv_windows.ps1, 2026-10-11 09:28)

PID 14040 (started by this session 2026-10-10 15:24), `Zuehlke MCP.lvproj - Project Explorer` visible, unsaved 18
(all `LVMCP Validate*` scratch VIs, hidden), possible dialogs 0, LVAutoSave 2 (`NI32LV2631f1ASD2_Zuehlke MCP.lvproj`,
`NI32LV2631f1ASD2_Zuehlke MCP.txt`), LVNigelChat not running.

---

## Machine facts (from lvai_status at the start of each session, never from memory)

- LabVIEW: 2026 Q3 32-bit (log `LabVIEW_32_26.3.1f1`), `C:\Program Files (x86)\National Instruments\LabVIEW 2026\LabVIEW.exe`; started by this session 2026-10-10 15:06 via lvai_ensure_labview (PID 2428, launchMethod breakaway, 42.7 s); crashed 15:13:55; started again 15:24 (PID 14040, port 59552); Nigel chat not needed
- labview-mcp: server 1.9.5-local.20261010-1430 (f9ee41d9), scripts `C:\project\claude\labview-mcp-local-plugin\labview-mcp\bin\scripts`; the plugin reconnected after the user ran /mcp at about 15:05
- LVAutoSave path: `C:\Users\jorgen.steen\OneDrive - Virinco AS\Dokumenter\LabVIEW Data\LVAutoSave` (count 0 at both starts; 2 at the hand-over)

## Phases

| # | phase | state | started | ended | commit | result in one line |
|---|---|---|---|---|---|---|
| 00 | setup | done | 2026-10-10 14:40 | 2026-10-10 15:45 | d0ef347 (project), 15b56f9 (.labview) | product skeleton, LabVIEW 2026 Q3 32-bit answers, .labview complete (10 decided rules, configuration off), empty project with six folders, save version 26.0; one LabVIEW crash on the way (F2) |
| 01 | packages | done | 2026-10-10 15:46 | 2026-10-10 17:58 | 63c4179..e8790ac (five steps, 50 commits) | 3 classes, 5 typedefs, 24 member VIs exactly as 02 §7.1, ZM-PC-packages.lvlib under common, ZM-TST-tests.lvlib + T1 Pass, Clean Up Diagram, icons applied and read back 0 px, sweep 25/25, no AF or ZM link, all 26.0; left for the user in the IDE: class descriptions, .ctl membership, Methods/TypeDefs folders (D38) |
| 02 | common utilities | done | 2026-10-10 18:03 | 2026-10-10 18:19 | e2ef456..146b6cd (two steps, 7 commits) | ZM-CU-log.vi in ZM-CU-common_utilities.lvlib under common, ZM-TST-log.vi, T2 Pass, cleanup, icons read back 0 px, sweep 3/3, no ZM/AF link, all 26.0; nothing left for the IDE (no class) |
| 03 | hardware | done | 2026-10-10 18:25 | 2026-10-10 22:13 | de2f81c..8b596f2 (three steps, 17 commits) | parent + SIM in two libraries under hardware, do placeholder 5000 with FreeLabel, SIM do override, T3 Pass, cleanup, icons read back 0 px, sweep 9/9, no AF/CU/CP link, all 26.0; for the IDE: 2 class descriptions, Methods folders (D38) |
| 04 | protocol + file logger | done | 2026-10-10 22:17 | 2026-10-10 22:56 | 72828e3..6936679 (three steps, 23 commits) | parent + FL in two libraries under protocol, publish placeholder 5000 with FreeLabel, init override + createFolder hook, publish override, T4 Pass (six checks; the MX check comes in 05), cleanup, icons read back 0 px, sweep 15/15, no AF/CU/HW link, all 26.0; for the IDE: 2 class descriptions, Methods folders |
| 05 | UDP + multi protocol | done | 2026-10-10 23:01 | | 208e74b..29e2187 (05a), d7b5cf8..ab14b57 (05a2) | 05a done in two sessions: sender and receiver in ZM-CP-UDP-udp_transport.lvlib under protocol, four overrides hooked (open hooks end in Preserve Run-Time Class), sweep 18/18, probe error 0; 05b done (576b7a0..36c7a06): MX class with PROTOCOLS typedef (array of the CP parent), reentrant initAll/closeAll, three overrides, library under protocol, sweep 36/36, probe [parent] 5000 and [] clean; 05c done (53627a4, a1e87f0): T5 PASS, T4 PASS with seven checks, sweep 41/41; 05d done (45a2646..bbe3273): cleanup 27 VIs, 3 class + 2 library icons, read back 0 px, sweep 41/41, no AF/CU/HW/FL link, all 26.0. Phase ended 2026-10-11 10:27 |
| 06 | pipeline test | done | 2026-10-11 10:32 | 2026-10-11 10:39 | 558726e..f6f5260 (3 commits) | ZM-TST-pipeline.vi (T6) PASS in round 2 (a test-only fix), T1-T6 all PASS on the rerun, cleanup, icon 0 px, sweep 6/6, no production VI touched |
| 07 | interface + message | done | 2026-10-11 10:44 | 2026-10-11 10:50 | 6ea3457..254038b (11 commits) | ZM-CI-common_interfaces.lvlib under common: interface ZM-CI-package_handler, method ZM-CI-handlePackage (pane 4815, package on 10), message class ZM-CI-handlePackage Msg by Message Maker + repair_r1 in the Messages folder; Do.vi casts to the interface; sweep 3/3, icons 0 px; links only to ZM-PC and vi.lib |
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
| T2 ZM-TST-log Pass | pass (2026-10-10 18:08, cold, round 1) | reports/evidence-02a-checks.txt: Pass T, error 0, file_ok/order_ok/timestamp_ok T; commit 7925561 |
| T3 ZM-TST-hardware Pass | pass (2026-10-10 22:00, cold, round 1) | reports/evidence-03b-checks.txt: Pass T, error 0, sim_ok/sim_destination_ok/ranges_ok/varies_ok/placeholder_ok T; commit 3009b81 |
| T4 ZM-TST-protocol Pass | pass, all seven checks (2026-10-11 ~10:14, cold, round 1); six-check pass of 2026-10-10 22:40 before it | reports/evidence-05c-checks.txt: Pass T, error 0, init_ok/files_ok/lines_ok/append_ok/placeholder_ok/close_ok/mx_placeholder_ok T; commit a1e87f0 |
| T5 ZM-TST-udp Pass | pass (2026-10-11 ~10:13, cold, round 1; run twice, same readings) | reports/evidence-05c-checks.txt: Pass T, error 0, rx_init_ok/roundtrip_ok/timeout_ok/no_listener_ok/mx_ok/rx_publish_5000_ok T; port 61557 free; commit 53627a4 |
| T6 ZM-TST-pipeline Pass | pass (2026-10-11 ~10:36, cold, round 2 after a test-only fix); T1-T5 rerun PASS in the same session | reports/evidence-06-checks.txt: Pass T, error 0, pipeline_ok/error_stops_ok T; commit 558726e |
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

- The kit's Message Maker helper (`lvai_create_message_class.xml`) writes the message class FLAT into its
  `destination directory`: create the empty `<Msg class name>\` folder first and pass it as the destination; then
  `repair_r1.py`, then `lvai_add_to_library` into the `Messages` folder. The Send VI's input is named
  `Message Enqueuer` (NI's name, kept), the payload `package` (report-07, item 4). The kit's
  `lvai_create_actor_library.xml` creates a library WITH a virtual folder (`messages folder` input).
- `Equal?` on two clusters in AIXML comes out in Compare Elements mode (a cluster of Booleans): always follow it with
  `Cluster To Array` → `And Array Elements` before a Boolean array or indicator; `vi_nets.py` shows the fault offline
  when a VI reads eBad (report-06, item 2). `lvai_convert_vi_to_aixml` needs its target folder to exist (Error 7).
- A VI that is already a member of a LOADED library cannot be regenerated over its path (`lvai_generate_vi` answers
  1357): with the project closed, `remove_members.py <.lvlib> "<vi>"` (no `--delete-files`), then open, generate,
  swaps, `lvai_add_to_library` again (report-05c, item 6a). A project close may drop the `.lvproj` BOM or change
  its line endings only: `git checkout` it with the project closed (report-05c, item 6b).
- A child hook placed after Call Parent that WRITES a child field (casts inside, then `Write <field>`) must end with
  `Preserve Run-Time Class` (object in = the written object, target = the hook's input) on its parent-typed output.
  Returning the written object without it reads state 0 code 0 on the override (16/18 sweep); passing the input
  wire straight out loses the write. Read-only and close hooks pass the input wire straight through (report-05a2,
  items 3 and 9a).
- A child hook placed after Call Parent that must read a CHILD field keeps the PARENT type on its pane and casts
  inside (`To More Specific Class` to the child, then the child's private accessor); cold state 1 for the hook,
  the override and every caller (04b, `createFolder`). `pa_insert_series2` inputs for B-after on a child override:
  `panel name A` = `<Child> out`, `hook in A` = `<Parent> out`, `hook out A` = `<Parent> in`, block B `error out` /
  `error out` / `error in (no error)` (report-04b, item 3). `lvproj_add_toplevel.py` wants URLs relative to
  `src\` (the `.lvproj` folder), e.g. `protocol/ZM-CP-FL-file_logger/ZM-CP-FL-file_logger/ZM-CP-FL-buildPath.vi`
  (report-04b, item 7, commit e2be8b7).
- The parent `publish` pane (04a): class in 11, `error in` 8, `package` 10 (required input), class out 3, `error out`
  0; the runner accepts a required class input and a required package input unwired (defaults), so a placeholder
  can be run directly. The library close sometimes replaces the top-level class item by the library (04a) and
  sometimes leaves it (03a, 03b): always run `lvproj_drop.py` (0 lines is fine). `lv_loadability.py --links` on a
  FOLDER prints only the class's link: pass VI paths (report-04a, items 3, 4, 7).
- A class member with NO class terminal on its pane (a pure function member such as `randomData`) cannot go
  through `lvai_add_class_method` (refuses: no classTerminals) nor `lvai_add_to_library` (refuses a `.lvclass`):
  generate it with `lvai_generate_vi`, `lvproj_add_toplevel.py` (project closed), then run the tool's cached helper
  `lvai_add_one_to_library.vi` with `library path` = the `.lvclass`, item type VI, folder index -1, project open
  and active; then `set_scope.py` and the pane binding (report-03b, item 3). `lvai_create_class` strips the
  `.lvproj` BOM; LabVIEW's next close restores it. A test VI's class constants go in as path seeds and are swapped
  with `lvai_swap_subvis` `constantsJson` (report-03b, item 5).
- A free diagram label is authored in AIXML as `<FreeLabel comment="#customerror 5000" .../>` (element `FreeLabel`,
  attribute `comment`, listed in `lvai_aixml_reference` section 4); it survives the convert and reads back in the
  export (report-03a, item 3). `lvai_add_class_method` converts with the project closed, so a class constant of
  another library inside a method goes in as a path stand-in and is swapped afterwards with `lvai_swap_subvis`
  (`constantsSwapped`); the direct-Call route is for `lvai_generate_vi` only. `lv_loadability.py` needs `--vilib`
  on this station (four LabVIEW installs). A class created with a parent in a LIBRARY leaves a stray top-level
  class item after the library close: `lvproj_drop.py` (report-03a, items 3, 4, 7).
- A VI that calls library members converts DIRECTLY (no stubs, no swaps) when the project is open with one
  member of that library opened through it: `lvai_generate_vi` with `<Call target="<Lib>.lvlib:<VI>.vi">`
  (report-02a, item 4). LabVIEW's own close drops the loose project entry of a VI that joined a library, so
  `lvproj_drop.py` may find nothing. `Clear Errors.vi` lives in an `.llb` and its terminal names are not derivable
  in AIXML: clear one code with Unbundle code → Equal? → Select (report-02a, item 7).
- `lv_loadability.py --links` on a `.lvlib` prints only the target name; pass the VIs to get the link lists
  (report-01e, item 5). `lvai_set_vi_icon` re-saves the VI smaller (LabVIEW clearing leftovers): commit it.
- A test VI (or any loose VI) must be a project item BEFORE the library helper runs `Library.Create` + `AddItem`:
  `lvproj_add_toplevel.py` first, then the helper (project open and active), then `lvproj_move.py` into the folder
  (project closed). Otherwise the close writes no library and drops a loose VI entry (report-01c, item 2).
- `Match Regular Expression` is an XNode and cannot be authored in AIXML: use `Match Pattern` with an anchored
  character-class pattern (report-01c, item 6). `Equal?` on clusters is element-wise: `Cluster To Array` + `And Array
  Elements` for a scalar.
- Evidence files under `proof/` are git-ignored by design; the manager copies each test's evidence into
  `runs/<run>/reports/evidence-<step>-checks.txt` (report-01c, item 6).
- A hook placed after Call Parent (shape B-after) in a DYNAMIC override of a plain class must take and return
  the PARENT class type (`ZM-PC-package in`/`out`), never the child type: otherwise the override and every caller
  of the dispatch method read state 0 cold with only "VI is not executable". Cost ~20 calls to find
  (report-01b-pc-methods-library.md, item 9, T1). A cast INSIDE the hook, returning the parent wire, is fine (04b).
- A plain `.lvlib` is created by a helper derived from the kit's `lvai_create_actor_library.xml` (Library.Create,
  AddItem Type LVClass per class, Save All This Library), run with the project OPEN AND ACTIVE (it reads
  Project:Active Project); the close then lists the library at top level plus a stray class item: `lvproj_drop.py`
  + `lvproj_move.py` into the right folder, project closed. `lvai_add_to_library` needs an existing `.lvlib`.
  Source: `proof/ZMP-01b/zm_create_package_library.xml` (report-01b, item 4).
- `lvai_add_class_method` with the parent's pane and `dispatchTerminals` makes a dynamic-dispatch override of a
  plain-class method with its own body (no Call Parent); measured (report-01b, item 5).
- `lvai_placeholder_subvi` writes stub VIs into `<LabVIEW>\user.lib\LV_MCP\` (the tool's own cache, outside the
  product folder by design). `sweep_paths.py` writes `paths.txt` into the current folder by default: pass `--out`
  (report-01b, item 9).
- No labview-mcp tool sets a class description (`NI.Lib.Description`); no tool adds a `.ctl` to a class; no tool
  places a member in a `Methods`/`TypeDefs` virtual folder. The accessor tool's `virtualFolderName` does create
  `Accessors`. `lvai_create_class` with `typedefFieldsJson` and `projectPath` binds at creation (`boundInFile` true) and
  closes the project itself (report-01a-pc-classes.md, items 2, 6, 8).
- Opening and closing a project writes `src/.Zuehlke MCP.UserState/debug.lvprojstate`; git-ignored by
  `*.UserState/` in the product `.gitignore` (report-00b-project.md, item 6).
- `lvai_describe_project` does not list virtual folders; folders are verified from the `.lvproj` XML
  (report-00b-project.md, item 3). AIXML spellings that create a project and virtual folders are in item 2 of that
  report (Project.New, My Computer, AddItem with Type "Folder" and a required empty Path, Save with Path, Close).
- The runner's own helper `lvai_run_and_read_typed.vi` was a 14-byte stub and answered error 1059; pass
  `regenerateHelper: true` once when that happens (report-00b-project.md, item 2e-f).
- Never probe a VI Server name with `lvai_validate_aixml`: an invented method on {LV.Application} crashed LabVIEW
  2026 Q3 (DWarn 0x762E6013 in invoke.cpp, minidump fd529ccf-601a-49a4-d740-28409e75b42d). Take spellings from
  `resource\lvserver.rsc` and NI's shipped helpers (report-00b-project.md, item 6).
- The validator leaves hidden unsaved `LVMCP Validate*` scratch VIs in memory (tool design); `lv_windows.ps1` counts
  them as unsaved. They are not product files (reports 02a-04c).

## Deviations and fallbacks

Where the build differs from `02-specification.md`, with why, and whether the user agreed.

- 2026-10-11, phase 07: the agent sent three read-only icon reads in one message (report-07, item 8b): four of the
  six Opus 5.5 steps broke the one-call rule (05a2, 05b, 05d, 07; 05c and 06 kept it). F9 updated.
- 2026-10-11, phase 05d: the agent sent two `lvai_set_vi_icon` calls in one message; the third break of the one-call
  rule in four Opus 5.5 steps (05a2, 05b, 05d; 05c kept it), each harmless; no Fable 5.1 agent of session 1
  reported one. Recorded as finding F9; the launch messages keep the rule in bold.
- 2026-10-11, phase 05b: the agent sent two `pylv_extract` calls in one message (offline reads); the second break of
  the one-call rule in a row, no harm (report-05b, item 8a). The 05c launch message repeats the rule with emphasis.
- 2026-10-11, phase 05b: when an MX element errors, `Write protocols` skips (it honours `error in`), so the array
  is written back unchanged, never shortened, and the elements processed before the error keep their OLD state in
  the MX (e.g. a UDP sender opened before a failing element keeps no connection refnum). `02` §7.9 asks only that
  the array is never shortened; recorded as finding F8 for the phase 12 review, not changed (report-05b, item 8c).
- 2026-10-11, phase 05a2: the agent sent two `lvai_check_aixml` calls in one message (offline text checks,
  `labviewNeeded: false`); a break of the one-call rule with no harm (report-05a2, item 9b). Briefs keep the rule.

- 2026-10-10, phase 04: T4 is built without `mx_placeholder_ok` (needs the MX class of phase 05); phase 05 regenerates
  `ZM-TST-protocol.vi` with the seventh check (the card allows it; brief 05c). Not asked; the card decides.
- 2026-10-10, phase 01 (icons): the icons follow the skill's generator as it is today, not the letter of
  `icons.banner` (black Small Fonts text) and `icons.class-glyph` (class glyph at the right): the banner text is
  white 3x5 and the library glyph sits at the left. Approved by the user (go-ahead below). Applies to every phase.
- 2026-10-10, phase 00: the card's step order 6 (conventions) then 7 (project) is swapped to 00b (project) then 00a
  (conventions), because `lvai_status` reports no save version and the card wants it measured, not from memory.
  Two commits instead of one. Not asked; a harness detail, not a product deviation.

## Go-aheads from the user

- User go-ahead (2026-10-10 15:22): "You may restart LabVIEW when needed. close anything you are using labview all by yourself for the whole session, not restrictions" - scope: the whole session; restarting, closing and starting LabVIEW, and closing projects this run opened, need no further question. Extended by the user (2026-10-10 15:30): "Agents can restart labview themselves too, no need to ask me" - every brief from 00b on carries a hard-rules line letting the agent start or restart LabVIEW itself per the skill's session/start.md, reporting each start. `restart_go_ahead` is `always` in `project.json` with this quote as the note. Per the skill's `session/close.md` a blanket go-ahead ends with the session: the next session asks again at its start unless its start message grants it.
- User decision (2026-10-10 16:00): "option 1 then and log that answer into the documentation to so if someone wants to try to rerun this later, then do not need this clearification" - class descriptions, `.ctl` membership and `Methods`/`TypeDefs`/`Helpers` folder placement are done by the user in the IDE; agents list them; written into `CLAUDE.md` and `orchestration/plan.md` (commit fcac3e0) and into the product's `decisions.md` as D38.
- User decision (2026-10-10 17:10): "Approve as is, option 1, continue, but note this down so any clean start also does the same, without this prompt" - the icon preview `reports/icon-preview-01d.png` is approved as the kit draws it; written into `CLAUDE.md` and `orchestration/plan.md` (commit 6a89006) and into the product's `decisions.md` as D39.
- User (2026-10-11): `/model` set to Opus 5.5 (saved as the default for new sessions); then "seems to have hit a limit, i suggest we try to wrap up at a good place to have a handover".

## For the user in the IDE (decided 2026-10-10: things no tool does)

Do these in LabVIEW's Project Explorer at the end of a phase or before phase 12, then commit. Each line names
the class, the item and the file that holds the text.

- ZM-CI-package_handler (interface) and ZM-CI-handlePackage Msg: descriptions (report-07, item 8: "Interface: one
  method, ZM-CI-handlePackage; every actor that receives packages implements it"); whether `ZM-CI-handlePackage.vi`
  goes into a `Methods` folder of the interface is the user's call.
- ZM-CP-MX-multi_protocol: class description (report-05b, item 8); `ZM-CP-MX-PROTOCOLS.ctl` into `TypeDefs`; initAll,
  closeAll and the three overrides into `Methods`. **Check** that `ZM-CP-MX-initAll.vi` and `ZM-CP-MX-closeAll.vi`
  show "Shared clone reentrant" in VI Properties > Execution (report-05b, item 8b: the flags read differently after
  LabVIEW's re-save; the code works).
- ZM-CP-UDP-sender, ZM-CP-UDP-receiver: class descriptions (texts in briefs/brief-05a-cp-udp.md, "What to build"); their
  methods and hooks into a `Methods` folder (05a2 lists them).
- ZM-CP-FL-file_logger: class description (report-04b, item 8: "Pluggable file logger: one JSON Lines file per package
  type under outputFolder; init creates the folder after the parent; publish appends getDataAsJson to
  <getTypeName>.jsonl; close inherited"); `ZM-CP-init.vi`, `ZM-CP-publish.vi`, `ZM-CP-FL-createFolder.vi`,
  `ZM-CP-FL-buildPath.vi`, `ZM-CP-FL-appendLine.vi` into a `Methods` folder.
- ZM-CP-communication_protocol: class description (text in briefs/brief-04a-cp-parent.md, "What to build", step 3);
  `ZM-CP-init.vi`, `ZM-CP-publish.vi`, `ZM-CP-close.vi` into a `Methods` folder (report-04a, item 7).
- ZM-HW-SIM-simulated_hardware: class description (report-03b, item 8: "Pluggable simulated hardware: do returns a
  random TestPackage addressed to Communication; init/close inherited"); `ZM-HW-do.vi`, `ZM-HW-SIM-randomData.vi` into
  a `Methods` folder.
- ZM-HW-hardware: class description (text in briefs/brief-03a-hw-parent.md, "Conventions written out");
  `ZM-HW-init.vi`, `ZM-HW-do.vi`, `ZM-HW-close.vi` into a `Methods` folder (report-03a, item 7).
- ZM-PC-package: class description (text in briefs/brief-01a-pc-classes.md, "Descriptions"); move
  `ZM-PC-PACKAGE_TYPE.ctl`, `ZM-PC-DESTINATION.ctl`, `ZM-PC-HEADER.ctl` into the class, folder `TypeDefs`.
- ZM-PC-TP-test_package: class description (same brief); `ZM-PC-TP-DATA.ctl` into the class, folder `TypeDefs`.
- ZM-PC-EP-error_package: class description (same brief); `ZM-PC-EP-DATA.ctl` into the class, folder `TypeDefs`.
- All three PC classes: the 12 non-accessor members (`ZM-PC-init`, `ZM-PC-getDataAsJson`, `ZM-PC-getTypeName`,
  `ZM-PC-getDestinationName`, `ZM-PC-getTimestampString`, `ZM-PC-getHeader`; TP: `ZM-PC-init`, `ZM-PC-getDataAsJson`,
  `ZM-PC-TP-setType`, `ZM-PC-TP-create`; EP: the same four with `EP`) into a `Methods` virtual folder of their class
  (report-01b, item 2).

## Side effects outside src/

Files written outside `zuehlke-mcp-af-test-results/src/` and this run's folder, one line each. The full session-1
list is in "Side effects (session 1, unshortened)" above.

- 2026-10-10 15:06: LabVIEW 2026 32-bit started by the manager (`lvai_ensure_labview`, PID 2428); crashed 15:13:55 (F2).
- 2026-10-10 15:24: LabVIEW 2026 32-bit started again by the manager (PID 14040, port 59552), under the user's go-ahead. Still running at the hand-over.
- 2026-10-10 to 2026-10-11: the plugin's stub cache `...\LabVIEW 2026\user.lib\LV_MCP\` grew from 145 to 169 stub VIs (tool design).

## Usage-limit cut-offs (session 1)

| agent step | cut off | resumed | how |
|---|---|---|---|
| 01b | ~16:15 (session limit) | 16:22 | SendMessage to the same agent; finished 16:32 |
| 03b | ~18:45 (session limit) | 21:55 | SendMessage; finished 22:02 |
| 05a | ~23:20 (session limit) | 2026-10-11 02:22 | SendMessage; continued to commit 29e2187 |
| 05a | 2026-10-11, before ~09:25 ("You've reached your Fable limit") | not resumed | the user switched to Opus 5.5 and asked for a hand-over |
