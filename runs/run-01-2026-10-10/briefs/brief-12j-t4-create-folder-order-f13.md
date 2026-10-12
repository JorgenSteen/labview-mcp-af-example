# Brief 12j: F13 - run T4's second Create Folder after `init` (`ZM-TST-protocol.vi`)
Type: fix (LabVIEW calls). After the run (run-01 closed, result accepted 2026-10-12). Asked for by the user
2026-10-12: "sounds good do it like that".

## Why (F13, `runs\run-01-2026-10-10\findings.md`)
T4's `init_ok` = (`ZM-CP-init` gives no error) AND (a second `Create Folder` on the same folder answers code 10). In
the build source (`...\proof\ZMP-05c\ZM-TST-protocol.xml`, built in a1e87f0; later commits only cleanup and icons)
that `Create Folder` (uid 5124) gets only the path (Build Path uid 5115); its `error in` is unwired, so nothing orders
it after `ZM-CP-init` (uid 5121). When it runs first it creates the folder (code 0), the FL `createFolder` hook then
finds the folder (no error), and `init_ok` reads F while every other check passes. That is exactly what all four
flakes showed (10e, 12h2, 12g, 12i). Not measured: the test does not show the code.

## Goal
1. **One wire:** `ZM-CP-init` `error out` -> that second `Create Folder`'s `error in`. Nothing else changes on the
   diagram (the `init_ok` logic, the other branches of init's `error out`, the pane, the panel stay as they are).
   First confirm on an export of the CURRENT VI that the race is there (the `Create Folder` whose code goes to the
   Equal? with constant 10 has an unwired `error in`); if the current VI differs from the 05c source, stop and report.
2. **Description** by `pa_replace_description`, one replacement, ASCII only: "proven by a second Create Folder
   answering code 10 on its own error chain" becomes "proven by a second Create Folder answering code 10, wired after
   init on init's error chain (F13)" (or the nearest equivalent of the text as it is stored).
3. Clean Up Diagram on this VI (`ops\cleanup.md`) as the last diagram step; icon read back at 0 px against
   `proof\icons`.
Route: in-place scripted edit (a derived helper or `pylv_apply`, as 12g did for `releaseProtocol`:
`report-12g2-cm-release-error-d44-option-a.md`, item 2, helper `proof\ZMP-12g\zmp12g_release_pass_on.xml`); dry run
first (find each node and terminal exactly once). Regenerate only if that fails, from an export of the current VI.

## Checks
Export after the edit shows the new wire; `exec_state` 1 cold; **T4 run 10 times** on a cold LabVIEW (project closed),
each reading reported (Pass, error, `init_ok`, the output folder); then T1-T7 once (`ops\run-checks.md`, the list in
`.labview\checks.json`). A T4 `init_ok` F after the fix is a finding, not a rerun case: report it and stop.
`lv_save_version.py` 26 on the changed file; `git status` lists only `src\tests\ZM-TST-protocol.vi` (restore anything
else from git, project closed). Commit: `fix(tst): run T4's second Create Folder after init (F13)`.

## LabVIEW now
PID 5672, port 59269 (started by the 12i agent 2026-10-12 09:11:51), project closed, 0 unsaved, no dialog, LVAutoSave 0.
**Standing go-ahead for this session (the user): you may start, restart, close and kill LabVIEW at will;** report each.

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; the VI
  `...\src\tests\ZM-TST-protocol.vi` (in `ZM-TST-tests.lvlib`); proof `...\proof\ZMP-12j\`; evidence
  `...\proof\runs\12j-checks.txt`.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`ops\cleanup.md`, `ops\icons.md`, `ops\sweep.md`,
  `ops\run-checks.md`, `kit\pa_replace_description.xml`, `knowledge\labview-mcp.md`).
- Traps: a member of a LOADED library cannot be regenerated over its path (1357): prefer the in-place edit; a project
  close may change only the `.lvproj` BOM/EOL: restore from git; class and VI texts are stored ANSI (ASCII only); the
  scratch `LVMCP Validate*` VIs bring up a save dialog on a LabVIEW close: kill instead (go-ahead above).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: **one lvai_*/pylv_* call per message, never two, offline ones included.**
- A modal dialog: `lv_windows.ps1`, stop, never answer it.
- No hand edits of `.vi`, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj`. Write only inside
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\`.
- Commit by explicit paths, Conventional Commits, no attribution trailer of any kind. Never push. Save version 26.0.
- Take times from `date`/`Get-Date`, not from memory.

## Report (max 40 lines), as your final message
1. `lvai_status` start/end; kills/starts. 2. The export before: the race confirmed (or not). 3. Route and the export
after. 4. Description, cleanup, icon. 5. T4 x10 (one line each), T1-T7. 6. Versions, commit, `git status`. 7. Side
effects. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
