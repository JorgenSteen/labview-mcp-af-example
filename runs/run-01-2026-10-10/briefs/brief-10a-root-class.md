# Brief 10a: `ZM-ROOT-root` actor class: parent Actor, implements `ZM-CI-package_handler`; two typedefs, seven fields, accessors, `writePrelaunchSettings`
Type: build (LabVIEW calls). Phase 10 step a of 5 (b: hooks, launch methods, routing override, library, PLI, Handle Error; c: the panel loop `helperPanel`; d: Actor Core, T7, launch proofs, Stop button; e: cleanup, icons, closing checks).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-09a-hwm-class.md`
  (the measured route for the same kind of class: typedefs, `parentInterfaces`, bindings, accessors, custom
  accessor, the type-8 state), `report-08a-cm-class.md` (a class-typed field bound with `force: true`).
- State (report 09d, 2026-10-11 14:12): LabVIEW PID 14516 (port 59983), dwarn 22 (not degraded), project CLOSED, no
  dialog. Phases 01-09 are done: nothing outside `src\actors\ZM-ROOT-root\` and the `.lvproj` may change.
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**. D38: class description, `.ctl` membership
  (`TypeDefs`), `Methods`/`Accessors` placement by the user (list them). D39: icons without a prompt (step e).
- **D40** (`C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`, "Errors are not handled yet"; product `decisions.md` D40):
  every `evaluateError` is a pass-through for now; an error stop cascades through the Last Ack. The class description
  below states that plan, not D14's.
- Every `lvai_*`/`pylv_*` call ALONE in its message, offline and read-only ones included (F9).
- Traps: **`kit\lvproj_drop.py` splits on CRLF only and EMPTIED an LF `.lvproj` in 09a** (F10): check the line ending
  first; on LF use `...\zuehlke-mcp-af-test-results\proof\ZMP-09a\lvproj_drop_eol.py`; check the size after.
  `lvai_create_class` writes the `.lvproj` with LF and drops the BOM; a LabVIEW close restores CRLF and BOM (read the
  diff before any `git checkout`). The stray top-level `Actor.lvclass` item after `lvai_create_class` is dropped (09a).
  Bind fields BEFORE any accessor exists. A class implementing the interface reads cold "VI has an error of type 8"
  on EVERY member until step b adds the interface override: expected, report it. `accessUi: "Read"` makes one VI.
  `lvai_add_class_method` answers `ok: false` / `pathStandInsLeft` for a path stand-in inside a cluster terminal:
  `lvai_bind_pane_typedef`, proven by the export. Never probe a VI Server name with `lvai_validate_aixml`.

## Goal
`ZM-ROOT-root.lvclass` (parent `Actor Framework.lvlib:Actor.lvclass`, implements
`ZM-CI-common_interfaces.lvlib:ZM-CI-package_handler.lvclass`) with the typedefs, fields, accessors and the custom
accessor of `02` §7.12 (lines 525-565). No library, no hooks, no overrides, no loop here.

## Paths (absolute, long form)
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\actors\ZM-ROOT-root\ZM-ROOT-root\` (class, two `.ctl`, VIs flat).
- Actor `C:\Program Files (x86)\National Instruments\LabVIEW 2026\vi.lib\ActorFramework\Actor\Actor.lvclass`; Message
  Enqueuer class `C:\Program Files (x86)\National Instruments\LabVIEW 2026\vi.lib\ActorFramework\Message Enqueuer\Message Enqueuer.lvclass` (check by listing). Interface
  `...\src\common\ZM-CI-common_interfaces\ZM-CI-package_handler\ZM-CI-package_handler.lvclass`. Package type typedef
  `...\src\common\ZM-PC-packages\ZM-PC-package\ZM-PC-PACKAGE_TYPE.ctl`.
- AIXML sources `...\proof\ZMP-10a\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`; the HWM's
  custom accessor source `...\proof\ZMP-09a\ZM-HWM-writePrelaunchSettings.xml` is the template.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md`, `ops\helper-loop.md` step 1,
  `ops\sweep.md`, `knowledge\labview-mcp.md`, `kit\README.md`. Conventions `...\.labview\conventions\naming.md`
  (`role-names`), `af-shapes.md` (`events-typedef`, `prelaunch-settings`), `layout.md`, `hygiene.md`. Spec
  `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.12, §6; `01-requirements.md` R1, R8, R9.

## What to build, in this order (commit after each)
1. **`ZM-ROOT-PRELAUNCH_SETTINGS.ctl`**: `lvai_create_typedef` `cluster{path.outputFolder,bool.usePlaceholderHardware}`
   (plain types, no class element). `describe_ctl`: two elements.
2. **`ZM-ROOT-EVENTS.ctl`**: `cluster{ref{UserEvent}{bool.stop}.stop,ref{UserEvent}{string.error}.error}` (the spelling
   `ops\helper-loop.md` step 1 gives). `describe_ctl`: two elements `stop`, `error`.
3. **Class**: `lvai_create_class`, parent Actor, `parentInterfaces` = the interface, plain fields `bool.cmRunning`,
   `uint32.packageCount`, placeholders for `prelaunchSettings`, `events`, `lastPackageType`, `cmEnqueuer`,
   `hwmEnqueuer`; `projectPath`. Drop the stray item (F10 first). `describe_class`: parent, interface.
4. **Bindings** (project open and active): `prelaunchSettings`, `events` ← their `.ctl`; `lastPackageType` ←
   `ZM-PC-PACKAGE_TYPE.ctl`; `cmEnqueuer`, `hwmEnqueuer` ← the Message Enqueuer class (`force: true`, `ok: false`
   expected, `describe_class` shows `UDClassInst`). Gate on `describe_class`.
5. **Accessors** (static, private via `set_scope.py`, folder `Accessors`), exactly: `Read prelaunchSettings`; `Read
   cmEnqueuer`, `Write cmEnqueuer`; `Write hwmEnqueuer` (no Read); `Read cmRunning`, `Write cmRunning`; `Write
   lastPackageType` (no Read); `Read packageCount`, `Write packageCount`; `Read events`, `Write events`. Remove any
   extra direction (`remove_members.py`, project closed).
6. **`ZM-ROOT-writePrelaunchSettings.vi`** (CACC, public, static) as the HWM's: `settings` required, pane-bound to the
   typedef; class in optional; `Bundle By Name` of the field. State 0 (type 8) expected until step b.
7. **Checks** (project closed): `.lvclass` XML (members, scopes, interface, parent), bindings, `check_membership.py`,
   `lv_save_version.py` all 26, cold sweep of the class folder (type 8 expected; quote once), `git diff` empty outside
   the ROOT folder and the `.lvproj`.
Class description for the user (D38), with the error plan (D40): "Root actor: launches the communication manager
(CM, first) and the hardware manager (HWM) from its Actor Core with their pre-launch settings, routes every package
by destination (Communication → forwarded to the CM while it runs; Root → an error package is shown on the panel;
Unknown and Hardware → dropped with one log line), and shows its panel loop helperPanel with the Stop button and the
errors list. Error plan (D40, for now): evaluateError is a pass-through; an error stops the root and, through AF's
Stop Core, the whole tree; a child's error reaches the root through its Last Ack and stops it."

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.12; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 55 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The two typedefs (`describe_ctl`). 3. `describe_class`: parent, interface,
the seven fields and bindings; members with scope from the XML. 4. The custom accessor (pane, binding, state and the
type-8 text). 5. Sweep, membership, versions. 6. Commits; `git status`. 7. Deviations / unmeasured / NEEDS
CLARIFICATION; items for the user in the IDE. 8. Side effects.
