# Brief 03a: `ZM-HW-hardware` class, its one accessor, `init`/`do`/`close`, and `ZM-HW-hardware.lvlib`
Type: build (LabVIEW calls). Phase 03 step a of 3 (b: the SIM child, its library, the `do` override and T3; c: cleanup, icons, sweep).

## UPDATES (read first)
- Phases 01 and 02 are done: `ZM-PC-packages.lvlib` and `ZM-CU-common_utilities.lvlib` under `common`,
  `ZM-TST-tests.lvlib` under `tests`. Measured routes on this station, read them: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-01a-pc-classes.md`
  (class + typedef + accessor route), `report-01b-pc-methods-library.md` (methods, pane binding, the library helper
  `proof\ZMP-01b\zm_create_package_library.xml`, trap T1), `report-02a-cu-log-test.md`.
- Phase 02 closed 18:19 (reports 02a, 02b): no new traps for a class step. The direct Call route (project open
  with one member of the called library opened through it, then `lvai_generate_vi` with
  `<Call target="<Lib>.lvlib:<VI>.vi">`) works on this station and replaces stubs + swaps (report-02a, item 4):
  use it for `ZM-HW-do.vi`'s `ZM-PC-package` constant if `lvai_add_class_method` accepts a class constant of
  another library that way; else the 01c stub route. `Clear Errors.vi` terminal names are not derivable in AIXML;
  not needed here (Merge Errors only). The library helper VI `zm_create_package_library.vi` is cached in the
  helpers folder with generic inputs (library path, class path, class item name): reuse it.
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. Decided D38: class descriptions, `.ctl` membership and `Methods` folder placement are the
  user's job in the IDE: do not ask, do not hand-edit, list them. D39: icons without a prompt (step c).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; a class created with `parentClassPath` may or may not add a stray top-level
  `.lvproj` item (check the text, `lvproj_drop.py` project closed); the library helper runs with the project OPEN
  AND ACTIVE and the close lists the library at top level: `lvproj_move.py` into `hardware` (project closed).
- **Spec rule that wins over the phase card:** `02` §3.1 says the SIM child does NOT override `init` and `close`
  (only `do`); the card's note saying otherwise is a known inconsistency (manager finding). Not your concern in
  this step, but do not design the parent around a child override of `init`/`close`.

## Goal
The hardware parent: `ZM-HW-hardware.lvclass` with the field `initialized`, the accessor `Write initialized`
(private, static; no `Read`), the three dynamic-dispatch methods `ZM-HW-init.vi`, `ZM-HW-do.vi` (placeholder,
error 5000 with the free label `#customerror 5000`), `ZM-HW-close.vi`, wrapped in `ZM-HW-hardware.lvlib` under the
project's `hardware` folder, depending on `ZM-PC-packages.lvlib` only. No child, no test, no icons here.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\hardware\ZM-HW-hardware\ZM-HW-hardware\` holding `ZM-HW-hardware.lvclass` and the
  VIs (flat); library file `...\src\hardware\ZM-HW-hardware\ZM-HW-hardware.lvlib`.
- The package class the `do` output uses: `...\src\common\ZM-PC-packages\ZM-PC-package\ZM-PC-package.lvclass`
  (library `ZM-PC-packages.lvlib`; qualified name `ZM-PC-packages.lvlib:ZM-PC-package.lvclass`).
