# Brief 09b: HWM role hooks, `evaluateError`, the `ZM-CI-handlePackage` override, `ZM-HWM-hardware_manager.lvlib`, Pre Launch Init and Handle Error
Type: build (LabVIEW calls, Actor Framework). Phase 09 step b of 4 (a: the class, done; c: the helper loop; d: Actor Core, proof runs, cleanup, icons, sweep).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-09a-hwm-class.md`,
  then `report-08b-cm-hooks-overrides.md` (the MEASURED route for every item of this step on the CM: hooks with stubs
  and swaps, `evaluateError`, `createResources` shape F, the interface override, the library, the PLI and Handle Error
  overrides) and `report-08c-cm-launch-cleanup-icons.md` (how the CM behaved when launched).
- State (report 09a, 2026-10-11 11:56): LabVIEW PID 14516 (port 59983), dwarn 4, project CLOSED. The class is a TOP-LEVEL
  project item (step 5 wraps it). All six members read cold state 0 "VI has an error of type 8" until step 4 adds the
  interface override (08b proved that cause on the CM). `ZM-HWM-PRELAUNCH_SETTINGS` = `{hardware: ZM-HW-hardware,
  intervalMs: U32 = 500}`; `ZM-HWM-EVENTS` = `{stop: user event of Boolean}` (`describe_ctl` does not show the subtype).
- **`kit\lvproj_drop.py` splits on CRLF only and EMPTIED an LF `.lvproj` in 09a** (finding F10). Before every drop,
  check the `.lvproj` line ending; on LF use `...\proof\ZMP-09a\lvproj_drop_eol.py` (same arguments; keeps the ending,
  refuses an emptied file); check the file size after. `lvproj_move.py` keeps the file's own ending.
- From 08b: `lvai_placeholder_subvi` types a stub's output as a scalar path when the source returns a typedef cluster
  with a CLASS element (the 08b agent hand-made `LVMCP Stub ZMP08b-readPrelaunchSettings.vi` typed
  `cluster{path.protocol}` in `user.lib\LV_MCP`; HWM's `Read events` returns a user-event cluster: check the stub's
  type before the Unbundle). `Clear Errors.vi`'s input is `error in (no error)`. The library close replaced the class
  item by the library item (no drop needed, but check). Two exports in one message were 08b's rule break.
- From 08c: AF overrides keep NI's help text after `lvai_create_override`; set their descriptions with
  `pa_replace_description` (description only, project closed, no regeneration) at the end of this step and say so.
  The CM's evaluateError (13 stages) exceeded the width budget; no subVI invented: same for the HWM's.
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**. D38: class description and `Methods`/
  `AF Overrides`/`Helpers` placement by the user (list them). D39: icons without a prompt (step d).
- Every `lvai_*`/`pylv_*` call ALONE in its message, offline and read-only ones included (F9: broken in five of eight
  Opus steps so far, last in 08b with two exports).

## Goal
On `ZM-HWM-hardware_manager.lvclass`: the hooks `createEvents`, `stop`, `close`, `createResources`, `evaluateError`
(all HOOK, private, static), the interface override `ZM-CI-handlePackage.vi` (public, dynamic), the library
`ZM-HWM-hardware_manager.lvlib` under the project's `actors` folder, and the AF overrides `Pre Launch Init.vi` and
`Handle Error.vi` (protected, Call Parent each). After this step the class loads with every member cold state 1. NOT
here: `ZM-HWM-helperAcquisition.vi` (step c), `Actor Core.vi` (step d), cleanup, icons. No Stop Core (`02` §6).

## Paths (absolute, long form)
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`; class
  `...\src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager.lvclass`; library to create
  `...\src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager.lvlib`. AIXML sources `...\proof\ZMP-09b\`; the CM's
  measured sources to adapt: `...\proof\ZMP-08b\` (`evaluateError`, `createResources`, `ZM-CI-handlePackage`).
- AF `C:\Program Files (x86)\National Instruments\LabVIEW 2026\vi.lib\ActorFramework\Actor\`. Message
  `...\src\common\ZM-CI-common_interfaces\ZM-CI-handlePackage Msg\Send ZM-CI-handlePackage.vi`; log
  `...\src\common\ZM-CU-common_utilities\ZM-CU-log.vi`; `ZM-PC-EP-create.vi` in `...\src\common\ZM-PC-packages\`.
- Helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\` (cached `zm_create_class_library.vi`).
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\helper-loop.md` step 2 (role members: one
  `lvai_add_class_method` call for several members, one `lvai_swap_subvis`), `ops\override.md` (shapes B-after,
  E-after, F; Traps), `knowledge\actor-framework.md`, `knowledge\labview-mcp.md`, `kit\README.md`.
