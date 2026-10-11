# Brief 09a: `ZM-HWM-hardware_manager` actor class: parent Actor, implements `ZM-CI-package_handler`; two typedefs, fields, accessors, `writePrelaunchSettings`
Type: build (LabVIEW calls). Phase 09 step a of 4 (b: hooks, interface override, library, PLI and Handle Error overrides; c: the helper loop; d: Actor Core hooks, proof runs, cleanup, icons, sweep).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-08a-cm-class.md`
  (the MEASURED route for a pre-launch-settings typedef holding a class, the actor class with `parentInterfaces`,
  the class-typed field binding, the custom accessor and the 1003 state until the interface override exists),
  `report-08c-cm-launch-cleanup-icons.md` (the state of the tree), `report-01a-pc-classes.md`.
- State (2026-10-11 11:47, report 08c): LabVIEW PID 14516 (port 59983) running, dwarn 4, project CLOSED, no dialog.
  Phase 08 is done: the CM is in `ZM-CM-communication_manager.lvlib` under `actors`; nothing of it may change here.
- From report 08a: there is NO AIXML spelling for a class-typed cluster element. The measured route: `lvai_create_typedef`
  `cluster{path.hardware,uint32.intervalMs}`, then the derived helper `helpers\zm_cluster_element_replace.vi` (source
  `...\proof\ZMP-08a\zm_cluster_element_replace.xml`; it takes `{LV.Cluster} Controls[]` at index **0**, so keep
  `hardware` FIRST; for another index derive a copy in `...\proof\ZMP-09a\` and report it), project open and active;
  `lvai_describe_ctl` must show the class element. A class-typed field binds with `ctlPath` = the `.lvclass`, `force:
  true`, `ok: false` expected (08a item 3). `accessUi: "Read"` makes one VI only.
- From report 08a/08b: a class implementing the interface without its override reads cold **"VI has an error of type
  8"** on EVERY member (not the literal 1003); 08b proved it is the missing interface override. Report it, do not fix it.
  `lvai_add_class_method` answers `ok: false` / `pathStandInsLeft` for a path stand-in INSIDE a cluster terminal: bind
  the terminal with `lvai_bind_pane_typedef` and prove it from the export (08a item 4). The CM's custom accessor
  (`...\proof\ZMP-08a\ZM-CM-writePrelaunchSettings.xml`) is the template for the HWM's.
- `lvai_create_class` dropped the stray `Actor.lvclass` top-level item (`lvproj_drop.py`, 1 line); the interface was
  not added as an item (08a item 3).
- Session 3 (2026-10-11) user go-ahead in the start message: "Continue run-01. You may restart LabVIEW when needed;
  agents may too."
- Save version **26.0**. You may start or restart LabVIEW yourself when it crashes or stops answering, per
  `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions, `.ctl` membership (`TypeDefs`) and `Methods`/`Accessors`/`Helpers`
  placement by the user (list them). D39: icons without a prompt (step d).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib`; `lvproj_drop.py` strays after
  `lvai_create_class`; bind BEFORE any accessor exists; `parentInterfaces` links the interface at creation only; a
  class implementing an interface reads "error of type 8" until step b overrides the method (expected, say so); the
  user-event typedef spelling measured in the pilot: `cluster{ref{UserEvent}{bool.stop}.stop}` (the suffix labels
  the element, which the event frames select).

## Goal
`ZM-HWM-hardware_manager.lvclass` (parent `Actor Framework.lvlib:Actor.lvclass`, implements `ZM-CI-package_handler`)
with the typedefs `ZM-HWM-PRELAUNCH_SETTINGS.ctl` = cluster `{hardware: ZM-HW-hardware, intervalMs: U32 = 500}` and
`ZM-HWM-EVENTS.ctl` = cluster `{stop: User Event refnum (Boolean)}`; the fields `prelaunchSettings` (bound to the first
typedef), `packageCount` (U32), `events` (bound to the second); the accessors `Read prelaunchSettings` (priv),
`Read packageCount`/`Write packageCount` (priv), `Read events`/`Write events` (priv), all static; and the public
custom accessor `ZM-HWM-writePrelaunchSettings.vi`. No library, no overrides, no hooks, no loop here.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\` (class, two `.ctl`, VIs flat).
- Actor: `C:\Program Files (x86)\National Instruments\LabVIEW 2026\vi.lib\ActorFramework\Actor\Actor.lvclass`.
  Interface: `...\src\common\ZM-CI-common_interfaces\ZM-CI-package_handler\ZM-CI-package_handler.lvclass`. Hardware
  parent: `...\src\hardware\ZM-HW-hardware\ZM-HW-hardware\ZM-HW-hardware.lvclass`.
- AIXML sources `...\proof\ZMP-09a\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md`, `ops\helper-loop.md`
  (step 1: the events typedef and field), `ops\sweep.md`, `knowledge\labview-mcp.md`, `kit\README.md`.
- Conventions: `...\.labview\conventions\naming.md` (`role-names`: `EVENTS`, field `events`; `PRELAUNCH_SETTINGS`,
  field `prelaunchSettings`; `writePrelaunchSettings`), `layout.md`, `af-shapes.md` (`events-typedef`,
  `prelaunch-settings`), `hygiene.md`. Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md`
  §7.11 (lines 474-524), §6, §5; `01-requirements.md` R1, R8 (point 2), R9; `04-decisions.md` D2, D14, D27, D32.

