# Brief 10c: the ROOT panel loop `ZM-ROOT-helperPanel.vi` (one event loop: Stop button, `error` and `stop` user events)
Type: build (LabVIEW calls, Actor Framework helper loop). Phase 10 step c of 5 (a, b done; d: Actor Core, T7, launch proofs, Stop button; e: cleanup, icons, closing checks).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-10b-root-hooks-routing-overrides.md`,
  then `report-09c-hwm-helper-loop.md` (the MEASURED route for a loop VI with the event structure inside a case frame
  inside the loop: derived helpers, the use-default tunnel flag, event specs, panel on call) and `report-09d-...`.
  <<MANAGER: traps from report 10b go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**. D38: `Helpers` placement by the user.
- **D40** (`C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`, "Errors are not handled yet"; the user's words): this VI has
  ONE loop, so no local `stop` Boolean ("the local stop is only needed in cases where you have an additional loop").
  After the event loop: `ZM-ROOT-stop` (Generate the stop event) → its error into `Clear Errors.vi` ("add a send stop
  event after the user event loop too, just add ignore error"). After that: Merge Errors → `evaluateError`
  (pass-through, `stop actor?` unwired) → on an error `Read Self Enqueuer` → `Send Normal Stop`; `error out` = the RAW
  merged error.
- Every `lvai_*`/`pylv_*` call ALONE in its message (F9). F10 (`lvproj_drop.py` on LF) and the BOM restore as before.
  Never run the loop VI by itself (it waits for a stop event; a hung loop needs a LabVIEW restart).

## Goal
`ZM-ROOT-root.lvclass:ZM-ROOT-helperPanel.vi`, private static member, exactly as `02` §7.12 (row `ZM-ROOT-helperPanel`)
and `01` R8 (the Stop button) and R9 say, with D40 above. Cold state 1. NOT here: Actor Core, any launch.

## Paths (absolute, long form)
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; member path
  `...\src\actors\ZM-ROOT-root\ZM-ROOT-root\ZM-ROOT-helperPanel.vi`. AIXML and throwaways `...\proof\ZMP-10c\`.
- Derived helpers of 09c (copy, do not edit in place): `...\proof\ZMP-09c\zmp09c_wire_dyn_deep.xml`,
  `zmp09c_set_use_default.py`, `zmp09c_replace_constant_deep*`; the HWM loop's AIXML and export in `...\proof\ZMP-09c\`
  are the template. Kit: `<skill>\kit\set_user_event_specs.py`, `pa_set_panel_on_call.xml`, `pa_read_panel_on_call.xml`,
  `pa_set_mechanical_action.xml`, `pa_read_boolean.xml`. `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`;
  follow `ops\helper-loop.md` steps 3-10 (variant 1 plus a static Value Change frame).
- Spec `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.12; `01-requirements.md` R8, R9.

## What to build
- **Pane:** `ZM-ROOT-root in` (a copy, not returned), `error in`, `error out`. Panel shown when called, closed after.
- **Panel:** `Stop` (Boolean, **Switch When Released**, mechanical action 1 by `pa_set_mechanical_action`), `errors`
  (String, multi-line).
- `Read events` → Unbundle `stop`, `error` → Register For Events (both user events; fresh no error) → loop with the
  error case (shift register); No Error frame: event structure with three frames: **`Stop` Value Change** (static) →
  `Stop` = F by local IN THAT FRAME → `Read Self Enqueuer` → `Send Normal Stop`, keep looping; **`error`** → append the
  event data string to `errors` (a newline between entries; `lvai_set_event_data_fields` for the payload); **`stop`** →
  exit. No Timeout frame unless the tool needs an empty one. Right-side refnum → Unregister → Merge. Then the D40 tail.
- Event specs: the skill's measured rows for a root panel were `0:error:2 2:stop:1` (frame index : element :
  Register position); read `--check` first and use the rows of YOUR document.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. No retry
  loops. Unmeasured steps are proven on a throwaway in the proof folder first.
- Closing a project: open yours first, pass projectPath. No hand edits of LabVIEW files (kit scripts only, project
  closed). AIXML with the Write tool. Nothing outside `src\actors\ZM-ROOT-root\` and the `.lvproj` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.12. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 70 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The `ops\helper-loop.md` report block, filled. 3. What differed from the
09c route and what each new step answered (the static frame, the event data field, the Stop local). 4. The export:
Register/Unregister, frames, the local, the D40 tail. 5. Panel on call, `Stop` action, read back cold. 6. Sweep,
membership, versions, links. 7. Commits; `git status`. 8. Deviations / items for the user. 9. Side effects.