- Conventions `...\.labview\conventions\af-shapes.md` (`events-typedef`, `resources`, `pli-failure-cleanup`,
  `close-vi`, `stop-site`, `handle-error-order`, `hook-vis`), `errors.md` (`plan-required`, `log-local`,
  `ignored-errors`, `loop-errors`), `naming.md` (`role-names`), `layout.md`. Spec
  `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.11 (lines 474-524), §5 (165-204), §6 (205-283).

## What to build, in this order (role hooks → evaluateError → interface override → LIBRARY → AF overrides)
1. **`createEvents`**: `Create User Event` (Boolean, element label `stop`) → Bundle By Name into `ZM-HWM-EVENTS` →
   `Write events`. **`stop`**: `Read events` → Unbundle `stop` → `Generate User Event` (T). **`close`**: `Read events`
   → Unbundle → `Destroy User Event`; its error → `Clear Errors.vi` (`error in (no error)`), errors ignored on purpose.
   Panes per `ops\helper-loop.md` step 2 (class in/out, error in/out). Commit.
2. **`createResources`** (shape F, `af-shapes.pli-failure-cleanup`): `createEvents`; case on its error: Error frame →
   `close` on a fresh chain, then Merge Errors with the original error FIRST; No Error frame → pass through. Commit.
3. **`evaluateError`**: the CM's `evaluateError` with sender `"HWM"` and log text `HWM\t<code>\t<source>`; same pane
   (`stop actor?` in 10 default T, out 2). Commit.
4. **`ZM-CI-handlePackage.vi`** (OVR of the interface method, same name and pane 4815, `dispatchTerminals` on the
   class pair): `Read packageCount` → +1 → `Write packageCount` → `Read Caller Enqueuer` → `Send ZM-CI-handlePackage`
   (package in) → a failed send (shutdown, `02` §5) ends in `Clear Errors.vi`; the class wire out. Afterwards the
   class must load with NO type-8 break: cold sweep of the class folder, every member state 1. Commit.
5. **Library** as 08b step 4 (cached helper, project open and active; then closed: read the `.lvproj` diff,
   `lvproj_drop.py`, `lvproj_move.py "ZM-HWM-hardware_manager.lvlib" actors`; reopen and close once). Commit.
6. **AF overrides** (`ops\override.md` section 1, `kit\lvai_create_override.xml`, `vi name in memory` =
   `ZM-HWM-hardware_manager.lvlib:ZM-HWM-hardware_manager.lvclass:<file>`; commit each bare override):
   `Pre Launch Init.vi`: `createResources` shape B-after on class AND error (as the CM's). `Handle Error.vi`: Call
   Parent FIRST, then `evaluateError` shape E-after on class and `error out`; `stop actor?` from Call Parent, as the
   CM's (report-08b, item 5). `pa_save_member` after each hook, in its own call. Export each; quote the order.
7. **Checks** (project closed): cold sweep of the class folder (every VI state 1, control `0 7`), `check_membership.py`,
   `lv_save_version.py` (26), `lv_loadability.py --links --vilib` on the HWM VIs: links only into the HWM folder,
   `ZM-CI-common_interfaces`, `ZM-HW-hardware` (the PARENT only), `ZM-PC-packages`, `ZM-CU-common_utilities`, vi.lib;
   **none into `ZM-HW-SIM`, `ZM-CM`, `ZM-ROOT`, `ZM-CP*`**. Scopes from the `.lvclass` XML.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing outside `src\actors\ZM-HWM-hardware_manager\` and the `.lvproj` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.11. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 70 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Each hook: pane, body route, exec state. 3. The interface override: pane,
dynamic, the type-8 break gone (sweep). 4. Library route; `.lvproj` `actors` lines. 5. The `ops\override.md` block per
AF override with export evidence. 6. Sweep, membership, versions, links (forbidden list checked). 7. Commits; `git
status`. 8. Deviations / unmeasured / NEEDS CLARIFICATION; items for the user in the IDE. 9. Side effects.
