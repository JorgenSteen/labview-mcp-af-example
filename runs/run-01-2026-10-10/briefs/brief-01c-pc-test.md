# Brief 01c: the test library and `ZM-TST-packages.vi` (T1), run until Pass
Type: build + test (LabVIEW calls). Phase 01 step c of 4 (a classes, b methods and library done; c this; d icons/cleanup/sweep).

## UPDATES (read first)
- Reports to read: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-01a-pc-classes.md` and
  `report-01b-pc-methods-library.md` (member names, terminal names, the library route that worked, open items).
  <<MANAGER: traps from report 01b go here before launch>>
- Save version **26.0**. Project `src/Zuehlke MCP.lvproj` has the six virtual folders; `ZM-PC-packages.lvlib` sits
  under `common`.
- User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself when it crashes or stops
  answering, per `<skill>\session\start.md`, at most two starts in this step, each reported. Never answer a dialog.
- Decided by the user (2026-10-10 16:00, D38): class descriptions, `.ctl` class membership and `Methods`/`TypeDefs`
  folder placement are the user's job in the IDE; do not ask, do not hand-edit; list what you could not place.
- Traps: never probe a VI Server name with `lvai_validate_aixml` (crashed LabVIEW today); `regenerateHelper: true`
  once if the runner answers 1059 on its own helper; a VI that calls class members converts best with the project
  open and one member opened through it (labview-mcp 1.8.5+ does this inside `lvai_generate_vi`; if it refuses a
  class wire, use `lvai_placeholder_subvi` stubs and `lvai_swap_subvis`); a test VI's panel comes back whole from
  the runner, so keep the panel small (no arrays of JSON, no big strings beyond the few the checks need).

## Goal
Create the test library `ZM-TST-tests.lvlib` in `src\tests\` with its first VI `ZM-TST-packages.vi` (T1 of
`03-acceptance.md` §1), add both to the project under the `tests` folder, run the test cold through `checks.json`
(`<skill>\ops\run-checks.md`) and end with `Pass` true and `error out` code 0. Fix the TEST when a check is wrong;
when a check fails because a PACKAGE VI misbehaves, do not patch the package VI yourself: report the exact reading
as a `NEEDS CLARIFICATION`/deviation (the manager routes the fix). No icons, no Clean Up Diagram here (step d).

## Paths (absolute, long form)
- Repo root (git): `C:\project\claude\LabVIEW-AFAItest` (harness read-only). Product folder:
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Test library: `...\src\tests\ZM-TST-tests.lvlib`; test VI: `...\src\tests\ZM-TST-packages.vi` (flat in `src\tests\`).
- Package classes: `...\src\common\ZM-PC-packages\ZM-PC-packages.lvlib` and its three class folders.
- AIXML sources: `...\zuehlke-mcp-af-test-results\proof\ZMP-01c\` (git-ignored). Evidence file (run-checks):
  `...\zuehlke-mcp-af-test-results\proof\runs\01c-checks.txt`. Helpers: `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\run-checks.md`, `knowledge\labview-mcp.md`
  ("Operating rules", "Known gaps": `lvai_generate_vi`, `lvai_run_vi_and_read_values`, `lvai_add_to_library`),
  `kit\README.md`, `kit\lvai_create_actor_library.xml` (library creation spellings; 01b's report says what worked).
- `checks.json`: `...\zuehlke-mcp-af-test-results\.labview\checks.json`, entry `ZM-TST-packages` (path, `read_only`
  `["Pass", "error out"]`, project closed). Conventions: `...\.labview\conventions\hygiene.md` (`test-convention`,
  `test-library`), `naming.md` (`function-case`: `ZM-TST-<name>.vi` snake_case), `errors.md` (`ignored-errors`).
- Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\03-acceptance.md` §1 T1 (the checks, verbatim below) and
  the preamble (JSON compared after unflattening, timestamp pattern); `02-specification.md` §7.1 (the API).

