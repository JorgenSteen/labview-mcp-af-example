# Brief 08b: CM hooks, the `ZM-CI-handlePackage` override, `ZM-CM-communication_manager.lvlib`, and the three AF overrides
Type: build (LabVIEW calls, Actor Framework). Phase 08 step b of 3 (a: the class, done; c: launch proof, cleanup, icons, sweep).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-08a-cm-class.md`
  (the class, its fields, accessors, `writePrelaunchSettings`, the 1003 state), `report-07-ci-interface-message.md`
  (the interface method's pane and qualified names, `Send ZM-CI-handlePackage.vi`), `report-04b-cp-fl-test.md` and
  `report-05a2-cp-udp-hooks.md` (override creation and hook routes, `pa_insert_series2` inputs).
- From report 07: `Send ZM-CI-handlePackage.vi` (in `...\ZM-CI-common_interfaces\ZM-CI-handlePackage Msg\`) has the
  inputs `Message Enqueuer` (conIdx 11) and `package` (10, required); `Do.vi` casts the actor to the interface and
  calls `ZM-CI-handlePackage`. The interface method's pane is 4815 with `package` on 10.
- From report 08a (2026-10-11 11:10): LabVIEW PID 14516 (port 59983) is running, project CLOSED, no dialog. The class
  is at the project's TOP LEVEL (`.lvproj` item `ZM-CM-communication_manager.lvclass`): step 5 puts it into the library
  and the library into `actors`. All six existing members read **state 0** cold with "VI has an error of type 8" (not
  the literal 1003): read as the class-level break of the missing interface override, NOT proven; after step 4 every
  member must read state 1, and if one still reads 0, find its own cause before going on.
- The typedef `ZM-CM-PRELAUNCH_SETTINGS.ctl` is `cluster{protocol: ZM-CP-communication_protocol}` (made by the derived
  helper `helpers\zm_cluster_element_replace.vi`); `Read prelaunchSettings` returns it; Unbundle By Name `protocol`.
  The value terminal of `Write protocol` is named `ZM-CP-communication_protocol.lvlib\3AZM-CP-communication_protocol.lvclass`
  (conIdx 10, required): take terminal names from `lvai_vi_terminals`, never assume `protocol`.
- `lvai_add_class_method` answers `ok: false` with `pathStandInsLeft` when a path stand-in sits INSIDE a cluster
  terminal; bind that terminal with `lvai_bind_pane_typedef` and prove it from the export (report-08a, item 4c).
- Session 3 (2026-10-11): user go-ahead in the start message: "Continue run-01. You may restart LabVIEW when needed;
  agents may too."
- Save version **26.0**. You may start or restart LabVIEW yourself when it crashes or stops answering, per
  `<skill>\session\start.md`, at most twice, each reported. Never answer a dialog. D38: class description, `Methods`/`AF Overrides` placement by the
  user (list them). D39: icons without a prompt (step c).
- Traps: every `lvai_*`/`pylv_*` call ALONE in its message, offline ones included; never probe a VI Server name with
  `lvai_validate_aixml`; read a `.lvproj` diff before restoring it from git; `lvai_add_class_method` converts with the
  project closed (stubs and path seeds swapped afterwards); `Read Self Enqueuer`/`Read Caller Enqueuer` are protected AF
  methods: only a member of the actor class may call them (a non-member caller is broken, 1003); `Equal?` on clusters
  needs `Cluster To Array` → `And Array Elements`.

## Goal
Every remaining item of `02` §7.10 on `ZM-CM-communication_manager.lvclass`: the hooks `createResources`,
`releaseProtocol`, `evaluateError` (all HOOK, private, static), the interface override `ZM-CI-handlePackage.vi`
(public, dynamic, `Methods` per D35), the library `ZM-CM-communication_manager.lvlib` under the project's `actors`
folder, and the AF overrides `Pre Launch Init.vi`, `Stop Core.vi`, `Handle Error.vi` (protected, Call Parent each, in
the shapes below). The class then loads with no 1003; every member cold state 1. No launch, no cleanup, no icons here.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`;
  class `...\src\actors\ZM-CM-communication_manager\ZM-CM-communication_manager\ZM-CM-communication_manager.lvclass`;
  library to create `...\src\actors\ZM-CM-communication_manager\ZM-CM-communication_manager.lvlib`.
- AF: `C:\Program Files (x86)\National Instruments\LabVIEW 2026\vi.lib\ActorFramework\Actor\` (`Pre Launch Init.vi`,
  `Stop Core.vi`, `Handle Error.vi`, `Read Caller Enqueuer.vi`, `Actor.lvclass`). The message: `...\src\common\ZM-CI-common_interfaces\ZM-CI-handlePackage Msg\Send ZM-CI-handlePackage.vi`.
  The log: `...\src\common\ZM-CU-common_utilities\ZM-CU-log.vi`. Packages: `...\ZM-PC-EP-error_package\ZM-PC-EP-create.vi`.
  Protocol parent methods: `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\ZM-CP-{init,publish,close}.vi`.
- AIXML sources `...\proof\ZMP-08b\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\override.md` (sections 1-4, shapes B-after,
  E-after, F; Traps), `knowledge\actor-framework.md` ("Call order and lifecycle", "Overrides and connector panes" with
  the measured AF panes, "Errors in AF"), `knowledge\labview-mcp.md`, `kit\README.md`, `kit\lvai_create_override.xml`,
  `kit\pa_insert_series2.xml`, `kit\af_add_hook_call_node.xml`, `kit\pa_save_member.xml`.
- Conventions `...\.labview\conventions\af-shapes.md` (`resources`, `pli-failure-cleanup`, `stop-core-order`,
  `handle-error-order`, `hook-vis`, `prelaunch-settings`), `errors.md` (`plan-required` D14, `log-local` D15,
  `release-errors`, `ignored-errors`), `layout.md`, `naming.md`. Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md`
  §7.10 (lines 448-473), §5 (lines 165-204), §6 (lines 205-283); `01-requirements.md` R1, R5, R7, R8.

