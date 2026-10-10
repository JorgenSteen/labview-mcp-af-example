# Brief 02a: `ZM-CU-common_utilities.lvlib` with `ZM-CU-log.vi`, and `ZM-TST-log.vi` (T2) run until Pass
Type: build + test (LabVIEW calls). Phase 02 step a of 2 (b: cleanup, icons, sweep).

## UPDATES (read first)
- Phase 01 is done: `ZM-PC-packages.lvlib` (under `common`) and `ZM-TST-tests.lvlib` (under `tests`, holding
  `ZM-TST-packages.vi`) exist. Reports with the measured routes:
  `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-01b-pc-methods-library.md` (item 4, the
  library helper) and `report-01c-pc-test.md` (items 2 and 6: the test VI route, the library trap, Match Pattern).
  <<MANAGER: traps from reports 01d/01e go here before launch>>
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. Decided D38: class descriptions, `.ctl` membership and `Methods`/`TypeDefs` placement are the
  user's job in the IDE (no class in this phase, so nothing to list).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error 1059;
  `sweep_paths.py` needs `--out`; `Match Regular Expression` cannot be authored (XNode): use `Match Pattern`; a VI
  must be a project item (`lvproj_add_toplevel.py`, project closed) BEFORE the library helper adds it, then
  `lvproj_move.py` into the folder; `lvai_add_to_library` needs an existing `.lvlib` (use it to add
  `ZM-TST-log.vi` to the existing `ZM-TST-tests.lvlib`: it re-saves every member of that library, report it).

## Goal
`ZM-CU-log.vi` (a plain function VI, no class) in its own library `ZM-CU-common_utilities.lvlib`, placed under the
project's `common` folder; `ZM-TST-log.vi` (T2) added to `ZM-TST-tests.lvlib`, run cold until `Pass` true and
`error out` 0. No cleanup, no icons here (step b). Nothing outside `src\common\ZM-CU-common_utilities\`,
`src\tests\` and the `.lvproj`; nothing under `src\common\ZM-PC-packages\` may change.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results` (= `<project folder>` of the spec);
  project `...\src\Zuehlke MCP.lvproj`; new folder `...\src\common\ZM-CU-common_utilities\` holding
  `ZM-CU-common_utilities.lvlib` and `ZM-CU-log.vi`; test `...\src\tests\ZM-TST-log.vi`; test library
  `...\src\tests\ZM-TST-tests.lvlib`. The log file the VI writes: `...\zuehlke-mcp-af-test-results\output\ZM-error_log.txt`
  (`output\` is git-ignored and may be missing: the VI creates it).
- AIXML sources: `...\proof\ZMP-02a\`; evidence: `...\proof\runs\02a-checks.txt`; helpers
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\` (01b's `zm_create_package_library.xml` and 01c's
  `zm_create_test_library.xml` in `...\proof\ZMP-01b\` and `...\proof\ZMP-01c\` are the library helpers to derive from).
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\run-checks.md`, `ops\sweep.md`,
  `knowledge\labview-mcp.md` ("Operating rules", "Known gaps": `lvai_generate_vi`, `lvai_add_to_library`,
  `lvai_run_vi_and_read_values`), `kit\README.md`.
- Conventions: `...\.labview\conventions\naming.md` (`function-case`: `ZM-CU-log.vi`, `ZM-TST-log.vi` snake_case after
  the prefix), `errors.md` (`log-local`: this VI IS the local log; `ignored-errors`), `hygiene.md` (`descriptions`,
  `test-convention`, `test-library`), `checks.json` entry `ZM-TST-log`.
- Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.2 (lines 342-347), §5;
  `01-requirements.md` R7; `03-acceptance.md` T2 and its preamble; `04-decisions.md` D15.

