# Brief 08a: `ZM-CM-communication_manager` actor class: parent Actor, implements `ZM-CI-package_handler`; typedef, fields, accessors, `writePrelaunchSettings`
Type: build (LabVIEW calls). Phase 08 step a of 3 (b: hooks, interface override, library, AF overrides; c: launch test, cleanup, icons, sweep).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-07-ci-interface-message.md`
  (the interface's qualified name and path, how `lvai_create_interface` and the message were made),
  `report-01a-pc-classes.md` (typedef + class + bound field + accessors), `report-05b-cp-mx.md` (a typedef whose
  element is a class, via `pa_array_element_replace.xml`, and a field bound to it), `report-01b-pc-methods-library.md`.
- Facts from report 07 (2026-10-11 10:50): the interface is
  `...\src\common\ZM-CI-common_interfaces\ZM-CI-package_handler\ZM-CI-package_handler.lvclass`, qualified
  `ZM-CI-common_interfaces.lvlib:ZM-CI-package_handler.lvclass`, `NI.LVClass.IsInterface` true; its one method
  `ZM-CI-handlePackage.vi` has pane 4815: class in 11, `package` 10 (required, `ZM-PC-package`), error in 8, class out
  3, error out 0. `lvai_create_interface` and `lvai_create_class` drop the `.lvproj` BOM and add a top-level class
  line; the next close restores the BOM: READ the diff before any `git checkout` of the `.lvproj`.
- Facts from report 06: T1-T6 all PASS; every plain class is proven. From here, a failure is an actor-side problem.
- Session 3 (2026-10-11 11:03): user go-ahead in the start message: "Continue run-01. You may restart LabVIEW when
  needed; agents may too." **LabVIEW is NOT running** at launch (the user closed PID 14040 at ~11:01 by answering its
  "Save changes? (Exit)" dialog; only `LVMCP Validate*` scratch VIs were unsaved; git clean; LVAutoSave 0). Start it
  yourself first per `<skill>\session\start.md` step 3-4: `lv_windows.ps1`, `lvai_ensure_labview` (LVAutoSave is 0, so
  its default clearing is safe), then `lvai_status` until it answers; report PID and time.
- Every `lvai_*`/`pylv_*` call ALONE in its message, offline ones included: broken in four of six Opus steps (F9).
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions, `.ctl` membership (`TypeDefs`) and `Methods`/`Accessors` placement
  by the user (list them). D39: icons without a prompt (step c).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib`; a class created with a parent in a
  library leaves a stray top-level item (`lvproj_drop.py`); bind BEFORE any accessor exists; `lvai_create_class`
  with `parentInterfaces` links the interface at creation (no tool adds one later: NI's provider is a modal); a
  class that implements an interface is error 1003 until it overrides every interface method (step b does that:
  expect state 0 on the class's members until then and say so); an array-of-class is never bound inside
  `lvai_create_class` (it crashed LabVIEW); a class-typed field binds with `ctlPath` = the `.lvclass` and `force: true`,
  `ok: false` is the expected answer and `lvai_describe_class` shows `Refnum`, `RefType=UDClassInst`.

## Goal
`ZM-CM-communication_manager.lvclass` (parent `Actor Framework.lvlib:Actor.lvclass`, implements
`ZM-CI-common_interfaces.lvlib:ZM-CI-package_handler.lvclass`) with the typedef `ZM-CM-PRELAUNCH_SETTINGS.ctl` =
cluster `{protocol: ZM-CP-communication_protocol}`, the fields `prelaunchSettings` (bound to that typedef), `protocol`
(the class `ZM-CP-communication_protocol`), `publishedCount` (U32); the accessors `Read prelaunchSettings` (priv),
`Read protocol`/`Write protocol` (priv), `Read publishedCount`/`Write publishedCount` (priv), all static; and the
public custom accessor `ZM-CM-writePrelaunchSettings.vi` (in `settings` required, class in optional = a default
object; writes `prelaunchSettings`). No library, no overrides, no hooks here (step b).

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\actors\ZM-CM-communication_manager\ZM-CM-communication_manager\` (class, `.ctl`, VIs
  flat); the library file comes in step b at `...\src\actors\ZM-CM-communication_manager\ZM-CM-communication_manager.lvlib`.
- Actor: `C:\Program Files (x86)\National Instruments\LabVIEW 2026\vi.lib\ActorFramework\Actor\Actor.lvclass`.
  Interface: `...\src\common\ZM-CI-common_interfaces\ZM-CI-package_handler\ZM-CI-package_handler.lvclass`. Protocol
  parent: `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol.lvclass`.
- AIXML sources `...\proof\ZMP-08a\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md` (route A; "New classes"),
  `ops\sweep.md`, `knowledge\labview-mcp.md` ("Known gaps": `lvai_create_class, lvai_create_interface`,
  `lvai_create_typedef`, `lvai_bind_class_fields`, `lvai_create_accessors`, `lvai_add_class_method`),
  `knowledge\actor-framework.md` ("Overrides and connector panes": scope facts), `kit\README.md`.
- Conventions: `...\.labview\conventions\naming.md` (`role-names`: `PRELAUNCH_SETTINGS`, field `prelaunchSettings`,
  `writePrelaunchSettings`), `layout.md`, `af-shapes.md` (`prelaunch-settings`), `hygiene.md`. Spec:
  `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.10 (lines 448-473), §6 (the
  prelaunch-settings rule), §5 (the error plan, for the class description); `01-requirements.md` R1, R8;
  `04-decisions.md` D2, D14.

## What to build, in this order
1. **Typedef** `ZM-CM-PRELAUNCH_SETTINGS.ctl` flat in the class folder: a cluster with ONE element `protocol` whose
   type is the class `ZM-CP-communication_protocol`. **Unmeasured on this station.** Routes, first that works:
   (a) `lvai_create_typedef` with a class-element spelling if `lvai_aixml_reference` documents one (look it up; never
   guess a spelling); (b) `lvai_create_typedef` `cluster{path.protocol}` (a path placeholder), commit, then a helper
   derived from `<skill>\kit\pa_array_element_replace.xml` that replaces the CLUSTER element `protocol` by a class
   constant of `ZM-CP-communication_protocol.lvclass` (the kit helper does it for an array element; read its XML and
   adapt the element lookup to a cluster; project open and active); `lvai_describe_ctl` must then show the element as
   the class. If neither works after one attempt each, stop with a `CANNOT PROCEED` block naming what each answered.
   Commit `feat(cm): typedef ZM-CM-PRELAUNCH_SETTINGS`.
2. **Class** `ZM-CM-communication_manager.lvclass`: `lvai_create_class` with `parentClassPath` = `Actor.lvclass`,
   `parentInterfaces` = the interface, plain fields `uint32.publishedCount` plus placeholders `bool.prelaunchSettings`
   and `string.protocol`, `projectPath` = the project. `lvai_describe_class`: parent Actor, the interface listed.
   `lvproj_drop.py` strays (the parent `Actor.lvclass` or the interface as top-level items), project closed. Commit.
3. **Bindings** (project open and active): `lvai_bind_class_fields` `prelaunchSettings` ← the `.ctl` (gated on
   `boundInFile`); `protocol` ← `ZM-CP-communication_protocol.lvclass` with `force: true` (`ok: false` expected;
   `describe_class` shows `UDClassInst`). Close; commit.
4. **Accessors** (static, private via `set_scope.py`, folder `Accessors`): `Read prelaunchSettings` only;
   `Read protocol`, `Write protocol`; `Read publishedCount`, `Write publishedCount`. Remove any extra direction the
   wizard makes (`remove_members.py`, project closed). Commit.
5. **`ZM-CM-writePrelaunchSettings.vi`** (CACC, public, static; `lvai_add_class_method`): pane `settings` (required,
   bound to `ZM-CM-PRELAUNCH_SETTINGS.ctl` with `lvai_bind_pane_typedef`), class in (optional, default object),
   class out, error in/out; body: `Bundle` the settings into the private data through... the field has only a
   `Read` accessor by `02` (no `Write prelaunchSettings`), so this custom accessor writes the field by `Bundle By
   Name` on the class wire (a custom accessor IS the accessor for its field; `layout.accessors-for-own-data` is
   met). Description: "Public custom accessor: writes the pre-launch settings (af-shapes.prelaunch-settings); the
   caller fills ZM-CM-PRELAUNCH_SETTINGS and launches the actor." Cold state: expected 0 until step b overrides
   the interface method (error 1003 on the class); report the state and the error text as evidence, not as a
   failure. Commit.
6. **Checks** (project closed): the `.lvclass` XML lists the members, scopes, the interface and the parent; the
   five `.ctl`/field bindings per `describe_class`; `check_membership.py`; `lv_save_version.py` all 26; cold sweep
   of the class folder (state 0 with error 1003 expected on every member until step b; quote the error text once).
Class description text for the user (D38), with the error plan (D14, `errors.plan-required`): "Communication
manager actor: owns a communication protocol object from its pre-launch settings, initialises it in Pre Launch Init
(createResources), hands every package it receives to it (publish), and closes it in Stop Core. Error plan (D14): a
message error is logged, sent upward as an error package (sender CM) to the caller, and the actor stops with the
error cleared (stop actor? T), so its Last Ack is clean and the root keeps running."

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\`, `src\hardware\`, `src\protocol\`, `src\tests\` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.10; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 55 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The typedef route that worked (calls and answers), `describe_ctl`.
3. `describe_class`: parent, interface, fields and bindings; members with scope from the XML. 4. The custom accessor:
pane, binding, state and the 1003 text. 5. Sweep, membership, versions. 6. Commits; `git status`. 7. Deviations /
unmeasured / NEEDS CLARIFICATION / CANNOT PROCEED; items for the user in the IDE. 8. Side effects.