## What to build, in this order (methods → LIBRARY → AF overrides)
1. **`ZM-CM-evaluateError.vi`** (HOOK, private, static): pane class in/out, `error in`/`error out`, `stop actor?` in
   (recommended, default T) and out. Body (`02` §5): no error, or code 1608 → everything passes through untouched; any
   other error → `ZM-CU-log` with `CM` TAB code TAB source → `ZM-PC-EP-create("CM", the error as data)` → `Read Caller
   Enqueuer` → `Send ZM-CI-handlePackage` (a failed send ends in the error being cleared: Unbundle → Select) → `error
   out` = no error, `stop actor?` out = T. A case structure on "error status AND code ≠ 1608". Stubs for the members of
   other libraries and for `Read Caller Enqueuer`, swapped afterwards.
2. **`ZM-CM-releaseProtocol.vi`** (HOOK, private, static): `Read protocol` → `ZM-CP-close` (dynamic) → `Write protocol`.
   Errors (`errors.release-errors`): a release error is logged with `ZM-CU-log` (`CM` TAB code TAB source) and then
   cleared. **Unmeasured:** `02` says errors from a never-opened resource end in Clear Errors and are NOT logged.
   Measure first with a probe in the proof folder: a default MX holding `[FL, UDP-sender]` (never initialised) →
   `ZM-CP-close` → read the code; clear exactly that code without logging, log any other. Report the code.
3. **`ZM-CM-createResources.vi`** (HOOK, private, static; shape F, `af-shapes.pli-failure-cleanup`): `Read
   prelaunchSettings` → Unbundle `protocol` → `ZM-CP-init` (dynamic) → `Write protocol`; then a case on that error:
   Error frame → `releaseProtocol`, the original error passed on; No Error frame → pass through. Returns the error.
   **Unmeasured** (the case structure in a hook): prove cold state 1 and the step-c failure run.
4. **`ZM-CI-handlePackage.vi`** (OVR of the interface method, public, dynamic): `lvai_add_class_method` with the SAME
   name and the interface method's pane (read it with `lvai_connector_pane`), `dispatchTerminals` on the class pair.
   Body: `Read protocol` → `ZM-CP-publish(package)` → `Write protocol`; `Read publishedCount` → +1 → `Write
   publishedCount`. The error passes out (a publish error reaches `Do.vi` and Handle Error). After this, the class
   must load with no 1003: sweep the class folder cold, every member state 1.
5. **Library** `ZM-CM-communication_manager.lvlib` holding the class (the cached `zm_create_class_library.vi`, project
   open and active); then closed: read the `.lvproj` diff, `lvproj_drop.py` strays, `lvproj_move.py
   "ZM-CM-communication_manager.lvlib" actors`; reopen and close once. Commit.
6. **AF overrides** (after the library; `ops\override.md` section 1 with `kit\lvai_create_override.xml`, `vi name in
   memory` = `ZM-CM-communication_manager.lvlib:ZM-CM-communication_manager.lvclass:<file>`; commit each bare override):
   - `Pre Launch Init.vi`: hook `createResources` shape **B-after** on class AND error (measured on PLI, ops\override.md
     shape F); PLI has no `error in`.
   - `Stop Core.vi`: Call Parent FIRST, then `releaseProtocol` shape **B-after** on the class wire only (Stop Core has no
     error terminals); then feed `releaseProtocol`'s `error out` to `Clear Errors.vi` with `kit\af_add_hook_call_node.xml`
     (`source terminal name` = `error out`, `hook terminal name` = `error in`; **unmeasured**) so no `error out` is
     unwired (`errors.ignored-errors`); `releaseProtocol` already logs and clears, so this only closes the wire.
   - `Handle Error.vi`: Call Parent FIRST, then `evaluateError` shape **B-after** on class and `error out` (ops
     shape E-after). Its `stop actor?` input stays unwired (default T) and the override's `stop actor?` indicator keeps
     its wire from Call Parent: the parent always returns T, and no kit helper wires a third terminal (ops: the
     three-wire variant is unmeasured and needs the user). Report this as the shape used.
   `pa_save_member` after each hook, in a separate call. Export each override and quote the order.
7. **Checks:** project closed; cold sweep of the class folder (every VI state 1, control `0 7`), `check_membership.py`;
   `lv_save_version.py` (26); `lv_loadability.py --links` on the CM VIs: links only into the CM folder,
   `ZM-CI-common_interfaces`, `ZM-CP-communication_protocol` (the PARENT only), `ZM-PC-packages`, `ZM-CU-common_utilities`
   and `vi.lib\ActorFramework`; **none into `ZM-CP-FL`, `ZM-CP-UDP`, `ZM-CP-MX`, `ZM-HW*`, `ZM-HWM`, `ZM-ROOT`**.
   The scopes from the `.lvclass` XML: hooks private, overrides protected (AF) / public (interface).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing outside `src\actors\ZM-CM-communication_manager\` and the `.lvproj` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.10. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 70 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Each hook: pane, body route, exec state; the releaseProtocol probe's code.
3. The interface override: pane, dynamic, the 1003 gone (sweep). 4. Library route; `.lvproj` `actors` lines.
5. The `ops\override.md` block per AF override with export evidence. 6. Sweep, membership, versions, links (the
forbidden list checked). 7. Commits; `git status`. 8. Deviations / unmeasured steps / NEEDS CLARIFICATION; items for
the user in the IDE. 9. Side effects.