- AIXML sources `...\proof\ZMP-03a\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md` (route A, "New classes"),
  `ops\sweep.md`, `knowledge\labview-mcp.md` ("Operating rules", "Evidence, git, build order", "Known gaps":
  `lvai_create_class`, `lvai_create_accessors`, `lvai_add_class_method`, `lvai_generate_vi`, "LabVIEW scripting
  quirks"), `kit\README.md`.
- Conventions: `...\.labview\conventions\naming.md`, `layout.md`, `errors.md` (`custom-error-codes`, decided D18;
  `ignored-errors`), `hygiene.md` (`descriptions`). Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md`
  §3.1 (lines 125-140, the error-5000 recipe), §7.4 (lines 357-367), §1 (dependency rule); `01-requirements.md` R3,
  R7; `04-decisions.md` D16, D18; `...\zuehlke-mcp-af-test-results\docs\error-codes.md` (code 5000 is registered
  already; `ZM-HW-do.vi` is listed as a raising VI).

## Conventions written out
- `naming.class-library-names`: `ZM-HW-hardware.lvclass`, `ZM-HW-hardware.lvlib`; `naming.method-case`: `ZM-HW-init.vi`,
  `ZM-HW-do.vi`, `ZM-HW-close.vi`; `naming.field-names`: `initialized`; `naming.accessor-names`: `Write initialized.vi`.
- `layout.scope`: the three methods public (children override them and the HWM calls them), the accessor private.
  `layout.accessors-on-demand`: ONLY `Write initialized` (nothing reads the flag), static.
  `layout.accessors-for-own-data`: `init`/`close` write through the accessor. `layout.flat-files`.
- `errors.custom-error-codes` (D18) and `02` §3.1: error 5000 is built by `Bundle By Name` onto an error-cluster
  constant: `status` T, `code` 5000, `source` = `ZM-HW-do.vi: must be overridden by a child class`; a free diagram
  label (a text decoration / comment) `#customerror 5000` beside that node. `errors.ignored-errors`: nothing unwired.
- `hygiene.descriptions`: every VI's AIXML `description`. Class description text for the user (D38): "Parent of
  every hardware object. init and close do real work on the initialized flag (close is where real hardware is put
  into a safe state); do is a placeholder that returns error 5000 and must be overridden by a child."

## What to build, in this order (build order: class → accessor → methods → library)
1. **Class** `ZM-HW-hardware.lvclass`, parent LabVIEW Object, one plain field `bool.initialized`
   (`lvai_create_class` as in 01a, `projectPath` = the project; no typedef). `lvai_describe_class` must show the
   field. Commit `feat(hw): class ZM-HW-hardware with field initialized`.
2. **Accessor**: `lvai_create_accessors` `fromField` 0, `fieldCount` 1, `accessUi` Write, `dynamicDispatch` false,
   `virtualFolderName` `Accessors`; if the wizard also makes `Read initialized.vi`, remove it with
   `python <skill>\kit\remove_members.py <.lvclass> "Read initialized.vi" --delete-files` (project closed). Scope
   private with `set_scope.py` (project closed). Commit.
3. **Methods** (`lvai_add_class_method`, dynamic dispatch, the class in/out and error in/out on the pane; the
   terminal names of `Write initialized` read with `lvai_vi_terminals`):
   | VI | body |
   |---|---|
   | `ZM-HW-init.vi` | `Write initialized` = T |
   | `ZM-HW-close.vi` | `Write initialized` = F |
   | `ZM-HW-do.vi` | out `package` typed `ZM-PC-package` (a `ZM-PC-package.lvclass` constant, default object, straight to the indicator; the class terminal on the pane is the real class, so the VI calls into `ZM-PC-packages.lvlib`: generate with the project open and one `ZM-PC` member opened through it, or stub + `lvai_swap_subvis`/constant swap as 01c did); the error: `Bundle By Name` onto an error-cluster constant (`status` T, `code` 5000, `source` the text above) → `Merge Errors` with `error in` first (an incoming error wins) → `error out`; the free label `#customerror 5000` beside the Bundle. **Unmeasured:** whether AIXML can author a free label (look it up in `lvai_aixml_reference` for a comment/decoration/free-label element; never guess a node name). If it cannot, put `#customerror 5000` as the first line of the VI's description instead AND report it as a deviation. Pane: `package` on an output slot of the standard 4x2x2x4 pane (the HWM and the SIM override will use the same pane; the override keeps the parent's pane). |
   Descriptions (one or two sentences each; `do`: "Placeholder: returns a default package and error 5000 (#customerror
   5000). A child class must override it."). Scope public (`set_scope.py` only if the tool made them otherwise).
   Prove each: cold `lvai_exec_state` 1; run `ZM-HW-do.vi` cold with `lvai_run_vi_and_read_values` and quote
   `error out` (code 5000, the source text). Commit per method or per batch `feat(hw): ...`.
4. **Library** `ZM-HW-hardware.lvlib` holding the class: the 01b helper route (derive from
   `proof\ZMP-01b\zm_create_package_library.xml`: `Library.Create`, one `AddItem` Type `LVClass`, `Save`), project
   OPEN AND ACTIVE; then project closed: `lvproj_drop.py` for a stray class item, `lvproj_move.py "ZM-HW-hardware.lvlib"
   hardware`; reopen and close once, no dialog; the `.lvproj` `hardware` folder lists the library once. Commit
   `feat(hw): library ZM-HW-hardware.lvlib under hardware`.
5. **Checks:** project closed; cold sweep of `src\hardware\ZM-HW-hardware\` (`ops\sweep.md`: every VI state 1,
   control `0 7`, `check_membership.py` clean); `lv_save_version.py` on every file written (26); dependency rule:
   `python <skill>\kit\lv_loadability.py --links <the four VIs>` shows links only into this class and into
   `src\common\ZM-PC-packages\` (for `do`), none into `vi.lib\ActorFramework`, none into `ZM-CU`/`ZM-TST`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\` or `src\tests\` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.4; nothing extra (no `Read initialized`, no other field).
  Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 55 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Class: `lvai_describe_class` reading; the accessor (scope, static);
members from the `.lvclass` XML with scope/dynamic. 3. `do`: how the free label was authored (or the deviation), the
cold run's `error out`. 4. Library route; the `.lvproj` `hardware` lines. 5. Sweep block, membership, versions, the
link summary. 6. Commits; `git status`. 7. Deviations / unmeasured / NEEDS CLARIFICATION; items for the user in the
IDE (class description, `Methods` folder). 8. Side effects.
