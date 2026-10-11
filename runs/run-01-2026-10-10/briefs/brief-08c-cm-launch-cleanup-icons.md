# Brief 08c: CM launch proof, a forced PLI failure, then cleanup, icons, sweep and the phase-08 closing checks
Type: test + build (LabVIEW calls, Actor Framework runs). Phase 08 step c of 3 (last step of the phase).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-08b-cm-hooks-overrides.md`
  (what exists, the shapes, the releaseProtocol code, the sweep baseline), `report-08a-cm-class.md`,
  `report-05d-cp-cleanup-icons-sweep.md` (the measured cleanup and icon route; your report blocks follow it).
  <<MANAGER: traps from report 08b go here before launch>>
- Save version **26.0**. Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed;
  agents may too." (max two starts, each reported; never answer a dialog). D38, D39 as before.
- Traps: every `lvai_*`/`pylv_*` call ALONE in its message; never probe with `lvai_validate_aixml`; read a `.lvproj`
  diff before restoring it; `lvai_run_vi_as_top_level` blocks on a VI that never returns, so every proof VI here
  RETURNS by itself (it launches, waits, stops, waits, reads, returns); a proof VI run while a project is open is
  adopted into it: run proofs with the project CLOSED; two VIs appending to one log file at the same moment overwrite
  each other (`knowledge/actor-framework.md`, "Observing and testing actors").

## Goal
(1) Prove the CM in a throwaway launch, never under `src\`: launch it as a root actor with an MX holding one FL on a
temp folder, send three test packages through the interface message, send Normal Stop, and see three lines in the
file, an empty error log, and the Actor Core idle afterwards. (2) A forced Pre Launch Init failure: the launch fails
with that error and nothing hangs (`03` R-pli-failure, CM part). (3) Clean Up Diagram and icons for the CM VIs the
build generated, and the phase-08 closing checks. Commit `feat(cm): communication manager actor` at the end if the
earlier commits did not already carry the phase.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`;
  CM class folder `...\src\actors\ZM-CM-communication_manager\ZM-CM-communication_manager\`.
- Proof folder (git-ignored): `...\proof\ZMP-08c\` holding the proof VI(s) and their AIXML; temp output
  `...\output\test_cm_<tick>\`; the error log `...\output\ZM-error_log.txt` (read its line count before and after; a
  clean run adds 0 lines).
- AF: `...\LabVIEW 2026\vi.lib\ActorFramework\` (`Actor\Launch Root Actor.vi`, `Actor\Send Normal Stop.vi` or the
  Stop Msg's `Send Normal Stop.vi`; find the exact files by listing, no guessing).
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\run-checks.md` ("Behaviour runs"),
  `ops\cleanup.md`, `ops\icons.md` (steps 2-8; D39), `ops\sweep.md`, `knowledge\actor-framework.md`.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point.
2. **Proof VI `ZMP-08c-launch_cm.vi`** (proof folder; AIXML with the Write tool; generate with the project open and
   members opened through it, then CLOSE the project before running): FL constant → `Write outputFolder` (temp) → up-cast
   → `Build Array` → MX `Write protocols` → bundle `ZM-CM-PRELAUNCH_SETTINGS` → `ZM-CM-writePrelaunchSettings` →
   `Launch Root Actor` (CM object; open Actor Core front panel F) → enqueuer → 3 × (`ZM-PC-TP-create` → `Write
   destination` Communication → `Send ZM-CI-handlePackage`) → `Wait (ms)` 500 → `Send Normal Stop` → `Wait (ms)` 1000 →
   read `TestPackage.jsonl` (count LF) → indicators `lines` (I32), `launch_error`, `error out`. Run it cold with
   `lvai_run_vi_and_read_values` (timeout 30 s). Expected: `lines` 3, every error 0, the error log unchanged.
   Afterwards a cold `lvai_exec_state` of the CM's `Actor Core.vi` from vi.lib is not meaningful (shared); instead
   prove the stop by: the run returned, `lv_windows.ps1` shows no CM panel, and a second run of the same proof VI
   gives the same readings.
3. **Forced PLI failure** (`ZMP-08c-pli_failure.vi`): the same launch, but with an FL whose `outputFolder` is an
   invalid path that `Create Folder` rejects (a bare parent's `init` would succeed, so it cannot force the failure)
   (e.g. a path under a non-existent drive letter such as `Q:\nope\` if `Q:` does not exist; check offline first), so
   `createResources` fails: expected `Launch Root Actor` returns that error, no hang (the run returns within its
   timeout), and the error log is unchanged (Stop Core does not run after a failed PLI). Report the code.
4. **Cleanup** (`ops\cleanup.md`) on the CM VIs the build generated (members, hooks, the interface override, the AF
   overrides: on overrides the diagram is scripted, so Clean Up Diagram is the fallback the convention allows; report
   their sizes before and after). Versions; git shows only those `.vi`; sweep before = after. Commit per batch.
5. **Icons** (`make_icons.py --check`, generate; `ops\icons.md` steps 3-8 for owner `ZM-CM-communication_manager`
   class and library): own layers, class template, library icon, apply, read back 0 px. Commit per owner.
6. **Closing checks:** descriptions on every VI (offline read, as 05d did); the class description text for the user
   (D38) carries the error plan; dependency links as in 08b step 7 (no concrete protocol child); the `.lvproj`
   `actors` folder lists the CM library once; every file at 26; cold sweep of the CM folder; `git status --short` clean.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. A proof VI
  that does not return within its timeout: stop, `lv_windows.ps1`, report; never abort an actor by VI Server.
- Closing a project: open yours first, pass projectPath. No hand edits of LabVIEW files. Proof VIs live ONLY in the
  proof folder and are never added to the project (drop any adopted entry with `lvproj_drop.py`, project closed).
- Nothing outside `src\actors\ZM-CM-communication_manager\` and the `.lvproj` may change in `src\`. Commit by explicit
  paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The launch proof: readings of both runs (lines, codes, error-log line
counts), how the stop was proven. 3. The PLI failure: the code, the time to return, the error log. 4. The cleanup and
icons blocks. 5. Closing checks, one line each. 6. Commits; `git status`. 7. Deviations / NEEDS CLARIFICATION; items
for the user in the IDE. 8. Side effects (output files, adopted items dropped, helpers).
