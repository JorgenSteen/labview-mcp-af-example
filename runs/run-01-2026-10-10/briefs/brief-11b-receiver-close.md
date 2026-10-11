# Brief 11b: the UDP receiver `ZM-receiver.vi`, then cleanup, icons and the phase-11 closing checks
Type: build + test (LabVIEW calls). Phase 11 step b of 2 (last step of the phase).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-11a-launchers.md`,
  `report-05c-cp-tests.md` (T5: the UDP receiver class, `receive` with a timeout, the port 61557),
  `report-10e-root-cleanup-icons-close.md` (the latest cleanup and icon route).
- State (report 11a, 2026-10-11 20:04): LabVIEW PID 26148 (port 52603), dwarn 5, project CLOSED, 8 hidden
  `LVMCP Validate*`, no dialog. The two launchers are at the project root (`.lvproj` lines 39-40, URL `../ZM-...vi`),
  cold 1, by the direct route (project open with `ZM-ROOT-writePrelaunchSettings` opened through it, then
  `lvai_bind_typedef_constants` with the QUALIFIED name). A VI generated with the project open was adopted at the
  project root by the close: for the receiver, move it into the `receiver` folder with `lvproj_move.py` (F10 first).
- `ZM-launcher_test.vi` is a 40-stage chain (3692 px wide): Clean Up Diagram only, no subVI invented. Cleanup and
  icons cover the two launchers too (top-level VIs: own icon layers, no class template). Run 1 deleted and rewrote
  `output\ZM-error_log.txt` and `TestPackage.jsonl` (git-ignored): expected.
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. NO kill. Never answer a dialog. Save version 26.0. D39: icons without a prompt.
- **Broken wire first** (`pa_clean_member` before any rebuild). One call per message (F9). F10, BOM restore as before.

## Goal
`src\receiver\ZM-receiver.vi` exactly as `02` §8 (row `receiver/ZM-receiver.vi`) and `01` R9: a plain top-level VI, not
an actor, in no library, under the project's `receiver` virtual folder; depends ONLY on `ZM-CP-UDP`, `ZM-CP` and `ZM-PC`
(checked from the files). Controls `port` (U16, 61557), `Stop` (Switch When Released, `pa_set_mechanical_action` 1);
indicators `chart` (waveform chart, plots `temperature_c`, `duty_percent`: the 09c plot-name helper
`...\proof\ZMP-09c\zmp09c_set_plot_names.xml`), `interval measured (ms)` (Tick Count difference between two packets),
`last line`, `packets` (U32), `error out`. Body: UDP-receiver constant → `Write localPort` → `ZM-CP-init` → while:
`receive(1000)` → timed out: keep waiting; data → `Unflatten From JSON` into `ZM-PC-HEADER.ctl` (not strict) →
TestPackage? → `Unflatten From JSON` path `["data"]` into `ZM-PC-TP-DATA.ctl` → chart, interval, last line, packets +1;
exit on Stop or error → `ZM-CP-close`. Description per `hygiene.descriptions`.
Test (no tree needed): a throwaway proof VI in `...\proof\ZMP-11b\` that sends two TestPackage JSON lines to the port
with the UDP-sender class is NOT enough, because the receiver only stops on its Stop button. Instead prove it cold
(state 1), prove the dependency list, and leave the live run to phase 12's R-receiver; say so.
Then **cleanup** (`ops\cleanup.md`) and **icons** (`ops\icons.md`) on the three phase-11 VIs (top-level VIs: own
icons, no class template), read back 0 px; **closing checks**: descriptions, versions 26, the `.lvproj` lists the two
launchers at the project root and the receiver under `receiver`, cold sweep of `src\` top level + `src\receiver\`, T1-T7
cold PASS once more. Final commit `feat: launchers and udp receiver` (an empty marker if all is committed).

## Paths
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`;
  receiver `...\src\receiver\ZM-receiver.vi`; AIXML `...\proof\ZMP-11b\`; evidence `...\proof\runs\11b-checks.txt`.
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\cleanup.md`, `ops\icons.md`, `ops\sweep.md`,
  `ops\run-checks.md`, `knowledge\labview-mcp.md`. Spec `...\requirements\02-specification.md` §8; `01` R9.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. Never run the
  receiver (it loops until its Stop is pressed).
- No hand edits of LabVIEW files. In `src\` only the receiver, the two launchers (cleanup and icons only) and the
  `.lvproj` may change. Commit by explicit paths, Conventional Commits, no attribution trailer. Never push.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The receiver: route, panel, Stop action, plot names, cold state, links.
3. Cleanup and icon blocks. 4. Closing checks with the T1-T7 readings. 5. Commits; `git status`. 6. Deviations;
items for the user. 7. Side effects.
