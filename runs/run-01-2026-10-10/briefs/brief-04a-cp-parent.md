# Brief 04a: `ZM-CP-communication_protocol` class, its one accessor, `init`/`publish`/`close`, and its library
Type: build (LabVIEW calls). Phase 04 step a of 3 (b: the file logger child, its library and T4; c: cleanup, icons, sweep).

## UPDATES (read first)
- This step mirrors phase 03a (the hardware parent) exactly, with the protocol names. Read
  `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-03a-hw-parent.md` FIRST and repeat its
  measured route (class, accessor, three dynamic methods, the 5000 placeholder with its label, the library helper,
  `lvproj_drop.py`/`lvproj_move.py`), then `report-03c-hw-cleanup-icons-sweep.md` for the state of the tree.
- Phase 03 closed 22:13 (reports 03a-03c). Facts that carry over: the free label is `<FreeLabel comment="#customerror
  5000" .../>` in AIXML (element `FreeLabel`, attribute `comment`; it survives cleanup and reads back in the export);
  `lvai_add_class_method` converts with the project closed, so a class constant or a member of another library goes in
  as a path stand-in / stub and is swapped afterwards with `lvai_swap_subvis` (`editsJson` for stubs, `constantsJson`
  for class constants); the retype of a class-typed pane terminal uses the tool's object form (03a, `package` →
  `ZM-PC-package.lvclass`); the library helper `zm_create_class_library.vi` is cached in the helpers folder (inputs
  library path, class path 1, class item name 1); after its close the library sits at top level AND a stray class
  item remains: `lvproj_drop.py` then `lvproj_move.py`, project closed; `lvai_create_class` strips the `.lvproj` BOM
  (LabVIEW's next close restores it); a pure function member with no class terminal (not needed here) goes through
  the cached `lvai_add_one_to_library.vi` helper on the `.lvclass`. The parent's pane as measured on `ZM-HW-do.vi`:
  class in 11, error in 8, class out 3, error out 0, the extra terminal on 2; use the same layout for `publish`'s
  `package` input (slot 2 is an INPUT slot? no: on 4815 slot 2 is on the output side; put `package` on an input
  slot such as 10 and report the conIdx you used; the children copy the pane with `lvai_connector_pane`).
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions, `.ctl` membership and `Methods` placement are the user's job in
  the IDE: do not ask, do not hand-edit, list them. D39: icons without a prompt (step c).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; the library helper runs with the project OPEN AND ACTIVE, then
  `lvproj_drop.py`/`lvproj_move.py` with it closed; the direct Call route for members of another library (project
  open with one member of that library opened through it).

## Goal
The protocol parent: `ZM-CP-communication_protocol.lvclass` with the field `opened` (Boolean), the accessor `Write
opened` (private, static; no `Read`), the dynamic-dispatch methods `ZM-CP-init.vi` (`Write opened` = T),
`ZM-CP-publish.vi` (placeholder: error 5000 with `#customerror 5000`; in `package` typed `ZM-PC-package`),
`ZM-CP-close.vi` (`Write opened` = F), wrapped in `ZM-CP-communication_protocol.lvlib` under the project's
`protocol` folder, depending on `ZM-PC-packages.lvlib` only. No child, no test, no icons here.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\` (class and VIs
  flat); library file `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol.lvlib`.
- Package class for the `package` input: `...\src\common\ZM-PC-packages\ZM-PC-package\ZM-PC-package.lvclass`
  (qualified `ZM-PC-packages.lvlib:ZM-PC-package.lvclass`).
- AIXML sources `...\proof\ZMP-04a\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md`, `ops\sweep.md`,
  `knowledge\labview-mcp.md` ("Operating rules", "Evidence, git, build order", "Known gaps"), `kit\README.md`.
- Conventions: `...\.labview\conventions\naming.md`, `layout.md`, `errors.md` (`custom-error-codes`, D18),
  `hygiene.md`. Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §3.1 (lines 125-140),
  §7.6 (lines 377-387), §1; `01-requirements.md` R4, R7; `04-decisions.md` D16, D18;
  `...\zuehlke-mcp-af-test-results\docs\error-codes.md` (`ZM-CP-publish.vi` is already listed as a raising VI).

## What to build, in this order (class → accessor → methods → library), names exactly as written
1. **Class** `ZM-CP-communication_protocol.lvclass`, parent LabVIEW Object, one plain field `bool.opened`. Commit
   `feat(cp): class ZM-CP-communication_protocol with field opened`.
2. **Accessor** `Write opened.vi` only (static, private via `set_scope.py`, folder `Accessors`; remove a `Read opened.vi`
   if the wizard makes one). Commit.
3. **Methods** (`lvai_add_class_method`, dynamic dispatch, public):
   | VI | pane beyond class/error | body |
   |---|---|---|
   | `ZM-CP-init.vi` | — | `Write opened` = T |
   | `ZM-CP-close.vi` | — | `Write opened` = F |
   | `ZM-CP-publish.vi` | in `package` typed `ZM-PC-package` (required input, on an input slot of the 4x2x2x4 pane; the child overrides keep this pane) | the package input is unused by the placeholder (wire it to nothing is NOT allowed to leave a loose pane terminal: an unwired INPUT control is fine); error: `Bundle By Name` onto an error-cluster constant (`status` T, `code` 5000, `source` = `ZM-CP-publish.vi: must be overridden by a child class`) → `Merge Errors` with `error in` first → `error out`; the free label `#customerror 5000` beside the Bundle, authored the way 03a did (or its documented fallback) |
   Descriptions (`publish`: "Placeholder: returns error 5000 (#customerror 5000). A child class must override it
   and publish the package it is given."). Class description text for the user (D38): "Parent of every
   communication protocol. init and close do real work on the opened flag; publish is a placeholder that returns
   error 5000 and must be overridden by a child. Never looks inside a package: it asks getDataAsJson and getTypeName."
   Prove each: cold `lvai_exec_state` 1; run `ZM-CP-publish.vi` cold through a throwaway probe VI in the proof
   folder that feeds a default `ZM-PC-package` and quote `error out` (code 5000, the source text); or run it directly
   if the runner accepts a class input unwired (report which). Commit per batch `feat(cp): ...`.
4. **Library** `ZM-CP-communication_protocol.lvlib` holding the class (the cached library helper, project open and
   active; then closed: `lvproj_drop.py` strays, `lvproj_move.py "ZM-CP-communication_protocol.lvlib" protocol`;
   reopen/close once, no dialog; the `.lvproj` `protocol` folder lists it once). Commit.
5. **Checks:** cold sweep of `src\protocol\` (`ops\sweep.md`); `check_membership.py`; `lv_save_version.py` on every
   file written (26); links of the four VIs only into this class and `src\common\ZM-PC-packages\`; none into
   `vi.lib\ActorFramework`, `ZM-CU`, `ZM-HW`, `ZM-TST`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\`, `src\hardware\` or `src\tests\` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.6; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 50 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Class: describe_class; the accessor; members with scope/dynamic from
the XML. 3. `publish`: the label route, the cold `error out`. 4. Library route; the `.lvproj` `protocol` lines.
5. Sweep, membership, versions, links. 6. Commits; `git status`. 7. Deviations / NEEDS CLARIFICATION; items for the
user in the IDE. 8. Side effects.
