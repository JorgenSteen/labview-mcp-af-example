# Brief 12b: the structural checks of `03` §3 and the final cold sweep over all of `src\`
Type: sweep / verify (mostly offline; a few LabVIEW reads). Phase 12 step b of 2 (last step of the phase). Nothing is built here.

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-12a-runs.md`,
  `report-10e-root-cleanup-icons-close.md` (the dependency check over 171 files, `lv_loadability --links`).
  <<MANAGER: traps from report 12a go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts. NO kill. Never answer a dialog.
- **The user (2026-10-11, "Mark pending, go on"; `CLAUDE.md`, D38 bullet):** rows that depend on IDE-only items - class
  descriptions, the `Methods`/`AF Overrides`/`Helpers`/`TypeDefs` virtual folders, `.ctl` class membership - are marked
  "pending: user in the IDE (D38)" with the list of what is missing; everything else in that row is still checked.
- **D40:** every `evaluateError` is a pass-through; the "Descriptions" row checks that actor descriptions state the
  D40 plan (the class descriptions themselves are pending, D38). F3 (13 vs 14 libraries): report the counted number of
  libraries against `02` §10 and the `03` row; do not decide it.
- Nothing in `src\` may change. Every `lvai_*`/`pylv_*` call ALONE in its message.

## Goal
One line of evidence per row of `03` §3 (lines 119-143 of `C:\project\claude\LabVIEW-AFAItest\requirements\03-acceptance.md`),
each marked pass / fail / pending (D38) / pass under D40, read from the FILES where possible (`.lvclass`, `.lvlib`,
`.lvproj` XML; `lv_loadability.py --links --vilib`; `pylv_extract` or exports for diagram shapes; the reports of phases
01-11 for what was measured there, cited by file and item). Rows: runnable (the cold sweep below), membership, the
dependency rule, naming (`02` §2), scope and accessors (only used accessors, in the used direction, static), every AF
override protected and calling its parent first where required, Pre Launch Init calls only `createResources`, Actor Core
shapes (ROOT, HWM), no Stop Core on ROOT and HWM, helper-loop shapes, one EVENTS and one PRELAUNCH_SETTINGS typedef per
actor, exactly one message class, every ignored error ends in Clear Errors and no unwired `error out`, error code 5000
(registered in `error-codes.md` and `ZM-errors.txt`; `#customerror 5000` at every raise), virtual folders, descriptions,
icons, Clean Up Diagram (nothing regenerated after it: compare each VI's last commit with its cleanup commit), the
project tree with its counts, and "a clean stop leaves `ZM-error_log.txt` empty" (from 12a's R-normal).
Then the **cold sweep** (`ops\sweep.md`) over all of `...\src\`, with the negative control, and `check_membership.py`.

## Paths
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; `...\src\`, `...\.labview\` (conventions,
  `decisions.md`, `error-codes.md` if present), `...\errors\` or the error-code file location (find it); proof
  `...\proof\ZMP-12b\`; evidence `...\proof\runs\12b-checks.txt`.
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\review.md`, `ops\sweep.md`, `kit\README.md`.
  Spec `...\requirements\02-specification.md` §1, §2, §9, §10; `03-acceptance.md` §3.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- Read-only on `src\`. A modal dialog: `lv_windows.ps1`, stop, never answer it. Commit nothing in `src\`. Never push.

## Report (max 80 lines), as your final message
1. `lvai_status` start/end. 2. The table: one line per `03` §3 row, verdict and evidence. 3. The cold sweep and
membership readings. 4. Defects found, each with the phase that owns it and the smallest fix. 5. The full D38 pending
list (per class: description, folder placements, `.ctl` membership). 6. Side effects; `git status`.
