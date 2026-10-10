# Brief 01a: create the three package classes with their typedefs, fields and accessors
Type: build (LabVIEW calls). Phase 01 step a of 4 (a classes, b methods and library, c test, d icons/cleanup/sweep).

## UPDATES (read first)
- The product folder has `.labview/` (brief 00a) and the empty project `src/Zuehlke MCP.lvproj` (brief 00b) with the
  virtual folders `common`, `hardware`, `protocol`, `actors`, `tests`, `receiver`. Nothing else exists in `src/`.
- Save version measured from the project file: **26.0** (LabVIEW 2026 Q3 32-bit). Every file you write must read 26
  with `python <skill>\kit\lv_save_version.py <file>`.
- User go-ahead (2026-10-10 15:22): "You may restart LabVIEW when needed. close anything you are using labview all by
  yourself for the whole session, not restrictions", extended 15:30: "Agents can restart labview themselves too, no need
  to ask me". Scope: this whole session. So: if LabVIEW crashes or stops answering, follow
  `<skill>\session\start.md` yourself (`lv_windows.ps1` first, then `lvai_ensure_labview`, then `lvai_status`), at most
  two starts in this step, and report each start. Never answer a LabVIEW dialog; no retry loops.
- Trap (report-00b, 2026-10-10): **never probe a VI Server name with `lvai_validate_aixml`**; an invented method on a
  known class crashed LabVIEW 2026 Q3. Take spellings from the plugin's references or NI's shipped files only.
- Trap: the runner's own helper `lvai_run_and_read_typed.vi` once was a 14-byte stub (error 1059): pass
  `regenerateHelper: true` once when that happens.

## Goal
Create `ZM-PC-package.lvclass` (parent LabVIEW Object) and its two children `ZM-PC-TP-test_package.lvclass` and
`ZM-PC-EP-error_package.lvclass`, each in its own flat folder, with the five typedefs, the fields bound to their
typedefs, and ONLY the accessors listed below (static, with the scopes given). No methods, no library, no test, no
icons in this step (b, c, d do that). **No test hand-off:** this project uses plain test VIs, no Caraya, LUnit or
VI Tester; do not launch any test agent.

## Paths (absolute, long form)
- Repo root (git): `C:\project\claude\LabVIEW-AFAItest`. Read-only: `requirements\`, `orchestration\`, `runs\`.
- Product folder: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results` (= `<repo>` for the skill).
- Project: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\src\Zuehlke MCP.lvproj`.
- Target folders (create them): `...\src\common\ZM-PC-packages\ZM-PC-package\`,
  `...\src\common\ZM-PC-packages\ZM-PC-TP-test_package\`, `...\src\common\ZM-PC-packages\ZM-PC-EP-error_package\`.
- Skill: `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `knowledge\labview-mcp.md` ("Operating rules",
  "Save version", "Known gaps by tool": `lvai_create_class`, `lvai_create_typedef`, `lvai_bind_class_fields`,
  `lvai_create_accessors`, `lvai_add_class_field`), `ops\class-field.md` (route A and "New classes"), `kit\README.md`.
- Conventions: `...\zuehlke-mcp-af-test-results\.labview\conventions\naming.md`, `layout.md`, `hygiene.md` (rules
  written out below; the files are the source if anything here is unclear).
- Spec (read-only, the only source of names): `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md`
  §7.1 (lines 286-340).
