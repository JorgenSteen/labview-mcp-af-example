# Brief 12i: re-check `03` §3 after 12h and 12g, cold sweep, T1-T7
Type: verify (mostly offline; LabVIEW for the sweep and the test runs). After phase 13 (the run is closed, result
partial). Post-run step 12i, the last one. Nothing is built here; nothing in `src\` changes.

## UPDATES (read first; they override the rest)
- <<MANAGER: 12h2's result (commits, LabVIEW state, new traps)>>
- <<MANAGER: 12g's result (commits, the D44 dataflow, LabVIEW state)>>
- Reports to read first (`C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\`): `report-12b-structural-sweep.md`
  (the last full §3 table: 17 pass, 3 pending D38, F3, 1 fail fixed by 12e), `report-12f-ide-items-probe.md`,
  `report-12h1-d38-items-pc-hw-cp.md`, `report-12h2-d38-items-actors-ci.md`, `report-12g-cm-release-error-d44.md`.
- Decisions to judge against (product `.labview\decisions.md`, `C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`): D38 (the IDE
  items, now done by VI Server scripting in 12f/12h), D40 (evaluateError pass-through, loops stop each other), D41
  (`init` per actor with a helper loop), D42 (13 libraries, not 14), D43 (every launcher has an `error out`), D44 (the CM
  logs a release error and passes it on: no Clear Errors after `releaseProtocol` in Stop Core).
- `02` §2/§6: `Accessors` holds generated AND custom accessors (`writePrelaunchSettings` is "a public custom accessor").
- **Standing go-ahead for this session (the user, 2026-10-11): you may start, restart, close and kill LabVIEW at
  will;** report each one. Never answer a dialog.

## Goal
1. **Re-judge these rows of `03` §3** (`C:\project\claude\LabVIEW-AFAItest\requirements\03-acceptance.md`, §3) from the
   files: **Virtual folders** (every class: `Accessors`, `AF Overrides`, `Helpers`, `Methods`, `TypeDefs` where non-empty;
   the library's `Messages` folder; no member at a class root except its private data `.ctl`; the 11 typedefs are class
   members: PC 5, MX 1, ROOT 2, HWM 2, CM 1); **Descriptions** (all 15 classes, interface and message class included,
   have one; CM, HWM, ROOT state the D40 error plan; every VI still has one); **Every class member still a member; every
   class in its library** (`check_membership.py`); **Ignored errors** (judged with D44: the CM release error is logged
   and passed on, so no Clear Errors after it; every other deliberately unhandled error still ends in Clear Errors; no
   unwired `error out`); **Project tree** (13 libraries, D42; 2 launchers each with `error out`, D43; 7 tests; the
   receiver; the six virtual folders); **Clean Up Diagram** (only for VIs changed after 12b: was Clean Up the last change).
2. For every other row, carry 12b's verdict forward unless a file in that row changed after 12b (`git log` since the
   12b report's commit): then re-judge it.
3. **Cold sweep** of all `src\` (`ops\sweep.md`) with the negative control; `lv_save_version.py` 26 on every file.
4. **T1-T7 PASS** on a cold LabVIEW, **T4 three times** (`ZM-TST-packages`, `-log`, `-hardware`, `-protocol`, `-udp`,
   `-pipeline`, `-routing` in `...\src\tests\`; `ops\run-checks.md`).

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`; proof
  `...\proof\ZMP-12i\`; evidence `...\proof\runs\12i-checks.txt`.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`ops\review.md`, `ops\sweep.md`, `ops\run-checks.md`,
  `kit\README.md`, `knowledge\labview-mcp.md`). Spec `...\requirements\02-specification.md` §1, §2, §6, §10.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: **one lvai_*/pylv_* call per message, never two, offline ones included.**
- Read-only on `src\`: no save, no commit in `src\`. If the project close changes the `.lvproj` (BOM/EOL), restore it from
  git with the project closed. A modal dialog: `lv_windows.ps1`, stop, never answer it. Never push.
- Write only inside `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\` (proof and evidence, git-ignored).
- Take times from `date`/`Get-Date`, not from memory.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; kills/starts. 2. The full `03` §3 table: one line per row, verdict (pass / fail / pass under
D4x) and evidence (re-judged or carried from 12b). 3. Sweep, membership, versions. 4. T1-T7 (T4 x3) readings. 5. Defects,
each with the smallest fix. 6. Side effects; `git status`. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
