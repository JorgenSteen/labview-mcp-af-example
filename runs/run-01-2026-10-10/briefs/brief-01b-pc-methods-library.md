# Brief 01b: package methods, pane bindings, the library, and the child overrides
Type: build (LabVIEW calls). Phase 01 step b of 4 (a classes done, b this, c test, d icons/cleanup/sweep).

## UPDATES (read first)
- Brief 01a built the three classes, five typedefs, bound fields and the listed accessors (report:
  `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-01a-pc-classes.md`; read its items 2, 3, 6
  and 8 for the exact accessor VI names, value-terminal names and anything it left open).
  <<MANAGER: traps from report 01a go here before launch>>
- Save version **26.0**. Project `src/Zuehlke MCP.lvproj` exists with the six virtual folders.
- User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself when it crashes or stops
  answering, per `<skill>\session\start.md` (`lv_windows.ps1`, `lvai_ensure_labview`, `lvai_status`), at most two
  starts in this step, each reported. Never answer a dialog; no retry loops.
- Traps: never probe a VI Server name with `lvai_validate_aixml` (crashed LabVIEW 2026 Q3 today); pass
  `regenerateHelper: true` once if the runner answers error 1059 on its own helper; `lvai_describe_project` lists no
  virtual folders (verify from the `.lvproj` text); `lvai_describe_class` may misreport a LabVIEW-Object parent
  (read the `.lvclass` XML).

