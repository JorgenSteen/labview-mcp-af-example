# Brief 12g: D44 - the CM logs a release error and passes it on (`releaseProtocol`, Stop Core)
Type: fix (LabVIEW calls). After phase 13 (the run is closed, result partial); decided by the user 2026-10-11 (D44).

## UPDATES (read first; they override the rest)
- 12f, 12h1, 12h2 done (791ccab..2340484): every class has its description, virtual folders and TypeDefs by VI Server
  scripting. For you: CM `releaseProtocol` is in the CM class's `Methods` folder and `Stop Core.vi` in `AF Overrides`
  (virtual folders only; the files did not move); `ZM-CM-PRELAUNCH_SETTINGS.ctl` is now a CM class member. Sweep
  137/137 and T1-T7 PASS at the end of 12h2 (T4's `init_ok` flaked once in 12h2, F13: one rerun is allowed, report it).
  LabVIEW at 08:41 (2026-10-12): PID 26716, port 56779, project closed, no dialog, LVAutoSave 0, only the 2
  `LVMCP Validate*` scratch VIs unsaved. New traps: a class or VI text is stored ANSI ("→" becomes "?": use ASCII);
  the in-memory list helper's answer is over the tool-result limit (`proof\ZMP-12h1\mem_lines.py`); a project close
  may change only the `.lvproj` BOM/EOL: restore from git.
- **Standing go-ahead for this session (the user, 2026-10-11): you may start, restart, close and kill LabVIEW at
  will;** report each one.
- D44 (product `.labview\decisions.md`), the user's words: "log, but let the error pass through". Today (report-08b,
  item 2): `ZM-CM-releaseProtocol.vi` = Read protocol -> ZM-CP-close -> Write protocol; code 1 cleared without a log;
  any other close error -> ZM-CU-log, then cleared; `error out` carries only a failure of the log. CM `Stop Core.vi`
  = Call Parent -> releaseProtocol (error in unwired) -> class out; releaseProtocol `error out` -> Clear Errors.
- Traps (status.md "Traps carried forward"): **broken wire first** (`pa_clean_member`) before any rebuild; a member of
  a LOADED library cannot be regenerated over its path (1357): prefer in-place scripted edits; `.lvproj` BOM/EOL
  after a close: restore from git if otherwise unchanged; F10 before any `lvproj_*` script; one call per message.

## Goal
1. **`ZM-CM-releaseProtocol.vi`**: code 1 stays cleared without a log; any other close error is logged with
   `ZM-CU-log` as today AND goes out on `error out` (Merge Errors: the close error first, then a log failure).
   Nothing else changes (pane, scope private, static).
2. **CM `Stop Core.vi`**: remove the Clear Errors; `error out` = Merge Errors(Call Parent `error out`, releaseProtocol
   `error out`); Call Parent still runs first. Nothing else changes.
3. Both descriptions updated by `pa_replace_description` to say "logged and passed on (D44)" instead of "cleared"
   (keep the rest of each text). Clean Up Diagram on both (`ops\cleanup.md`), icons read back at 0 px.
Route: in-place scripted edits (delete the Clear Errors, add Merge Errors, wire) with a derived helper or
`pylv_apply`; regenerate only if that fails, from an export of the current VI.

## Checks
Export of both VIs shows the new dataflow; cold `exec_state` 1 for the CM folder (sweep); a normal-stop run of the
08c launch proof (MX of one FL, 3 packages, Normal Stop): 3 lines, `ZM-error_log.txt` unchanged, Last Ack error 0;
if a cheap way exists to force a non-1 close error on a proof copy, show it is logged AND reaches `error out`
(otherwise say "not forced"); T1-T7 PASS (T4 three times); `lv_save_version.py` 26 on every changed file; `git
status` lists only the two VIs (restore anything else from git, project closed). Commit: `fix(cm): log and pass on a
release error (D44)`.

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; CM folder
  `...\src\actors\ZM-CM-communication_manager\ZM-CM-communication_manager\`; proof `...\proof\ZMP-12g\`; evidence
  `...\proof\runs\12g-checks.txt`; reports to read: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\`
  `report-08b-cm-hooks-overrides.md`, `report-08c-cm-launch-cleanup-icons.md`, `report-12e-fix-routing-cm-handle-error.md`.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`ops\cleanup.md`, `ops\icons.md`, `ops\sweep.md`,
  `ops\run-checks.md`, `kit\pa_replace_description.xml`, `kit\pa_clean_member.xml`).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- A modal dialog: `lv_windows.ps1`, stop, never answer it. Kills only under the go-ahead in the launch message.
- No hand edits of `.vi`, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj`. Write only inside
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\`.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0.
- Take times from `date`/`Get-Date`, not from memory.

## Report (max 40 lines), as your final message
1. `lvai_status` start/end; kills/starts. 2. releaseProtocol: route, the export's dataflow. 3. Stop Core: same.
4. Descriptions, cleanup, icons. 5. Runs: proof, forced error (or "not forced"), T1-T7. 6. Sweep, versions, commit,
`git status`. 7. Side effects. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
