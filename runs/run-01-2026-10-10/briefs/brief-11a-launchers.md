# Brief 11a: the top-level launchers `ZM-launcher.vi` (interactive) and `ZM-launcher_test.vi` (headless)
Type: build + test (LabVIEW calls, Actor Framework runs). Phase 11 step a of 2 (b: the UDP receiver, cleanup, icons, closing checks).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-10d-root-actor-core-t7-proofs.md`
  (the ROOT launch proofs and the Stop-button route: Open VI Reference by qualified name, the control reads),
  `report-10e-root-cleanup-icons-close.md`, `report-02a-cu-log-test.md` (a top-level VI calling library members by the
  direct Call route).
  <<MANAGER: traps from reports 10d and 10e go here before launch>>
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. NO kill (the user's one kill go-ahead is used up). Never answer a dialog. Save version 26.0.
- **D40** (`C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`, "Errors are not handled yet"): every `evaluateError` is a
  pass-through; an error stops its actor and cascades to the whole tree. So the placeholder run
  (`use_placeholder_hardware` T) can NOT give the card's / `03` R-error readings (`error_lines` 1, `ui_errors` holding
  an error package). Expected under D40: the tree stops by itself with 5000 within about a second; the launcher still
  returns; `lines_written` 0; `error_lines` 0; `ui_errors` empty or unreadable (the panel loop has ended); `error out`
  may carry the error of the post-stop calls. Build the launcher EXACTLY as `02` §8 says (no extra error handling),
  run it, and report the readings as they are; the manager judges them against D40.
- **Broken wire first:** a VI at cold state 0 with a broken-wire text after a generate, swap or bind gets the kit's
  `pa_clean_member` (Remove Bad Wires + save) before any rebuild (`orchestration\plan.md`). One call per message (F9).
  F10 (`lvproj_drop.py` on LF) and the BOM restore as before. A launcher run while a project is open is adopted into
  it: run with the project CLOSED, after adding the VI to the project.

## Goal
`src\ZM-launcher.vi` and `src\ZM-launcher_test.vi` exactly as `02` §8 (rows `ZM-launcher.vi`, `ZM-launcher_test.vi`):
top-level, in no library (D36), listed at the project's ROOT level (not in a virtual folder; `02` §8 and §9), with
descriptions. `ZM-launcher.vi`: control `output_folder` (Path; empty = `<project folder>\output`, the folder holding
`src\`, found from the VI's own path with `Strip Path`), bundle `ZM-ROOT-PRELAUNCH_SETTINGS` (`usePlaceholderHardware`
F) → `ZM-ROOT-writePrelaunchSettings` → `Launch Root Actor` (Open Actor Core front panel? F) → done.
`ZM-launcher_test.vi`: controls `run_time_ms` (U32, 5000), `output_folder`, `use_placeholder_hardware` (Boolean, F);
indicators `lines_written` (I32), `last_line` (String), `error_lines` (I32), `ui_errors` (String), `error out`; body as
`02` §8 (delete `TestPackage.jsonl` and `ZM-error_log.txt`, missing is not an error → settings → write → Launch Root
Actor → Wait `run_time_ms` → read `errors` from the running `ZM-ROOT-root.lvlib:ZM-ROOT-root.lvclass:ZM-ROOT-helperPanel.vi`
→ `ui_errors` → Send Normal Stop → Wait 1000 → count lines in both files, missing counts 0 → last line).

## Runs (project closed; evidence `...\proof\runs\11a-checks.txt`)
1. `ZM-launcher_test.vi` defaults: expected `lines_written` 8-11, `last_line` a TestPackage with `"destination":
   "Communication"`, `error_lines` 0, `ui_errors` empty, `error out` 0; `lv_windows.ps1` afterwards: no ROOT/HWM panel.
2. `use_placeholder_hardware` T: report every indicator as read (D40 above); no hang.
3. `ZM-launcher.vi` is interactive (the tree runs until Stop): do NOT run it here; check it cold (state 1) only.

## Paths
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`; AIXML
  `...\proof\ZMP-11a\`. Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`ops\run-checks.md`,
  `knowledge\labview-mcp.md`, `knowledge\actor-framework.md`). Spec `...\requirements\02-specification.md` §8, §9;
  `01-requirements.md` R10; `03-acceptance.md` §2; `04-decisions.md` D7, D25, D28, D36.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. A run that
  does not return within its timeout: stop, `lv_windows.ps1`, report; never abort an actor by VI Server.
- No hand edits of LabVIEW files. In `src\` only the two launcher VIs and the `.lvproj` may change.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop.
  Names only from `02` §8. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Each VI: route, pane, panel, description, cold state, project item.
3. Run 1 and run 2 readings, durations, panels afterwards. 4. Versions, links (the launchers link only to the ROOT,
its settings typedef and AF). 5. Commits; `git status`. 6. Deviations / NEEDS CLARIFICATION. 7. Side effects.