- Helpers: `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`. Proof: `...\zuehlke-mcp-af-test-results\proof\ZMP-01a\`.

## What to build (every name exactly as written; `02` §7.1 is the source)
**Typedefs** (`naming.typedef-case`; file flat in the class folder, `layout.flat-files`, `layout.typedef-placement`):
- `ZM-PC-package\ZM-PC-PACKAGE_TYPE.ctl`: enum U16 `{Undefined, TestPackage, ErrorPackage}` (0, 1, 2).
- `ZM-PC-package\ZM-PC-DESTINATION.ctl`: enum U16 `{Unknown, Root, Hardware, Communication}` (0..3).
- `ZM-PC-package\ZM-PC-HEADER.ctl`: cluster `{timestamp: String, type: String, destination: String}` (element labels
  exactly these; they are JSON keys, decided D4). Not a field; used by methods in step b.
- `ZM-PC-TP-test_package\ZM-PC-TP-DATA.ctl`: cluster `{temperature_c: DBL, sample_index: I32, duty_percent: U8,
  sensor_ok: Boolean, status: String}` in this order.
- `ZM-PC-EP-error_package\ZM-PC-EP-DATA.ctl`: cluster `{sender: String, code: I32, source: String}`.
Measured spellings for `lvai_create_typedef`: `uint16{Undefined,TestPackage,ErrorPackage}`,
`cluster{string.timestamp,string.type,string.destination}`, and the plain types `string, timestamp, path, bool,
double, single, int8..uint64` (so `cluster{double.temperature_c,int32.sample_index,uint8.duty_percent,bool.sensor_ok,string.status}`).
Pass no `projectPath` (the project stays closed). `verifiedFromFile` must say typedef.

**Fields** (`naming.field-names`, camelCase, no prefix); bind BEFORE any accessor exists (an accessor made earlier keeps
the bare type for ever):
- `ZM-PC-package`: `timestamp` (Time Stamp), `type` (bound to `ZM-PC-PACKAGE_TYPE.ctl`), `destination` (bound to
  `ZM-PC-DESTINATION.ctl`; default `Unknown` = the enum's first item, nothing to set).
- `ZM-PC-TP-test_package` (parent `ZM-PC-package`): `data` (bound to `ZM-PC-TP-DATA.ctl`).
- `ZM-PC-EP-error_package` (parent `ZM-PC-package`): `data` (bound to `ZM-PC-EP-DATA.ctl`).
`lvai_create_class` with `typedefFieldsJson` binds at creation; if you bind afterwards, project OPEN and ACTIVE for
the bind, `ok` gated on `boundInFile`, then close. Prove every binding with `lvai_describe_class`.

**Accessors** (`layout.accessors-on-demand`: exactly these, nothing else; `naming.accessor-names`: the wizard's
`Read <field>.vi` / `Write <field>.vi`; all **static** (a private dynamic-dispatch VI is broken); scope per
`layout.scope`, set with `python <skill>\kit\set_scope.py <.lvclass> <scope> "<vi>"` with the project CLOSED;
`virtualFolderName` = `Accessors`):
| class | accessor | scope |
|---|---|---|
| ZM-PC-package | Read timestamp, Write timestamp | private |
| ZM-PC-package | Read type | public |
| ZM-PC-package | Write type | protected |
| ZM-PC-package | Read destination, Write destination | public |
| ZM-PC-TP-test_package | Read data | public |
| ZM-PC-TP-test_package | Write data | private |
| ZM-PC-EP-error_package | Read data | public |
| ZM-PC-EP-error_package | Write data | private |
`lvai_create_accessors` one slice per field (`fromField` = the field index, `fieldCount` 1, `budgetSeconds` 1,
`dynamicDispatch` false, `accessUi` Read or Write); if the wizard makes both directions where one is listed, remove the
unlisted one with `python <skill>\kit\remove_members.py <.lvclass> "<vi>" --delete-files` (project closed). The value
terminal of a typedef accessor is named after the `.ctl`: that is expected.

**Descriptions** (`hygiene.descriptions`), on each class (the VI descriptions of accessors are the wizard's):
- ZM-PC-package: "Parent of every package. Carries a timestamp and a type (both written by init) and a destination
  (set by the creator). getDataAsJson produces the JSON; nothing outside the package looks inside its data."
- ZM-PC-TP-test_package: "A measurement package: the five-field data cluster ZM-PC-TP-DATA (temperature_c,
  sample_index, duty_percent, sensor_ok, status). init calls the parent, then sets type TestPackage."
- ZM-PC-EP-error_package: "An error travelling upward as a package: data = sender, code, source. Created by
  ZM-PC-EP-create with destination Root. init calls the parent, then sets type ErrorPackage."

## Route
Follow `<skill>\ops\class-field.md` route A per class (typedef → class with bound fields → accessors), class by class
in the order parent, TP, EP; commit before each structural step and after each class, by explicit paths, from the
repo root: `git add "zuehlke-mcp-af-test-results/src/common/ZM-PC-packages/<class folder>" "zuehlke-mcp-af-test-results/src/Zuehlke MCP.lvproj"`,
message `feat(pc): <what>` (Conventional Commits, NO attribution trailer). Project-file hygiene: a class created with
a parent adds the PARENT as a top-level `.lvproj` item; after each child, with the project closed, run
`python <skill>\kit\lvproj_drop.py` to remove duplicate top-level entries so each class is listed once (under
`My Computer`; the `common` folder placement happens in step b with the library). Check the `.lvproj` text.
After the last class: cold sweep of `src\common\ZM-PC-packages\` per `<skill>\ops\sweep.md` (every accessor
state 1, control `0 7`, `check_membership.py` clean), `lv_save_version.py` on every file written (all 26), final commit.

## Hard rules
Operating rules: `C:\Users\jorgen.steen\.claude\skills\labview\knowledge\labview-mcp.md`, "Operating rules".
- LabVIEW is running (checked by the main session; PID 14040, port 59552). If it crashes or stops answering, you may
  start it again per UPDATES (max two starts), then continue; never answer a dialog; no retry loops.
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads. Space
  `lvai_create_class` calls apart (back-to-back calls caused DeadlineExceeded).
- A crash, a hung call, DeadlineExceeded, or a modal dialog: stop that call chain at once; check with
  `<skill>\kit\lv_windows.ps1` (no LabVIEW call). Never answer a LabVIEW dialog.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active. First make yours the
  active one: lvai_open_file with projectPath = the project above (check activeProjectPath). If another project would
  be closed, stop and report. Pass projectPath to the close anyway.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj: only the kit's byte-exact scripts, with the project closed.
- Absolute long-form paths everywhere: no %TEMP%, no 8.3 short names.
- Touch nothing outside `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\` except helper VIs in the
  helpers folder. Never write into LabVIEW's installation. Never push.
- Commit before every structural step, by explicit paths; Conventional Commits; no attribution trailer.
- Save version 26.0: a file reading anything else after a step = stop and report.
- Names: only those above and in `02` §7.1. Nothing extra (no extra accessor, no extra field, no extra typedef). If
  something is ambiguous, return a `NEEDS CLARIFICATION` block and leave that part out.

## Report (max 60 lines), as your final message
1. `lvai_status` at start and end (port, up seconds); LabVIEW starts you made (or "none").
2. Per class: the tool calls in order with their answers in a few words; `lvai_describe_class` readings (fields, bound
   typedefs, parent); the accessors that exist with scope and dispatch (from the `.lvclass` XML).
3. The five `.ctl` files: path, `verifiedFromFile`, and whether each is a member of its class (if no tool makes a
   `.ctl` a class member, say so: it is a known gap, not your failure).
4. Sweep report block from `ops\sweep.md`; `check_membership.py` output.
5. `lv_save_version.py` output for every file written.
6. The `.lvproj` items under `My Computer` after your last close (quote the lines).
7. Commits (hashes and messages); `git status --short` at the end.
8. Deviations and anything unmeasured you had to decide; NEEDS CLARIFICATION blocks if any.
9. Side effects: files re-saved, project files rewritten, helper VIs left, LabVIEW starts.
