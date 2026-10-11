# Brief 10d: ROOT Actor Core, the test T7 `ZM-TST-routing.vi`, two launch proofs and the Stop button
Type: build + test (LabVIEW calls, Actor Framework runs). Phase 10 step d of 5 (e: cleanup, icons, closing checks).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-10c-root-helper-panel.md`,
  `report-10b-root-hooks-routing-overrides.md`, `report-09d-hwm-actor-core-proof-close.md` (Actor Core shapes A, D and
  D-close with the derived `...\proof\ZMP-09d\zmp09d_close_join.xml`; the launch-proof route), `report-06-pipeline-test.md`
  (how a test VI joins `ZM-TST-tests.lvlib` and `checks.json`).
- State (report 10c, 2026-10-11 ~19:26): LabVIEW **PID 26148, port 52603**, dwarn 4, project CLOSED, 0 unsaved, no
  dialog. ROOT 25 VIs, all cold state 1. `helperPanel` (private, static, panel shown on call): frames `<error>` (append
  to `errors`), `"Stop"` Value Change (Stop = F by local → Send Normal Stop to self, keep looping), `<stop>` (exit);
  `Stop` is Switch When Released (action 1) and visible; D40 tail after the loop. `launchCm`/`launchHwm` exist (10b);
  Actor Core runs them in series BEFORE Call Parent on class and error (an error goes into Call Parent).
- **Broken wire first** (the user's rule, `orchestration\plan.md`): a VI at cold state 0 with a broken-wire text after a
  generate, swap or bind gets the kit's `pa_clean_member` (Remove Bad Wires + save; project open and active) BEFORE any
  rebuild. 10b lost five rebuilds and a LabVIEW kill to one leftover wire segment.
- **No kill:** the user's one kill go-ahead is used up. The validator's hidden `LVMCP Validate*` VIs make any LabVIEW
  close raise a save dialog; if a restart becomes necessary (a hung proof), stop and report.
- `lvai_bind_typedef_constants` needs the QUALIFIED subVI name (bare name: misleading 1055). 08c/09d proof VIs: build
  with the project open, swap, bind the settings seeds, run with the project closed; a proof that launches the ROOT
  also opens the HWM live panel and the ROOT panel (both close after; check with `lv_windows.ps1`).
- The Stop-button run: the root panel's `Stop` is Switch When Released; a SIGNALLING value write fires the Value
  Change event (`01` R8). Read the VI Server spellings for `Open VI Reference`, `Front Panel` → `Controls[]` / `Get
  Control by label` and `Value (Signaling)` from `resource\lvserver.rsc` or an NI shipped VI, never by a probe.
- Session 3 (2026-10-11) user go-ahead: "Continue run-01. You may restart LabVIEW when needed; agents may too." Max
  two starts, each reported. Never answer a dialog. Save version **26.0**.
- **D40**: errors cascade through the Last Ack; no Handle Last Ack Core override. Every `lvai_*`/`pylv_*` call ALONE in
  its message. `kit\pa_close_join.xml` is broken for our hooks (F12): use the derived 09d copy. F10 and the BOM restore
  as before. Proof VIs run with the project CLOSED; every proof VI RETURNS by itself; each writer its own log file.

## Goal
(1) `Actor Core.vi` on the ROOT (protected): series `launchCm` → `launchHwm` on the class and error wires BEFORE Call
Parent (an error goes into Call Parent and stops the root); `helperPanel` branched from `<C> in` (shape A); `stop`
after Call Parent (shape D); `close` after Merge(panel, stop) (shape D-close); error out = Merge(Call Parent, close)
(`02` §6, §7.12). (2) `src\tests\ZM-TST-routing.vi` (T7, `03` §1): calls ROOT's `ZM-CI-handlePackage` directly on a
ROOT object with packages for Hardware, Unknown, Communication; checks `hardware_dropped_ok`, `unknown_dropped_ok`,
`communication_not_dropped_ok`, `no_error_ok`, `Pass`; in `ZM-TST-tests.lvlib`, under the project's `tests` folder,
listed in `.labview\checks.json`; run cold: Pass T. (3) Launch proofs in the proof folder (never `src\`): Launch Root
Actor with `{outputFolder: <product>\output\test_root_<tick>, usePlaceholderHardware: F}`, wait 5 s, Normal Stop, wait;
expect 8-11 lines in that folder's `TestPackage.jsonl`, the error log unchanged, both panels closed, the run returns;
twice in a row. (4) The Stop button: the same launch, then a SIGNALLING write (`Value (Signaling)`) to `Stop` of the
running `ZM-ROOT-root.lvlib:ZM-ROOT-root.lvclass:ZM-ROOT-helperPanel.vi` (Open VI Reference by qualified name, the
way `02` §8 `ZM-launcher_test.vi` reads `errors`); the tree stops by itself, the proof's later Normal Stop answers
1556. Property spellings only from `resource\lvserver.rsc` or NI helpers; never probe with `lvai_validate_aixml`.

## Paths
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`; ROOT
  folder `...\src\actors\ZM-ROOT-root\ZM-ROOT-root\`; tests `...\src\tests\`; `...\.labview\checks.json`; proof
  `...\proof\ZMP-10d\`; evidence `...\proof\runs\10d-checks.txt`; error log `...\output\ZM-error_log.txt`.
- Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview`: `ops\override.md`, `ops\helper-loop.md` step 11,
  `ops\run-checks.md`, `knowledge\actor-framework.md`. Spec `...\requirements\02-specification.md` §6, §7.12, §8;
  `03-acceptance.md` T7; `01-requirements.md` R8 (Stop button).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- LabVIEW restarts: as UPDATES says. A modal dialog: `lv_windows.ps1`, stop that chain, never answer it. A proof VI that
  does not return within its timeout: stop, `lv_windows.ps1`, report; never abort an actor by VI Server.
- Proof VIs only in the proof folder, never in the product project. No hand edits of LabVIEW files. In `src\` only the
  ROOT folder, `src\tests\` (T7 and the test library) and the `.lvproj` may change; `checks.json` gains one entry.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop.

## Report (max 75 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The Actor Core `ops\override.md` block and its export. 3. T7: the VI,
membership, checks.json entry, the cold run readings. 4. Launch proofs 1 and 2: lines, codes, error-log lines,
durations, panels. 5. The Stop button run: route, readings. 6. Sweep (ROOT + tests), versions, links. 7. Commits;
`git status`. 8. Deviations / NEEDS CLARIFICATION / items for the user. 9. Side effects.
