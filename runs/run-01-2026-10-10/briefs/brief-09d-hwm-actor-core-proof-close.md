# Brief 09d: HWM Actor Core (loop, stop, close), the two throwaway runs, cleanup, icons, sweep, phase-09 closing checks
Type: build + test (LabVIEW calls, Actor Framework runs). Phase 09 step d of 4 (last step of the phase).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-09c-hwm-helper-loop.md`,
  `report-09b-hwm-hooks-overrides.md`, `report-08c-cm-launch-cleanup-icons.md` (the CM launch proof: how a proof VI
  launched, waited, stopped and read files; the measured cleanup and icon route).
- **D40 (the user, 2026-10-11; `CLAUDE.md`, "Errors are not handled yet"): it overrides run 2 below.** Every
  `evaluateError` is a pass-through: no `HWM\t5000` log line, no error package. The helper loop's raw error reaches
  the HWM's Last Ack; AF's default Handle Last Ack Core in the caller returns it, so the CALLER stops with it and its
  Stop Core stops the rest ("if any actor stops it should cascade and stop all"). Run 2 therefore expects: the
  whole throwaway tree stops by itself with code 5000 (source `ZM-HW-do.vi: must be overridden by a child class`)
  before the proof's own Normal Stop, the error log unchanged, no `ErrorPackage.jsonl`, the run returns, no hang. Run
  1 (SIM) is the clean case: only the proof's Normal Stop ends it. No Handle Last Ack Core override anywhere.
  If D40 is not yet in `zuehlke-mcp-af-test-results\.labview\decisions.md` with the cascade clause, add it.
  <<MANAGER: traps from reports 08c, 09b and 09c go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**. D38, D39 as before.
- Every `lvai_*`/`pylv_*` call ALONE in its message (F9). `lvai_run_vi_as_top_level` blocks on a VI that never
  returns: every proof VI RETURNS by itself. A proof VI run while a project is open is adopted into it: run proofs
  with the project CLOSED. Each writer of a timestamped log line gets its own file.

## Goal
(1) `Actor Core.vi` on the HWM (protected, `ops\override.md` + `ops\helper-loop.md` step 11): the loop
`helperAcquisition` as shape A beside Call Parent, `stop` as shape D after Call Parent on a fresh chain with the class
wire from before Call Parent, then shape D-close with `close`; Actor Core returns Merge(Call Parent, close). (2) The
two throwaway runs of the phase card. (3) The `ops\helper-loop.md` checks (stop reset, close order). (4) Cleanup,
icons, sweep, closing checks; final commit `feat(hwm): hardware manager actor with acquisition loop`.

## Paths (absolute, long form)
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`; HWM
  folder `...\src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\`. Proof folder (git-ignored)
  `...\proof\ZMP-09d\`; outputs `...\output\test_hwm_<tick>\`; error log `...\output\ZM-error_log.txt`.
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\override.md` (shapes A, D, D-close),
  `ops\helper-loop.md` (step 11, Checks), `ops\run-checks.md`, `ops\cleanup.md`, `ops\icons.md`, `ops\sweep.md`,
  `knowledge\actor-framework.md` ("Observing and testing actors").

## Route
1. `lvai_status`; project closed; `git status --short`; commit point.
2. **Actor Core override** (bare first, commit), then the three hooks in the order of `ops\helper-loop.md` step 11,
   `pa_save_member` after each in its own call; export and quote the shape.
3. **The caller for the runs** (the HWM forwards every package to its CALLER through `ZM-CI-handlePackage`, so a
   root-launched HWM has no observable caller). Preferred route, all in the proof folder and never in `src\`: a
   throwaway class `ZMP09d-caller` inheriting `ZM-CM-communication_manager` (it already implements the interface and
   publishes every package it receives to its protocol), with one Actor Core override whose series hook before Call
   Parent fills `ZM-HWM-PRELAUNCH_SETTINGS {hardware, intervalMs 500}` → `ZM-HWM-writePrelaunchSettings` → `Launch
   Nested Actor` (auto-stop T). Use a scratch project in the proof folder for it, never the product's `.lvproj`. A
   lighter route is fine if it gives the same evidence; say which you took.
4. **Run 1 (SIM):** proof VI launches the caller as root with an MX of one FL on a temp folder and a SIM, waits 3 s,
   sends Normal Stop, waits, reads `TestPackage.jsonl`: about 6 lines (5-7), error log unchanged, the run returns, the
   helper VI's panel closed (`lv_windows.ps1`), a second run gives the same readings.
5. **Run 2 (bare `ZM-HW-hardware`):** the same with the parent hardware: `do` returns 5000, the loop ends, HWM
   `evaluateError` logs `HWM\t5000\t...` (one new error-log line) and sends ONE error package up (one line in
   `ErrorPackage.jsonl`), the HWM stops with a clean Last Ack (the caller keeps running until the proof's Normal Stop),
   the run returns.
6. **Helper-loop checks:** the stop reset (the loop VI called twice from one caller, per `ops\helper-loop.md`) and the
   close order (timestamped lines, own files). If either needs a code change in `src\`, stop and report.
7. **Cleanup** (`ops\cleanup.md`) on the HWM VIs this phase generated (not on the loop VI if Clean Up Diagram would
   break its dynamic wiring: measure on a throwaway copy first and report); **icons** (`ops\icons.md` steps 3-8,
   owner `ZM-HWM-hardware_manager` class and library; read back 0 px); commit per batch/owner.
8. **Closing checks:** descriptions on every VI; dependency links (no `ZM-HW-SIM`, `ZM-CM`, `ZM-ROOT`, `ZM-CP*`); the
   `.lvproj` `actors` folder lists the HWM library once; every file at 26; cold sweep of the HWM folder (every VI 1,
   control `0 7`), membership; `git status --short` clean except the manager's files.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. A proof VI
  that does not return within its timeout: stop, `lv_windows.ps1`, report; never abort an actor by VI Server.
- Proof VIs and the throwaway caller live ONLY in the proof folder, never in the product project (drop any adopted
  entry with `lvproj_drop.py`, project closed). No hand edits of LabVIEW files. Nothing outside
  `src\actors\ZM-HWM-hardware_manager\` and the `.lvproj` may change in `src\`.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop.

## Report (max 80 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The Actor Core `ops\override.md` block and its export. 3. The caller route.
4. Run 1 and run 2: readings of each (lines, error-log lines, codes, durations), second run. 5. Stop reset and close
order. 6. Cleanup and icon blocks. 7. Closing checks, one line each. 8. Commits; `git status`. 9. Deviations / NEEDS
CLARIFICATION / items for the user in the IDE. 10. Side effects.
