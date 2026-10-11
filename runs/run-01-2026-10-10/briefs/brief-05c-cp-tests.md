# Brief 05c: `ZM-TST-udp.vi` (T5) run until Pass, and `mx_placeholder_ok` added to `ZM-TST-protocol.vi` (T4 complete)
Type: build + test (LabVIEW calls). Phase 05 step c of 4 (a: UDP, b: MX done; d: cleanup, icons, sweep).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-05a-cp-udp.md`,
  `report-05b-cp-mx.md` (what exists, the probe readings, terminal names), `report-04b-cp-fl-test.md` (T4 as built,
  its AIXML source in `proof\ZMP-04b\`), `report-03b-hw-sim-test.md` (item 5: a test VI over several libraries by
  the direct route with class-constant seeds swapped by `constantsJson`).
- Facts from reports 05a2 and 05b (2026-10-11): sender `ZM-CP-UDP-sender` (defaults 127.0.0.1:61557, no Write for
  address/port), receiver `ZM-CP-UDP-receiver` (`Write localPort` public; `ZM-CP-UDP-receive` public: in `timeout_ms`
  I32; out `json`, `timed_out`), MX `ZM-CP-MX-multi_protocol` (`Write protocols` public, value terminal
  `ZM-CP-MX-PROTOCOLS`, an array of `ZM-CP-communication_protocol`). Read every pane with `lvai_vi_terminals` before
  wiring. Measured probe sources: `proof\ZMP-05a\ZMP-05a-probe.xml` (sender init/publish/close) and
  `proof\ZMP-05b\ZMP-05b-probe.xml` (MX with [parent] and with []): copy their call spellings. An array of class
  constants for `Write protocols` is built with `Build Array` of up-cast class constants (each FL constant after
  `Write outputFolder`); a stub for an array-of-class terminal is a scalar `path`, so make that stub by hand with
  `array{path}` (05b did: `LVMCP Stub ZMP05b-writeProtocols.vi`, source in `proof\ZMP-05b\`).
- Note for `mx_ok`: the MX `close` after a clean `init` and `publish` must read 0; the files are checked after it.
- The one-call rule was broken twice in a row by offline calls (`lvai_check_aixml`, `pylv_extract`): every
  `lvai_*` and `pylv_*` call, offline ones included, goes alone in its message.
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D39: icons without a prompt (step d).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib`; `Match Regular Expression` is not
  authorable; `Equal?` on clusters is element-wise; a test VI's panel comes back whole from the runner (keep it
  small); **port 61557 must be free**: before T5, check offline with PowerShell
  `Get-NetUDPEndpoint -LocalPort 61557` (no LabVIEW call); if something holds it, report it and do not run T5.
- **Regenerating a test VI** (`ZM-TST-protocol.vi`): a regeneration from AIXML discards its Clean Up Diagram and icon
  (04c made them): step d redoes both for it; say so in the report. Keep its membership in `ZM-TST-tests.lvlib`
  (re-add with `lvai_add_to_library` if the regeneration drops it; `check_membership.py`).