## What to build
**`ZM-CU-log.vi`** (function, public, library member): in `message` (String), `error in`/`error out`. Behaviour
(`02` §7.2): appends `<ISO UTC timestamp>\t<message>\n` to `<project folder>\output\ZM-error_log.txt`. The project
folder comes from the VI's own path (`Current VI's Path` → `Strip Path` four times: the VI name,
`ZM-CU-common_utilities`, `common`, `src`) → `Build Path` `output` → `Create Folder` if missing (an "already
exists" error is cleared: a case on the error or `Clear Errors` on that code only) → `Build Path` `ZM-error_log.txt`
→ open or create → set file position to end → write the line → close. **It logs regardless of `error in`**: run the
body on a fresh error chain, then merge `error in` first and the body's error second into `error out` (the body's
error is not swallowed). Timestamp: the same recipe as `ZM-PC-getTimestampString` but built inside this VI (no call
into `ZM-PC`): `Get Date/Time In Seconds` → `Format Date/Time String` (UTC T, `%Y-%m-%dT%H:%M:%S`) + `.` + the
milliseconds as three zero-padded digits (fractional seconds × 1000, floored, `%03d`) + `Z`; never `%u`.
Description: "The project's local error log (errors.log-local, D15): appends <ISO UTC timestamp><tab><message> to
<project folder>/output/ZM-error_log.txt, creating the folder if missing; logs regardless of error in."
**The library** `ZM-CU-common_utilities.lvlib` holding that one VI (route: `lvproj_add_toplevel.py` for the VI,
then the library helper with `AddItem` Type `VI`, project open and active, then project closed `lvproj_drop.py` for a
loose entry and `lvproj_move.py "ZM-CU-common_utilities.lvlib" common`). The `.lvproj`: `common` holds both
libraries, once each.
**`ZM-TST-log.vi`** (T2), indicators exactly: `file_ok` (the log file exists after the calls), `order_ok` (its last
two lines end with the two markers, in order), `timestamp_ok` (both lines start with a timestamp matching the
anchored `Match Pattern` pattern from report 01c), `Pass` = AND, `error out`. Body: two `ZM-CU-log` calls with unique
markers (e.g. `T2-marker-A-` + a tick count, then `...-B-...`), then read the whole file, split into lines, take the
last two. Build it with the 01c route (stub + swap or direct), add it to `ZM-TST-tests.lvlib` with
`lvai_add_to_library` (existing library). Description on it. `checks.json` already has the entry.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point.
2. Generate `ZM-CU-log.vi` (`lvai_generate_vi`, `lvai_check_aixml` first), cold state 1; run it once with
   `lvai_run_vi_and_read_values` (`message` = `02a smoke`) and show the file's last line in the report. Commit
   `feat(cu): common error log ZM-CU-log.vi`.
3. The library as above; reopen/close once, no dialog; commit `feat(cu): library ZM-CU-common_utilities.lvlib under common`.
4. `ZM-TST-log.vi`, swaps, cold state 1, `lvai_add_to_library` into `ZM-TST-tests.lvlib`; commit `test(cu): ...`.
5. `ops\run-checks.md` steps 1-3, 5-6 for the entry `ZM-TST-log` (loadability, returns, run cold). Fix only the
   test when the test is wrong (max three rounds); `ZM-CU-log.vi` at fault = fix it (it is this phase's VI),
   regenerate, re-add to its library if membership is lost, commit, re-run. Evidence file written.
6. Cold sweep of `src\common\ZM-CU-common_utilities\` and `src\tests\` (`ops\sweep.md`); `check_membership.py`;
   `lv_save_version.py` on every file written (26); dependency check: `python <skill>\kit\lv_loadability.py --links`
   on the new library shows no link to any `ZM-` library or to `vi.lib\ActorFramework`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02`/`03`. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 50 lines), as your final message
1. `lvai_status` start/end; starts made. 2. `ZM-CU-log.vi`: route, the smoke line from the file. 3. Library route and
the `.lvproj` `common` lines. 4. T2: the run-checks block (every indicator, rounds, fixes). 5. Sweep block,
membership, versions, the dependency link summary. 6. Commits; `git status`. 7. Deviations / NEEDS CLARIFICATION.
8. Side effects (files re-saved by `lvai_add_to_library`, helpers, LabVIEW starts).