## What to build, in this order
1. **Typedef** `ZM-HWM-PRELAUNCH_SETTINGS.ctl`: cluster `{hardware: ZM-HW-hardware class, intervalMs: U32 default 500}`
   by the route 08a measured (its report says the spelling or the element-replace helper; `intervalMs` is a plain
   `uint32.intervalMs` element with default 500: set the default the way the route allows and report how, or report
   that the default sits in `launchHwm`'s bundle instead, which `02` §7.12 also does). `lvai_describe_ctl`: two
   elements, the class and the U32. Commit.
2. **Typedef** `ZM-HWM-EVENTS.ctl`: `lvai_create_typedef` `cluster{ref{UserEvent}{bool.stop}.stop}`, no `projectPath`;
   `describe_ctl`: one element `stop`, a user-event refnum of Boolean. Commit.
3. **Class** `ZM-HWM-hardware_manager.lvclass`: `lvai_create_class` with `parentClassPath` = `Actor.lvclass`,
   `parentInterfaces` = the interface, plain field `uint32.packageCount` plus placeholders `bool.prelaunchSettings`
   and `bool.events` (or `typedefFieldsJson` for both if 08a measured that it binds at creation; follow 08a),
   `projectPath`. `describe_class`: parent Actor, the interface. `lvproj_drop.py` strays. Commit.
4. **Bindings** (project open and active, if not done at creation): `prelaunchSettings` ← its `.ctl`, `events` ←
   `ZM-HWM-EVENTS.ctl` (gated on `boundInFile`). Close; commit.
5. **Accessors** (static, private, folder `Accessors`): `Read prelaunchSettings` only; `Read packageCount`,
   `Write packageCount`; `Read events`, `Write events`. Remove extra directions. Commit.
6. **`ZM-HWM-writePrelaunchSettings.vi`** (CACC, public, static): as 08a's (`settings` required, pane-bound to the
   typedef; class in optional; `Bundle By Name` of the field). Description. State 0 with error 1003 expected until
   step b; report it. Commit.
7. **Checks** (project closed): the `.lvclass` XML (members, scopes, interface, parent), `describe_class` bindings
   (`events` as the typedef cluster of a refnum), `check_membership.py`, `lv_save_version.py` all 26, cold sweep of
   the class folder (1003 expected; quote once).
Class description for the user (D38), with the error plan (D14): "Hardware manager actor: owns a hardware object
from its pre-launch settings; its helper loop ZM-HWM-helperAcquisition calls the hardware every intervalMs (init
before, do in the loop, close after) and sends each package to this actor, which counts it and forwards it to its
caller through ZM-CI-handlePackage. Error plan (D14): a message error is logged, sent upward as an error package
(sender HWM) to the caller, and the actor stops with the error cleared (stop actor? T), so its Last Ack is clean and
the root keeps running. A helper-loop error ends the loop, which then calls evaluateError and sends Normal Stop to
this actor."

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\`, `src\hardware\`, `src\protocol\`, `src\tests\`, `ZM-CM-communication_manager\` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.11; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 55 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The two typedefs (routes, `describe_ctl`). 3. `describe_class`: parent,
interface, fields and bindings; members with scope from the XML. 4. The custom accessor (pane, binding, state and the
1003 text). 5. Sweep, membership, versions. 6. Commits; `git status`. 7. Deviations / unmeasured / NEEDS CLARIFICATION;
items for the user in the IDE. 8. Side effects.
