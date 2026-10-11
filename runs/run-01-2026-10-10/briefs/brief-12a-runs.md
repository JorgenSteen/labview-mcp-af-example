# Brief 12a: the acceptance runs of `03` §2 and the tests T1-T7, on a cold LabVIEW
Type: test (LabVIEW calls, Actor Framework runs). Phase 12 step a of 2 (b: structural checks of `03` §3 and the cold sweep). Nothing is built here.

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-11a-launchers.md`,
  `report-11b-receiver-close.md`, `report-10d-root-actor-core-t7-proofs.md` (the headless Stop press, a launch proof),
  `report-09d-hwm-actor-core-proof-close.md` (the stop-reset route), `report-08c-cm-launch-cleanup-icons.md` (a PLI failure).
  <<MANAGER: traps from report 11b go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. NO kill. Never answer a dialog. The user's go-ahead (2026-10-11 ~20:10, "Agent presses"):
  press the Stop buttons of the root panel and `ZM-receiver.vi` by a SIGNALLING write (`Value (Signaling)`, the kit's
  `pa_press_control_signal` route measured in 10d).
- **D40** (`C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`, "Errors are not handled yet"): R-error is judged against
  D40, not against `03`'s wording: expected the tree stops by itself with 5000 within about a second, the launcher
  returns, `lines_written` 0, `error_lines` 0, `ui_errors` empty, `error out` 1556 (the Normal Stop to a gone root; 11a
  measured exactly that). Report the readings; mark "pass under D40" only if they match.
- F8 is kept as is (the user). F13: T4 failed once on `init_ok` in 10e: run T4 FIVE times cold and report each
  `init_ok`; on a failure, keep that run's `output\test_fl_*` folder and list its contents.
- Nothing in `src\` may change. Proof VIs only in `...\proof\ZMP-12a\`, never in the project (drop adopted entries,
  F10 first). Every `lvai_*`/`pylv_*` call ALONE in its message. A run that does not return within its timeout: stop,
  `lv_windows.ps1`, report; never abort an actor by VI Server.

## The runs (`03` §2), in this order; evidence `...\proof\runs\12a-checks.txt`, one line per run
1. **R-normal ×3**: `src\ZM-launcher_test.vi` defaults, three cold runs: `lines_written` 8-11, `last_line` a TestPackage
   with five data fields and `"destination":"Communication"`, `error_lines` 0, `ui_errors` empty, `error out` 0;
   afterwards no ROOT/HWM panel (`lv_windows.ps1`) and both helper loops and every Actor Core cold state 1.
2. **R-error**: `use_placeholder_hardware` T, judged per D40 above.
3. **R-interactive**: run `src\ZM-launcher.vi` (it returns right after the launch; the tree keeps running); a proof VI
   waits ~3 s, reads the HWM panel's `interval measured (ms)` (≈ 500) by VI Server, presses the root's `Stop` by a
   signalling write; then the line count stays stable for 3 s, both panels closed, both loops out of memory.
4. **R-receiver**: during a tree run (launched by a proof VI), start `src\receiver\ZM-receiver.vi` asynchronously (VI
   Server `Run VI`, Wait Until Done F), wait ~3 s, read `last line` (a TestPackage, `"destination":"Communication"`),
   `packets` (> 0, rising) and `interval measured (ms)` (≈ 500); press the receiver's `Stop` by a signalling write; the
   tree keeps running with no error (a Normal Stop to it afterwards answers 0). Port 61557 must be free: check first
   (`netstat -ano`), a busy port is an environment problem, not a defect.
5. **R-viewer**: check that `output\TestPackage.jsonl` from an R-normal run is well formed (every line parses as JSON
   with `timestamp`, `type`, `destination`, `data`); the user opens `tools\jsonl_viewer.html` later.
6. **R-close-order**: per actor with a helper loop: the stop, the loop's exit, then `close`. No log writes may be
   added to `src\`. Find a non-invasive measurement (e.g. a proof VI polling `Execution.State` of the loop VIs and the
   Actor Cores by VI Server with millisecond timestamps), or report the dataflow proof from the Actor Core exports
   (`close` fed only by Merge(loop, stop)) as the evidence, saying which.
7. **R-stop-reset**: the HWM `stop` reset by calling the loop twice from one caller (09d's route: one proof VI, CM as
   caller, HWM#1 3 s → Normal Stop → HWM#2 3 s → Normal Stop; 6 + 6 lines).
8. **R-pli-failure**: a failing `createResources` makes the launch fail with that error, releases what was created,
   nothing hangs. Without changing `src\`: launch the ROOT with an invalid `outputFolder` (08c's `test_bad<>|_` name):
   the CM's PLI fails, Launch Nested Actor returns the error into the root's Call Parent, the root stops; report the
   code, the time, the panels and the error log. Say plainly what this proves and what it does not (the ROOT's own
   `createResources` failure is not injected).
9. **T1-T7** cold from `.labview\checks.json` (T4 five times, F13).

## Paths
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; `src\ZM-launcher_test.vi`,
  `src\ZM-launcher.vi`, `src\receiver\ZM-receiver.vi`; `output\`; proof `...\proof\ZMP-12a\`.
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\run-checks.md`, `ops\helper-loop.md` (Checks),
  `knowledge\actor-framework.md` ("Observing and testing actors"). Spec `...\requirements\03-acceptance.md` §1, §2.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it.
- Read-only on `src\`: nothing there may change (restore any re-save from git with the project closed, and report it).
  Commit nothing in `src\`. Never push.

## Report (max 70 lines), as your final message
1. `lvai_status` start/end; starts made. 2. One line per run with every reading and the verdict (pass / fail / pass
under D40 / not measurable: why). 3. T1-T7 readings (T4 ×5). 4. Defects found, each with the phase that owns it.
5. Side effects (output files, adopted items dropped, re-saves restored). 6. `git status`.