## Goal
(1) `ZM-TST-udp.vi` (T5) in `ZM-TST-tests.lvlib`, run cold until `Pass` true. (2) `ZM-TST-protocol.vi` regenerated from
its 04b source plus the `mx_placeholder_ok` check, `Pass` = AND of all seven, run cold until `Pass` true. No
production code changes unless a run proves a phase-05 VI at fault (then fix it, this phase's code, and say so).

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Tests: `...\src\tests\ZM-TST-udp.vi` (new), `...\src\tests\ZM-TST-protocol.vi` (regenerate; source
  `...\proof\ZMP-04b\ZM-TST-protocol.xml` or whatever 04b named it), `...\src\tests\ZM-TST-tests.lvlib`.
- Classes: `...\src\protocol\ZM-CP-UDP-udp_transport\ZM-CP-UDP-sender\`, `...\ZM-CP-UDP-receiver\`,
  `...\src\protocol\ZM-CP-MX-multi_protocol\ZM-CP-MX-multi_protocol\`, `...\src\protocol\ZM-CP-FL-file_logger\...`,
  `...\src\protocol\ZM-CP-communication_protocol\...`; packages `...\src\common\ZM-PC-packages\...`.
- T5's MX folders: `...\zuehlke-mcp-af-test-results\output\test_mx_a\` and `...\output\test_mx_b\` (emptied first by the
  test: delete the two `TestPackage.jsonl` files if present, missing is not an error).
- AIXML sources `...\proof\ZMP-05c\`; evidence `...\proof\runs\05c-checks.txt`; helpers
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\run-checks.md`, `ops\sweep.md`,
  `knowledge\labview-mcp.md`, `kit\README.md`. Conventions `...\.labview\conventions\hygiene.md`, `naming.md`,
  `errors.md`; `checks.json` entries `ZM-TST-udp`, `ZM-TST-protocol`. Spec: `03-acceptance.md` T5 and T4
  (`mx_placeholder_ok`); `02-specification.md` §7.8, §7.9; `04-decisions.md` D24, D25.

## The tests
**T5 `ZM-TST-udp.vi`**, indicators exactly (`Pass` = AND of six, `error out`):
| indicator | proves |
|---|---|
| `rx_init_ok` | a receiver constant with `Write localPort` 61557 (the default anyway) on a `ZM-CP-communication_protocol` wire: `init`, no error |
| `roundtrip_ok` | a sender constant (defaults 127.0.0.1:61557): `init`; one TP (`ZM-PC-TP-create` with fixed data, `Write destination` = Communication) published through the sender; receiver `ZM-CP-UDP-receive(1000)`: `json` equals the same package's `getDataAsJson` (string equality: the same object, so the timestamps match) and `timed_out` F |
| `timeout_ok` | `receive(200)` again: `timed_out` T, no error |
| `no_listener_ok` | receiver `close`; sender publishes twice: no error (codes 66/56 cleared) |
| `mx_ok` | an MX constant with `Write protocols` = `[FL(outputFolder = output\test_mx_a), FL(output\test_mx_b)]` (both `TestPackage.jsonl` deleted first): `init`, publish one TP, `close` → both files exist with 1 line that unflattens (header + data cluster) to the published data |
| `rx_publish_5000_ok` | `publish` on a receiver returns code 5000 (read from its own chain, not into `error out`) |
Then sender `close`. Order the chains so the receiver is open before the sender publishes (data flow through the
error wire or a sequence). Description on the VI.
**T4 complete**: regenerate `ZM-TST-protocol.vi` from its source with one more check `mx_placeholder_ok` (an MX
constant with `Write protocols` = `[bare ZM-CP-communication_protocol constant]`: `publish` returns code 5000, read
from its own chain) and `Pass` = AND of seven; description updated ("T4 complete: ... mx_placeholder_ok added in
phase 05").

## Route
1. `lvai_status`; project closed; `git status --short`; commit point; the port check (PowerShell, no LabVIEW).
2. T5: write the AIXML; generate by the direct route (project open with one member of each library opened through
   it: UDP, MX, FL, CP parent, PC); class-constant seeds swapped with `constantsJson`; cold state 1;
   `lvai_add_to_library` into `ZM-TST-tests.lvlib`; commit `test(cp): ZM-TST-udp.vi (T5)`.
3. T4: edit the 04b source (copy into `proof\ZMP-05c\`), regenerate over `src\tests\ZM-TST-protocol.vi` (commit
   first: git is the undo), swaps, cold state 1, membership kept or re-added; commit `test(cp): ZM-TST-protocol.vi
   with mx_placeholder_ok (T4 complete)`.
4. `ops\run-checks.md` for the entries `ZM-TST-udp` and `ZM-TST-protocol` (loadability, returns, cold runs,
   evidence file). Fix the tests when they are wrong (max three rounds each); a phase-05 VI at fault = fix it, re-run
   its owner's checks, commit, re-run; a `ZM-PC`/`ZM-CP-FL`/parent VI at fault = stop with the reading.
5. Cold sweep of `src\tests\` and `src\protocol\`; `check_membership.py`; `lv_save_version.py` (26); the two test
   VIs' links go only into `src\tests\`, `src\protocol\` and `src\common\ZM-PC-packages\`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\`, `src\hardware\` may change; `src\protocol\` only if step 4 proves a phase-05 VI at fault.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `03` T4/T5; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 55 lines), as your final message
1. `lvai_status` start/end; starts made; the port check. 2. T5 route; T4 regeneration route and membership.
3. The run-checks block for both tests (every indicator, rounds, fixes). 4. Sweep, membership, versions, links.
5. Commits; `git status`. 6. Deviations / VIs at fault / NEEDS CLARIFICATION. 7. Side effects (files the tests
wrote under `output\`, re-saves, helpers).
