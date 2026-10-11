# Brief 12e: two fixes from 12b - unwired error terminals in `ZM-TST-routing.vi`, Clean Up Diagram on the CM `Handle Error.vi`
Type: fix (LabVIEW calls). Phase 12 step e (owned by 10d and 09c); afterwards phase 12 closes.

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-12b-structural-sweep.md`
  (item 4, defects a and b), `report-10d-root-actor-core-t7-proofs.md` (how T7 was built: direct route, the ROOT seed
  swapped, `lvai_add_to_library`; AIXML in `...\zuehlke-mcp-af-test-results\proof\ZMP-10d\ZM-TST-routing.xml`),
  `report-10e-root-cleanup-icons-close.md` (cleanup and icon route for T7).
- State (12b, 2026-10-11 22:20): LabVIEW PID 26716, port 56779, project closed, no dialog. The user's STANDING kill
  go-ahead for this session: "feel free to kill labview at will for this session" (report each kill).
- Traps: a VI that is a member of a LOADED library cannot be regenerated over its path (1357): with the project closed
  `remove_members.py <.lvlib> "<vi>"` (no `--delete-files`), generate, swaps, `lvai_add_to_library` again (report-05c
  item 6a); `lvai_add_to_library` re-saves other test VIs: restore them from git with the project closed; **broken wire
  first** (`pa_clean_member`); F10 before any `lvproj_*` script; one call per message.

## Goal
(a) **`src\tests\ZM-TST-routing.vi`**: the six `Search and Replace String` nodes get their error terminals wired into
the test's error chain (`errors.ignored-errors`: no unwired `error out`); nothing else changes (same checks, same
`Pass`). Prefer an in-place scripted edit (wire the nodes' `error in`/`error out` into the existing chain); if you must
regenerate, keep the 10d AIXML and add only those wires. Then T7 cold: PASS (Pass T, error 0, four checks T), Clean Up
Diagram, the icon re-applied and read back at 0 px, membership, version 26. (b) **CM `Handle Error.vi`**
(`...\src\actors\ZM-CM-communication_manager\ZM-CM-communication_manager\Handle Error.vi`): Clean Up Diagram per
`ops\cleanup.md` (project closed), size before/after, cold state 1, the icon read back (0 px), version 26. Then a cold
sweep of `src\tests` and the CM folder (every VI 1, control `0 7`). Commit each fix: `fix(test): ...`, `style(cm): ...`.

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; proof `...\proof\ZMP-12e\`; evidence
  `...\proof\runs\12e-checks.txt`. `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`ops\cleanup.md`,
  `ops\icons.md`, `ops\sweep.md`, `ops\run-checks.md`).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- Kills: the standing go-ahead (reported). A modal dialog: `lv_windows.ps1`, stop, never answer it.
- No hand edits of LabVIEW files. In `src\` only `ZM-TST-routing.vi`, the CM `Handle Error.vi`, `ZM-TST-tests.lvlib`
  (if the membership route needs it) and the `.lvproj` may change; restore anything else from git (project closed).
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0.

## Report (max 40 lines), as your final message
1. `lvai_status` start/end; kills/starts. 2. Fix (a): route, the six nodes' wiring as exported, T7 readings, cleanup,
icon. 3. Fix (b): cleanup block, state, icon. 4. Sweep, membership, versions. 5. Commits; `git status`. 6. Side effects.