## Goal
Add every method of `02` §7.1 to the three package classes, bind the typedef'd pane terminals, wrap the three classes
in `ZM-PC-packages.lvlib` placed under the project's `common` folder, then create the child overrides (`init` with
Call Parent plus the `setType` hook; `getDataAsJson` with its own body). Every VI gets a description. No test VI, no
icons, no Clean Up Diagram in this step (c and d). Nothing outside `src\common\ZM-PC-packages\` and the `.lvproj`.

## Paths (absolute, long form)
- Repo root (git): `C:\project\claude\LabVIEW-AFAItest` (harness folders read-only).
- Product folder: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project
  `...\src\Zuehlke MCP.lvproj`; classes in `...\src\common\ZM-PC-packages\ZM-PC-package\`, `...\ZM-PC-TP-test_package\`,
  `...\ZM-PC-EP-error_package\`; the library file to create: `...\src\common\ZM-PC-packages\ZM-PC-packages.lvlib`.
- AIXML sources you write: `...\zuehlke-mcp-af-test-results\proof\ZMP-01b\` (git-ignored; keep them, step d may need them).
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `knowledge\labview-mcp.md` ("Operating rules",
  "Evidence, git, build order", "Known gaps by tool": `lvai_add_class_method`, `lvai_add_to_library`,
  `lvai_bind_pane_typedef`, `lvai_generate_vi`, "LabVIEW scripting quirks"), `ops\override.md` (sections 1, 3 shape
  B-after, 4), `kit\README.md`, `kit\example_to_json.xml` (a measured JSON body; pilot names, class terminals as
  path stand-ins), `kit\lvai_create_override.xml`, `kit\pa_insert_series2.xml`, `kit\lvai_create_actor_library.xml`
  (proven VI Server spellings: `{LV.Application}` Invoke `Library.Create` → `{LV.Library}` Invoke `Save` with `Path`
  → `{LV.Library}` Invoke `AddItem` with `Name`, `Path`, `Type` = `"LVClass"` for a class, `"Folder"` for a folder).
- Conventions: `...\.labview\conventions\naming.md`, `layout.md`, `errors.md`, `hygiene.md` (rules below).
- Spec, the only source of names: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.1
  (lines 286-341), §3.1, §4; `01-requirements.md` R2, R6; `04-decisions.md` D1, D4, D10.

## Conventions written out
- `naming.method-case`: members camelCase after the prefix: `ZM-PC-getDataAsJson.vi`. `naming.override-names`: an
  override keeps the parent's file name, in the child's folder (`ZM-PC-TP-test_package\ZM-PC-init.vi`).
- `layout.scope`: private unless called from outside; protected for what children call; public as `02` says.
  `layout.flat-files`: every file flat in its class folder. `layout.class-folders`: `Methods` for methods, hooks and
  overrides (decided D35); `TypeDefs` for `.ctl`; `Accessors` exists already. No tool places a member in a class
  virtual folder: do what the tools allow, and list in the report every member not in its folder (not a failure).
- `layout.accessors-for-own-data`: members read and write fields through the accessors of 01a, never Unbundle/Bundle
  of the class wire. `errors.ignored-errors`: no unwired error out; an error ignored on purpose ends in `Clear Errors.vi`
  (none expected here). `hygiene.descriptions`: every VI's AIXML `description` says what it does (one or two sentences).
- JSON keys (decided D4): `timestamp`, `type`, `destination`, `data`; the data keys are the typedef element labels.

## What to build, in this order (build order: methods → pane bindings → library → overrides)
**1. `ZM-PC-package` methods** (`lvai_add_class_method`, AIXML written by you, class terminals as the tool needs):
| VI | kind, scope | terminals beyond class/error | body |
|---|---|---|---|
| `ZM-PC-getTimestampString.vi` | ST, pub | out `timestamp_iso` (String) | `Read timestamp` → `Format Date/Time String` with UTC format T, format `%Y-%m-%dT%H:%M:%S` → `.` + milliseconds (fractional part of the time stamp × 1000, floored, `%03d` zero-padded) + `Z`. Never `%u` and never `%<digit>u` (locale decimal sign). |
| `ZM-PC-getTypeName.vi` | ST, pub | out `type_name` (String) | `Read type` → the enum item's name (`Format Into String` `%s` on the enum) |
| `ZM-PC-getDestinationName.vi` | ST, pub | out `destination_name` (String) | `Read destination` → item name, same way |
| `ZM-PC-getHeader.vi` | ST, **prot** | out `header` (cluster `{timestamp, type, destination}` of Strings; pane bound to `ZM-PC-HEADER.ctl` in step 2) | bundles `getTimestampString`, `getTypeName`, `getDestinationName` |
| `ZM-PC-init.vi` | **DD**, pub | — | `Get Date/Time In Seconds` → `Write timestamp`; `Write type` = `Undefined` (the typedef enum's first value) |
| `ZM-PC-getDataAsJson.vi` | **DD**, pub | out `json` (String) | `getHeader` → `Flatten To JSON` (LabVIEW extensions off) → `{"timestamp":"…","type":"Undefined","destination":"Unknown"}` |
**2. Pane bindings** (`lvai_bind_pane_typedef`, project open and active if the tool needs it): `getHeader.header` ←
`ZM-PC-HEADER.ctl`. Prove from the file (typedef heap objects 0 → 1), not from `lvai_coercion_dots`.
**3. Child methods** (before the library, non-overrides only):
- `ZM-PC-TP-test_package`: `ZM-PC-TP-setType.vi` (HOOK, priv: `Write type` = `TestPackage`); `ZM-PC-TP-create.vi` (ST,
  pub; in `data` bound on the pane to `ZM-PC-TP-DATA.ctl`; out `package` typed `ZM-PC-TP-test_package`: default object
  → `ZM-PC-init` (dynamic call on the TP wire) → `Write data`). Note: `create` calls `init`, which the child overrides
  only in step 5; that is fine, the call is by name and dispatches at run time.
- `ZM-PC-EP-error_package`: `ZM-PC-EP-setType.vi` (HOOK, priv: `Write type` = `ErrorPackage`); `ZM-PC-EP-create.vi`
  (ST, pub; in `sender` String, in `error_to_report` = an error cluster used as DATA (type
  `cluster{bool.status,int32.code,string.source}`, not the error chain; its own pane slot); out `package` typed
  `ZM-PC-EP-error_package`: default object → `ZM-PC-init` → Unbundle `code`, `source` from `error_to_report` → Bundle
  `{sender, code, source}` → `Write data` → `Write destination` = `Root`).
Pane: `create`'s `data` input bound to `ZM-PC-TP-DATA.ctl` as in step 2.
**4. The library** `ZM-PC-packages.lvlib` holding the three classes (commit first). Route, first that works:
(a) `lvai_add_to_library` if its description says it creates a missing `.lvlib`; (b) a helper VI you derive from
`<skill>\kit\lvai_create_actor_library.xml` by removing its folder `AddItem`: `Library.Create` → `Save` to the library
path → `AddItem` (`Name` = `ZM-PC-package.lvclass` etc., `Path` = the `.lvclass`, `Type` = `LVClass`) three times →
`Save`; generated with `lvai_generate_vi` into the helpers folder and run with the project closed. Then, project
closed: the `.lvproj` must list the library once, under `common`: `python <skill>\kit\lvproj_move.py "<lvproj>"
"ZM-PC-packages.lvlib" common` (after the library item appears at top level; use `lvproj_drop.py` for the classes'
leftover top-level items). Reopen and close the project once (`lvai_open_file` + `lvai_close_active_project`) and
check that no dialog came up. Commit.
**5. Overrides** (after the library; `ops\override.md` sections 1 and 3):
- `ZM-PC-TP-test_package\ZM-PC-init.vi` and `ZM-PC-EP-error_package\ZM-PC-init.vi`: `kit\lvai_create_override.xml`
  with `parent method path` = `...\ZM-PC-package\ZM-PC-init.vi`, `vi name in memory` =
  `ZM-PC-packages.lvlib:ZM-PC-TP-test_package.lvclass:ZM-PC-init.vi` (EP likewise), project open and active. Commit.
  Then hook `ZM-PC-TP-setType.vi` (EP: `ZM-PC-EP-setType.vi`) **after Call Parent**, shape **B-after** with
  `kit\pa_insert_series2.xml` (`panel name A` = `<C> out`, `hook in A` = `<C> out`, `hook out A` = `<C> in`; block B
  `error out` / `error out` / `error in`; `<C>` = the class terminal prefix the override's pane shows). `pa_save_member`
  in a separate call. Commit per override.
- `ZM-PC-TP-test_package\ZM-PC-getDataAsJson.vi` and `ZM-PC-EP-error_package\ZM-PC-getDataAsJson.vi`: own body, no
  Call Parent: `lvai_add_class_method` with the SAME name and the SAME connector pane as the parent's (read it with
  `lvai_connector_pane` first), dynamic dispatch: `getHeader` (the parent's protected method, called on the child
  wire) → Unbundle its three strings; `Read data` → Bundle `{timestamp, type, destination, data}` (a bare cluster;
  `data` is the typedef cluster, so the JSON has the five keys / three keys) → `Flatten To JSON` → `json`. Model:
  `kit\example_to_json.xml`. **Unmeasured** whether `lvai_add_class_method` makes a dynamic-dispatch override of a
  plain-class method; prove it: `lvai_describe_class` shows the member dynamic, and a cold `lvai_exec_state` of both
  the child VI and the parent VI reads 1. If it cannot, stop and report with the exact answer.
- Scopes afterwards with `python <skill>\kit\set_scope.py` (project closed): `getHeader` protected, `setType` private,
  everything else public as the table says.
**6. Checks:** project closed; cold sweep of `src\common\ZM-PC-packages\` (`<skill>\ops\sweep.md`): every VI
state 1, control `0 7`, `check_membership.py` clean; `lv_save_version.py` on every file written (all 26); export
(`lvai_convert_vi_to_aixml`) each `init` override and confirm Call Parent → `setType` → outputs; a quick behaviour
proof with `lvai_run_vi_and_read_values` on `ZM-PC-TP-create.vi` with a data value, reading `package` is not
possible (class output), so instead generate a throwaway probe VI in the proof folder that calls `create` then
`getDataAsJson` and `getTypeName` and returns the strings; read `json` and `type_name`; delete nothing, the probe is
git-ignored. Expected: `type_name` = `TestPackage`, `json` has the four keys and the timestamp matches
`^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d\.\d{3}Z$`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- LabVIEW is running (checked by the main session). If it crashes or stops answering: UPDATES (max two starts).
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- A crash, a hung call, DeadlineExceeded, or a modal dialog: stop that chain; `lv_windows.ps1` (no LabVIEW call);
  never answer a LabVIEW dialog.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active. First make yours the
  active one (lvai_open_file with projectPath; check activeProjectPath). Pass projectPath to the close.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj: only the kit's byte-exact scripts, project closed. Write AIXML
  with the Write tool, never a shell heredoc.
- Absolute long-form paths everywhere. Touch nothing outside the product folder except helper VIs in
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`. Never push.
- Commit before every structural step (each method batch, the library, each override, each hook), by explicit paths,
  Conventional Commits `feat(pc): ...`, no attribution trailer.
- Save version 26.0: any file newer after a step = stop and report.
- Names only from `02` §7.1; nothing extra. Ambiguity → `NEEDS CLARIFICATION` block, that part left out.

## Report (max 80 lines), as your final message
1. `lvai_status` start/end; LabVIEW starts you made.
2. Per class: members made (name, kind, scope, dynamic?), from the `.lvclass` XML; which are in which virtual folder.
3. Pane bindings proven (how). 4. The library route that worked, the `.lvproj` lines for `common` and the library.
5. Overrides: the `ops\override.md` report block; the export evidence for Call Parent → setType.
6. The probe readings (`type_name`, `json`). 7. Sweep block; `check_membership.py`; `lv_save_version.py` lines.
8. Commits; `git status --short`. 9. Deviations, unmeasured steps you took, NEEDS CLARIFICATION blocks.
10. Side effects: files re-saved, project rewritten, helpers left, LabVIEW starts.
