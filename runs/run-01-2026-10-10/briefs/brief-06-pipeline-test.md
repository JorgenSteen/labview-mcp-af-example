# Brief 06: `ZM-TST-pipeline.vi` (T6), run until Pass, then every test of phases 01-05 run again; cleanup and icon
Type: build + test (LabVIEW calls). Phase 06, one step.

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-05c-cp-tests.md`
  and `report-05d-cp-cleanup-icons-sweep.md` (the state of the tree, the test-VI route over several libraries, the
  cleanup and icon routes), `report-03b-hw-sim-test.md` (item 5), `report-04b-cp-fl-test.md`.
- Phase 05 closed 2026-10-11 10:27 (reports 05a2-05d): every class of phases 01-05 is built, tested, cleaned and has
  icons; sweep of `src\protocol` + `src\tests` 41/41. `ZM-TST-tests.lvlib` holds five tests now.
- Traps from 05c: a VI already in a LOADED library cannot be regenerated over its path (1357): remove the member
  with the project closed, regenerate, re-add (only if your T6 needs a second generation). A project close may drop
  the `.lvproj` BOM or change only its line endings: `git checkout` it with the project closed. T5 deletes and
  rewrites `output\test_mx_a\` and `output\test_mx_b\`; T2 appends two lines to `output\ZM-error_log.txt`: both
  are expected side effects of the reruns.
- Measured model for T6's AIXML: `proof\ZMP-04b\` (T4 over FL), `proof\ZMP-03b\` (T3 over SIM and the bare
  parent), `proof\ZMP-05c\ZM-TST-udp.xml` (a For loop is NOT in those; T6 needs one with shift registers and a
  conditional stop on the error: author it per `lvai_aixml_reference`, `<Condition>` on a For loop is supported).
- Every `lvai_*` and `pylv_*` call goes ALONE in its message, offline ones included: broken in 05a2, 05b and 05d.
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D39: icons without a prompt; D38 does not apply (no class).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib`; `Match Regular Expression` is not
  authorable; a test VI's panel comes back whole (keep it small); class-constant seeds are swapped with
  `constantsJson`; port 61557 must be free for T5 (PowerShell `Get-NetUDPEndpoint -LocalPort 61557`, no LabVIEW call).

## Goal
Prove the data path without actors: `ZM-TST-pipeline.vi` (T6) in `ZM-TST-tests.lvlib`, `Pass` true cold; then run
every entry of `checks.json` that has a VI (T1-T6) and report each. No production code is added. If T6 shows a defect
in a class of phases 01-05, STOP and report the exact reading (the manager routes the fix); do not patch a class.
Then Clean Up Diagram and the icon for this one VI, and the closing checks.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`;
  test `...\src\tests\ZM-TST-pipeline.vi` (new) in `...\src\tests\ZM-TST-tests.lvlib`.
- Classes used: SIM `...\src\hardware\ZM-HW-SIM-simulated_hardware\...`, parent `...\src\hardware\ZM-HW-hardware\...`,
  FL `...\src\protocol\ZM-CP-FL-file_logger\...`, CP parent, packages. T6's temp folder: `...\output\test_pipeline_<tick>\`
  (created by the FL's `init`).
- AIXML `...\proof\ZMP-06\`; evidence `...\proof\runs\06-checks.txt`; icons `...\proof\icons\`; read-back
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\06\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\run-checks.md`, `ops\sweep.md`,
  `ops\cleanup.md`, `ops\icons.md`, `knowledge\labview-mcp.md`, `kit\README.md`. Conventions `...\.labview\conventions\hygiene.md`,
  `icons.md`; `checks.json` (entry `ZM-TST-pipeline`, `class_under_test` the SIM). Spec: `03-acceptance.md` T6;
  `01-requirements.md` §4; `04-decisions.md` D13.

## The test (T6), indicators exactly (`Pass` = AND of two, `error out`)
| indicator | proves |
|---|---|
| `pipeline_ok` | a SIM and an FL (`Write outputFolder` = the fresh temp folder), both on their parent wires: `init` both; 10 × (`do` → `publish`); `close` both; then `TestPackage.jsonl` in that folder has 10 lines and each line unflattens (header + data cluster) with five data fields |
| `error_stops_ok` | the same with a bare `ZM-HW-hardware` and a second fresh folder: the first `do` returns 5000 and the loop stops before publishing (the loop's error case / conditional stop on the error); afterwards no `.jsonl` file exists in that folder (or every file has 0 lines) |
Loops: a For loop of 10 with a shift register on the error and the two class wires, stopping on error
(conditional terminal from the error status); `do` → `publish` inside. The 5000 of the second run is read into the
indicator logic, not into `error out`. Description on the VI.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point; the port check (for T5 later).
2. Write the AIXML; generate by the direct route (project open with one member of each library opened through it);
   seeds swapped; cold state 1; `lvai_add_to_library` into `ZM-TST-tests.lvlib`; commit `test: pipeline without actors`.
3. `ops\run-checks.md` for `ZM-TST-pipeline` (loadability, returns, cold run). Fix only the test (max three rounds);
   a class VI at fault = stop with the reading.
4. Run every other `checks.json` test entry that has a VI, in list order (`ZM-TST-packages`, `ZM-TST-log`,
   `ZM-TST-hardware`, `ZM-TST-protocol`, `ZM-TST-udp`), one call each, and record each verdict in the evidence file.
   Any failure = stop and report the reading (do not fix anything else).
5. Cleanup per `ops\cleanup.md` on the one VI; `make_icons.py --check` + generate; `ops\icons.md` steps 3-8 for
   `ZM-TST-pipeline.vi` only (a no-template owner: `lvai_set_vi_icon` with its composite, read back 0 px). Commit.
6. Cold sweep of `src\tests\`; `check_membership.py`; `lv_save_version.py` (26); the test's links go only into
   `src\tests\`, `src\hardware\`, `src\protocol\` and `src\common\ZM-PC-packages\`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\`, `src\hardware\`, `src\protocol\` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `03` T6. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 50 lines), as your final message
1. `lvai_status` start/end; starts made; the port check. 2. T6 route. 3. The run-checks block for ALL six tests
(every indicator for T6, the verdict line for the others; rounds, fixes). 4. Cleanup and icons blocks (short).
5. Sweep, membership, versions, links. 6. Commits; `git status`. 7. Deviations / class VIs at fault /
NEEDS CLARIFICATION. 8. Side effects (files written under `output\`).