## The test (T1), every indicator named exactly so; `Pass` = AND of all ten
| indicator | proves |
|---|---|
| `dispatch_ok` | a TP object on a `ZM-PC-package` wire: `getDataAsJson` runs the child's override (the JSON has a `data` key) |
| `call_parent_ok` | after `ZM-PC-TP-create` the type is `TestPackage` (`getTypeName`) and the JSON timestamp matches the pattern |
| `tp_json_ok` | round trip: the TP JSON unflattens (`Unflatten From JSON`) into `{timestamp, type, destination, data}` and `data` equals the cluster given to `create` |
| `type_name_ok` | `getTypeName` gives `TestPackage`, `ErrorPackage`, `Undefined` for TP, EP and a bare parent (after `init`) |
| `ep_json_ok` | round trip: `ZM-PC-EP-create("HWM", error 5000 "x")` → JSON unflattens to sender `HWM`, code 5000, source `x` |
| `parent_json_ok` | a bare parent after `init`: JSON has `timestamp`, `type`, `destination` and no `data` |
| `timestamp_ok` | `getTimestampString` matches `^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d\.\d{3}Z$` (`Match Regular Expression`; a decimal comma fails) |
| `destination_default_ok` | a new TP reads `Unknown` (`getDestinationName`) |
| `destination_roundtrip_ok` | `Write destination` → `Read destination` for all four values (compare enums) |
| `ep_root_ok` | `EP-create` gives destination `Root` |
| `Pass` | AND of all; plus `error out` |
Use typedef-shaped clusters for `Unflatten From JSON` (a bare cluster with the same element labels as
`ZM-PC-HEADER.ctl` plus a `data` cluster shaped like `ZM-PC-TP-DATA.ctl` / `ZM-PC-EP-DATA.ctl`; AIXML cannot reference
a `.ctl`). Compare `data` with `Equal?` on the clusters. Values for the TP data: `temperature_c` 23.5, `sample_index`
42, `duty_percent` 50, `sensor_ok` true, `status` `ok`. Every error chain ends in `error out`; nothing unwired.

## Route
1. `lvai_status`; `git status --short` (expect only manager files under `runs/`); project closed.
2. Commit point. Write the test's AIXML (description: "T1: round-trip test of the package classes; Pass = AND of the
   ten checks"), generate it with `lvai_generate_vi` into `src\tests\` (project open with one `ZM-PC` member opened
   through it if class wires need that; close after). Cold `lvai_exec_state` = 1.
3. Create `ZM-TST-tests.lvlib` holding `ZM-TST-packages.vi` the way 01b created `ZM-PC-packages.lvlib` (its report
   names the route); `Type` for a VI item is `VI`. Project closed: the `.lvproj` lists the library once under
   `tests` (`python <skill>\kit\lvproj_move.py "<lvproj>" "ZM-TST-tests.lvlib" tests`; drop a loose test-VI entry
   with `lvproj_drop.py` if one appears). Reopen and close the project once; no dialog. Commit `test(pc): ...`.
4. Run per `ops\run-checks.md` steps 1-3 and 5-6 for the entry `ZM-TST-packages` only: loadability
   (`lv_loadability.py`), `vi_nets.py` (it must return by itself), then `lvai_run_vi_and_read_values` cold with
   `includeRawXml` false. Read `Pass`, `error out`, and every `*_ok`.
5. If `Pass` is false: name the failing indicator(s); fix the test when the test is wrong (regenerate, re-add to the
   library if membership was lost, `check_membership.py`), re-run; at most three rounds. A package VI at fault =
   stop with the reading. Write the evidence file; commit it with the test (`test(pc): T1 ZM-TST-packages passes`).
6. Cold sweep of `src\tests\` and `src\common\ZM-PC-packages\` (`ops\sweep.md`), `check_membership.py`,
   `lv_save_version.py` on every file written (26).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first
  (check activeProjectPath), pass projectPath to the close.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj: only the kit's byte-exact scripts, project closed. AIXML with
  the Write tool, never a heredoc. Absolute long-form paths. Nothing outside the product folder except helpers.
- Never change a VI under `src\common\` in this step. Commit before every structural step, by explicit paths,
  Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop and report.
- Names only from `02`/`03`: the VI `ZM-TST-packages.vi`, the library `ZM-TST-tests.lvlib`, the indicators above.

## Report (max 50 lines), as your final message
1. `lvai_status` start/end; LabVIEW starts made. 2. Generation route (stubs or direct), the library route, the
`.lvproj` lines for `tests`. 3. The run-checks report block: `Pass`, `error out`, every `*_ok` reading, rounds
needed and what each fix was. 4. Sweep block, `check_membership.py`, `lv_save_version.py`. 5. Commits; `git status`.
6. Deviations / package VIs at fault (exact readings) / NEEDS CLARIFICATION. 7. Side effects.
