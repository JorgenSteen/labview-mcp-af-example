# Brief 10e: ROOT cleanup, icons, sweep and the phase-10 closing checks
Type: build (LabVIEW calls). Phase 10 step e of 5 (last step of the phase).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-10d-root-actor-core-t7-proofs.md`,
  `report-09d-hwm-actor-core-proof-close.md` (the measured cleanup and icon route, the loop-VI probe before Clean Up).
  <<MANAGER: traps from reports 10b-10d go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**. D38, D39 (icons without a prompt).
- Every `lvai_*`/`pylv_*` call ALONE in its message. F10 and the BOM restore as before. An icon apply may re-save
  another class's `.lvclass`: restore it from git with the project closed if it is out of scope.

## Goal
Clean Up Diagram and icons on every VI phases 10a-10d generated (ROOT class folder and `ZM-TST-routing.vi`); the loop
VI `helperPanel` only after a throwaway copy proves Clean Up keeps its dynamic wiring, event specs, the use-default
tunnel and the panel flags cold. Icons: own layers, ROOT class template, library icon, apply, read back 0 px. Then the
closing checks of `orchestration/plan.md` "Every build phase ends with" for phase 10: descriptions on every VI; the
dependency rule of `02` §1 on the files (only the ROOT references SIM, FL, UDP, MX; nothing references the ROOT; HWM
and CM reference neither each other nor the ROOT); the `.lvproj` `actors` folder lists CM, HWM, ROOT once each; every
file at 26; a cold sweep of `src\actors` and `src\tests` (every VI state 1, control `0 7`), membership; T1-T7 rerun
cold, all Pass. Final commit `feat(root): root actor with routing and panel loop` (an empty marker if everything is
committed).

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; ROOT folder `...\src\actors\ZM-ROOT-root\`;
  tests `...\src\tests\`; proof `...\proof\ZMP-10e\`; evidence `...\proof\runs\10e-checks.txt`.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\cleanup.md`, `ops\icons.md` (steps 2-8), `ops\sweep.md`,
  `ops\run-checks.md`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it.
- No hand edits of LabVIEW files. In `src\` only the ROOT folder, `ZM-TST-routing.vi` and the `.lvproj` may change.
- Commit per batch/owner, explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The cleanup block (loop-VI probe first). 3. The icons block. 4. Closing
checks, one line each, with the T1-T7 readings. 5. Commits; `git status`. 6. Deviations; items for the user in the IDE
(the full ROOT list). 7. Side effects.
