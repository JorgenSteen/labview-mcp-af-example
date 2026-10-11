# Brief 10b: ROOT hooks, launch methods, the routing override `ZM-CI-handlePackage`, `ZM-ROOT-root.lvlib`, Pre Launch Init and Handle Error
Type: build (LabVIEW calls, Actor Framework). Phase 10 step b of 5 (a: class, done; c: helperPanel; d: Actor Core, T7, launch proofs, Stop button; e: cleanup, icons, closing checks).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-10a-root-class.md`,
  then `report-09b-hwm-hooks-overrides.md` (the measured route for role hooks, shape F, the interface override, the
  library, PLI and Handle Error) and `report-08b-cm-hooks-overrides.md`.
  <<MANAGER: traps from report 10a go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**. D38, D39 as before.
- **D40** (`C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`, "Errors are not handled yet"): `ZM-ROOT-evaluateError.vi` is
  a PASS-THROUGH (class, `error in`, `stop actor? in` → out; no log), like the CM's and HWM's (copy the HWM's 09c
  source in `...\proof\ZMP-09c\`). `02` §7.12's "log, error passed on" is superseded.
- Every `lvai_*`/`pylv_*` call ALONE in its message (F9). `kit\lvproj_drop.py` empties an LF `.lvproj` (F10): check the
  ending, else `...\proof\ZMP-09a\lvproj_drop_eol.py`. Each project close may drop the `.lvproj` BOM: read the diff,
  restore from git with the project closed. Members with the same pane share ONE stub from `lvai_placeholder_subvi`:
  hand-make a distinct stub (`LVMCP Stub ZMP10b-<name>.vi`); a typedef cluster holding a class may be flattened to a
  scalar path (hand-make a stub). `lvai_swap_subvis` `constantsJson` finds top-level constants only (09c's derived
  `zmp09c_replace_constant_deep` for constants inside cases). AF overrides keep NI's help text: set their
  descriptions with `pa_replace_description` (project closed) at the end.

## Goal
On `ZM-ROOT-root.lvclass`, every remaining item of `02` §7.12 (lines 525-565) except `helperPanel` (step c) and
`Actor Core` (step d): hooks `createEvents`, `stop`, `close`, `createResources`, `evaluateError`, `launchCm`,
`launchHwm` (HOOK, private, static); `notePackageType`, `showError` (ST, private, static); the interface override
`ZM-CI-handlePackage.vi` (public, dynamic); the library `ZM-ROOT-root.lvlib` under `actors`; `Pre Launch Init.vi` and
`Handle Error.vi` (protected). Every member cold state 1 at the end. Also: the CM's `Handle Error.vi` DESCRIPTION
still describes D14: replace it with a D40 text by `pa_replace_description` (that one file, description only).

## Paths (absolute, long form)
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`; class
  `...\src\actors\ZM-ROOT-root\ZM-ROOT-root\ZM-ROOT-root.lvclass`; library `...\src\actors\ZM-ROOT-root\ZM-ROOT-root.lvlib`.
  AIXML `...\proof\ZMP-10b\`. Helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Called: AF `Launch Nested Actor.vi` (find by listing `vi.lib\ActorFramework\`); `Send ZM-CI-handlePackage.vi`;
  `ZM-CU-log.vi`; PC `Read type`, `Read destination`, `ZM-PC-getTypeName`, `ZM-PC-getDestinationName`,
  `ZM-PC-getDataAsJson`; EP class and its `Read data` (`ZM-PC-EP-DATA`: the sender field, read its name from the `.ctl`);
  FL `Write outputFolder`; UDP-sender class; MX `Write protocols`; `ZM-CM-writePrelaunchSettings`,
  `ZM-CM-PRELAUNCH_SETTINGS.ctl`; SIM class, `ZM-HW-hardware` class; `ZM-HWM-writePrelaunchSettings`,
  `ZM-HWM-PRELAUNCH_SETTINGS.ctl`. Proof sources to copy shapes from: `...\proof\ZMP-08c\` (launch proof: FL → MX →
  CM settings) and `...\proof\ZMP-09d\` (`Launch Actor`, HWM settings).
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\helper-loop.md` step 2, `ops\override.md`,
  `knowledge\actor-framework.md`, `knowledge\labview-mcp.md`, `kit\README.md`. Conventions `...\.labview\conventions\`
  (`af-shapes.md`: `launch-owner`, `prelaunch-settings`, `resources`, `pli-failure-cleanup`, `handle-error-order`;
  `errors.md`; `naming.md`; `layout.md`). Spec `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md`
  §7.12, §6; `01-requirements.md` R5 (the routing table), R8.

## What to build, in this order (commit each)
1. **Role hooks** as the HWM's (09b): `createEvents` (two `Create User Event`: Boolean `stop`, String `error` → one
   Bundle By Name → one `Write events`), `stop` (Generate `stop` T), `close` (Destroy ×2 → Clear Errors, merged with
   `error in`), `createResources` (shape F: `createEvents`; Error frame → `close`, original error first), and
   `evaluateError` (pass-through, D40). One `lvai_add_class_method` call where the panes allow, one swap call.
2. **`notePackageType`** (in `package`): `Read type` → `Write lastPackageType`; `Read packageCount` +1 → `Write`.
   **`showError`** (in `package`): `Read events` → Unbundle `error`; `getDataAsJson` → `Generate User Event`; cast to EP
   → `Read data` → sender = `"CM"` → `Write cmRunning` = F (a case).
3. **`launchCm`**, **`launchHwm`**: exactly the `02` §7.12 rows (FL with `outputFolder` from `prelaunchSettings`,
   UDP-sender defaults, both up-cast → Build Array → MX → CM settings → `ZM-CM-writePrelaunchSettings` → `Launch Nested
   Actor` → `Write cmEnqueuer`, `Write cmRunning` T; case on `usePlaceholderHardware`: SIM / bare HW → HWM settings
   `intervalMs` 500 → writePrelaunchSettings → `Launch Nested Actor` → `Write hwmEnqueuer`). Auto-stop as AF's default.
4. **`ZM-CI-handlePackage.vi`** (interface override, pane 4815, `package` on 10): case on `Read destination`:
   Communication → `notePackageType`; if `Read cmRunning` → `Read cmEnqueuer` → `Send ZM-CI-handlePackage`. Root →
   ErrorPackage (by `Read type`) → `showError`; other types → `notePackageType`. Unknown, Hardware → `ZM-CU-log` with
   `ROOT\t0\tdropped <getTypeName> for <getDestinationName>`, not an error. After it: cold sweep, the type-8 break gone.
5. **Library** under `actors` (as 09b step 4). 6. **PLI** (`createResources` B-after) and **Handle Error** (Call Parent
   → `evaluateError` E-after), as the HWM's; `pa_save_member` after each; export; then descriptions (D40 texts) on
   both overrides and on the CM's `Handle Error.vi`.
7. **Checks** (project closed): cold sweep of the class folder (every VI 1, control `0 7`), membership, versions 26,
   links: the ROOT may link to SIM, FL, UDP, MX, CM, HWM; nothing else under `src\` may link to the ROOT (the
   dependency rule of `02` §1: only the root references SIM/FL/UDP/MX). Scopes from the XML.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. No retry
  loops. Never launch an actor in this step (step d does).
- Closing a project: open yours first, pass projectPath. No hand edits of LabVIEW files (kit scripts only, project
  closed). AIXML with the Write tool. Nothing outside `src\actors\ZM-ROOT-root\`, the `.lvproj` and the CM's `Handle
  Error.vi` (description only) may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.12. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 75 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Each hook and ST: pane, route, state. 3. The routing override: the case
frames as exported. 4. Library; `.lvproj` `actors` lines. 5. The `ops\override.md` blocks. 6. Sweep, membership,
versions, links. 7. Commits; `git status`. 8. Deviations / NEEDS CLARIFICATION; items for the user in the IDE.
9. Side effects.
