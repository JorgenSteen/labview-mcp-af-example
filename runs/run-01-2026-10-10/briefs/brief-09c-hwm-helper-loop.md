# Brief 09c: the HWM helper loop `ZM-HWM-helperAcquisition.vi` (variant 2: event loop + timed producer loop, live panel)
Type: build (LabVIEW calls, Actor Framework helper loop). Phase 09 step c of 4 (a: class; b: hooks, library, PLI, Handle Error; d: Actor Core, proof runs, cleanup, icons, sweep).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-09b-hwm-hooks-overrides.md`
  (what exists: `createEvents`, `stop`, `close`, `evaluateError`, the library), `report-09a-hwm-class.md` (the events
  typedef and its element label), `report-08b-cm-hooks-overrides.md` (stub and swap route).
  <<MANAGER: traps from report 09b go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**. D38: `Helpers` placement by the user.
- Every `lvai_*`/`pylv_*` call ALONE in its message, offline and read-only ones included (F9).
- This is the hardest VI of the project (phase card 09). Several steps are **unmeasured**; measure each on a throwaway
  copy in the proof folder before touching the member, and report what each answered.

## Goal
`ZM-HWM-hardware_manager.lvclass:ZM-HWM-helperAcquisition.vi`, a private static member, exactly as `02` §7.11 (lines
507-524) and `01` R8 points 1-7 and R9 say, built by `<skill>\ops\helper-loop.md` steps 3-10 (variant 2). Cold state 1.
NOT here: hooking it into Actor Core, any launch (step d).

## Paths (absolute, long form)
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`;
  member path `...\src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\ZM-HWM-helperAcquisition.vi`.
  AIXML and throwaways `...\proof\ZMP-09c\`. Helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Called VIs: the HWM's `Read prelaunchSettings`, `Read events`, `evaluateError`; AF `Read Self Enqueuer.vi`, `Send
  Normal Stop.vi` (find the exact file by listing `vi.lib\ActorFramework`); `Send ZM-CI-handlePackage.vi`; HW parent
  `...\src\hardware\ZM-HW-hardware\ZM-HW-hardware\ZM-HW-{init,do,close}.vi`; TP `ZM-PC-TP-test_package.lvclass` and its
  public `Read data` (`ZM-PC-TP-DATA`: `temperature_c` DBL, `duty_percent` U8).
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\helper-loop.md` (steps 3-10, Checks, Report,
  Traps; follow it literally), `knowledge\actor-framework.md` ("User events and helper-loop hazards"),
  `knowledge\labview-mcp.md`, `kit\README.md`, `kit\pa_wire_dyn_right.xml`, `kit\set_user_event_specs.py`,
  `kit\pa_set_panel_on_call.xml`, `kit\pa_read_panel_on_call.xml`, `kit\pa_set_control_visible.xml`,
  `kit\pa_read_boolean.xml`, `kit\example_helper_loop.xml` (spellings only, not its stop shape).
- Conventions `...\.labview\conventions\af-shapes.md` (`helper-loop-vi`, `helper-loop-error-case`, `registration`,
  `stop-mechanism`, `timed-work`, `close-vi`), `errors.md` (`loop-errors`, `ignored-errors`), `layout.md`. Spec
  `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.11; `01-requirements.md` R8, R9.

## What to build (one VI, two loops)
- **Pane:** `ZM-HWM-hardware_manager in` (a copy, not returned), `error in`, `error out`. Panel **shown when called,
  closed afterwards** (`pa_set_panel_on_call`, read back cold).
- **Panel:** waveform chart `live` (two plots `temperature_c`, `duty_percent`, default history); U32 control `interval
  set (ms)`; U32 indicator `interval measured (ms)`; Boolean `stop`: a Switch (not latched), off the pane, hidden.
- **Before both loops:** `stop` = F by local; `Read prelaunchSettings` → Unbundle `hardware`, `intervalMs` →
  `interval set (ms)` by local (once); `ZM-HW-init` on the hardware.
- **Event loop:** `Read events` → Unbundle `stop` → Register For Events (fresh no error) → loop with the error case
  (shift register); No Error frame: event structure, frame `stop` → `stop` = T by local, exit. Right-side refnum →
  Unregister → Merge Errors. No Timeout frame unless the tool needs an empty one.
- **Producer loop:** error case in a shift register; No Error frame: `ZM-HW-do` → `Read Self Enqueuer` → `Send
  ZM-CI-handlePackage`; chart: `To More Specific Class` (TP) → `Read data` → bundle `temperature_c`, `duty_percent`
  (as DBL) → `live`; a non-TP cast error → `Clear Errors.vi` on its OWN wire (the loop is not disturbed); `Wait (ms)`
  fed from the `interval set (ms)` terminal; `interval measured (ms)` = timer output minus the previous one (shift
  register, 0 on the first iteration); the `stop` local read SEQUENCED AFTER the Wait; exit on `stop` T or an error.
  After the loop: `ZM-HW-close` (runs with an error too: safe state).
- **After both loops:** Merge Errors; on an error → `evaluateError` (`stop actor?` unwired) → `Read Self Enqueuer` →
  `Send Normal Stop` (`errors.loop-errors`). `error out` = the merged errors. Description per `hygiene.descriptions`.

## Route and unmeasured points
Follow `ops\helper-loop.md` steps 3-10 in order, then its Checks. Unmeasured, each to be proven on a throwaway first:
(1) the event structure nested in the No Error frame of a case inside the loop survives `lvai_generate_vi_with_events`;
(2) `lvai_wire_dynamic_events` inside that frame; (3) `kit\pa_wire_dyn_right.xml` extended one level (copy it to the
proof folder as a derived helper, never edit the kit); (4) a second, plain loop beside the event loop in the same
document; (5) the plot names `temperature_c`/`duty_percent` on the chart: if AIXML cannot name plots, take a VI Server
property spelling ONLY from `resource\lvserver.rsc` or an NI helper (never probe with `lvai_validate_aixml`), and if
no measured route exists, leave the default names and report it as an item for the user. Measure the `stop` reset by
calling the loop VI twice from one caller only in step d.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. No retry
  loops. Never run the loop VI by itself (it waits for a stop event nobody sends; a hung loop needs a restart).
- Closing a project: open yours first, pass projectPath. No hand edits of LabVIEW files (kit scripts only, project
  closed). AIXML with the Write tool. Nothing outside `src\actors\ZM-HWM-hardware_manager\` and the `.lvproj` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.11. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 80 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The `ops\helper-loop.md` report block, filled. 3. Each unmeasured point
(1)-(5): what was tried, what it answered. 4. The export: Register/Unregister, the case frames, the locals (three
writes/reads named), the Wait→stop sequence, the chart path. 5. Panel-on-call and `stop` read back cold. 6. Sweep,
membership, versions, links (no `ZM-HW-SIM`, `ZM-CM`, `ZM-ROOT`, `ZM-CP*`). 7. Commits; `git status`. 8. Deviations /
NEEDS CLARIFICATION / items for the user. 9. Side effects.
