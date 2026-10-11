# Report 06: ZM-TST-pipeline.vi (T6), all six tests rerun, cleanup and icon (2026-10-11 10:30-10:39)

**DONE.** T6 passes cold. It took two rounds: the first build was eBad because of a fault in the test, fixed in the test only. All six tests (T1-T6) PASS. No class from phases 01-05 is at fault, and no production VI was touched. No NEEDS CLARIFICATION. I made 35 LabVIEW calls, every one alone in its own message, offline ones included.

1. **Status, starts, port**
   - `lvai_status` at the start: ok, port 59552, PID 14040, up 68767 s, 1.9.5-local (f9ee41d9), dwarn 0. At the end: same, up 69301 s, dwarn 0.
   - LabVIEW starts made: 0. No dialogs (`lv_windows.ps1`: possible dialogs 0; the unsaved windows are the tool's hidden Validate pairs). The project is closed.
   - Port 61557: free at 10:30 and again right before T5.

2. **T6 route**
   - AIXML is `proof\ZMP-06\ZM-TST-pipeline.xml`, written with the Write tool; `check_aixml` 0/0.
   - Loop 1: a For loop with `maxin` = 10. Shift registers carry the HW wire, the CP wire and the error. Inside: `do`, then a Case on the error: No Error → `publish`, Error → pass through. The loop's conditional terminal is the error status.
   - Loop 2: the same with the bare `ZM-HW-hardware`, plus a publish counter on a shift register and the final `i`.
   - Checks: TestPackage.jsonl must have exactly 10 LF. Each of the 10 lines is unflattened twice, with strict validation and two different sets of defaults, and the two data clusters must match; that proves all 5 data fields are present. `List Folder *.jsonl` checks the second folder. Its terminal spelling came from NI's `List Directory and LLBs.vi` export.
   - Build: direct route, project open with Write outputFolder, CP init and HW init opened. All 7 call targets resolved. Four seeds swapped with `constantsJson`. The export shows SIM `do` in loop 1, the parent's `do` in loop 2, and FL init/publish.
   - **Round 1:** cold eBad. `vi_nets.py` showed the cause offline: Equal? on the two data clusters came out in Compare Elements mode, giving a Cluster into a Boolean Build Array.
   - **Fix (round 2):** Equal? → Cluster To Array → And Array Elements, the shape T5 uses.
   - Regeneration: I avoided 1357 by `git checkout` of the uncommitted `.lvlib` with the project closed. Then regenerate, swap, cold state 1, re-add with `lvai_add_to_library`, cold state 1.
   - Commit 558726e `test: pipeline without actors`.

3. **Run-checks** (evidence in `proof\runs\06-checks.txt`)
   - T6 before its run: loadable 1, unresolved 0; it returns (only For loops).
```
checks named  tests 6/6 pass  runs 0/0  project closed  calls 6
ZM-TST-pipeline  PASS  Pass=T  error 0  pipeline_ok T  error_stops_ok T  (160 ms; round 2, fix above)
ZM-TST-packages  PASS  Pass=T  error 0  (all 10 checks T, 69 ms)
ZM-TST-log       PASS  Pass=T  error 0  file_ok T order_ok T timestamp_ok T (31 ms)
ZM-TST-hardware  PASS  Pass=T  error 0  sim_ok T sim_destination_ok T ranges_ok T varies_ok T placeholder_ok T (70 ms)
ZM-TST-protocol  PASS  Pass=T  error 0  init/files/lines/append/placeholder/close/mx_placeholder_ok all T (131 ms)
ZM-TST-udp       PASS  Pass=T  error 0  rx_init/roundtrip/timeout/no_listener/mx/rx_publish_5000_ok all T (349 ms)
failures: none
```
   - Read back offline: `test_pipeline_92206171\TestPackage.jsonl` has 10 LF, 0 CR, and 10 lines of TestPackage/Communication with the 5 data keys. `test_pipeline_92206172\` is empty.

4. **Cleanup and icons**
   - **Cleanup:** 1 VI, start HEAD 558726e, 1 batch, code 0. Version 26 before and after. Git showed only the `.vi`. Sweep before and after: 1/1 state 1, control `0 7`. Panel checks: none needed. Commit d85a5f9.
   - **Icon:** `make_icons --check` exit 0, generate exit 0. Owner `tests`, no template, composite only (D39, no prompt). `lvai_set_vi_icon` verified. Kit read-back 1/1, `pixcmp --tree` 0 px of 1024. Version 26. Commit f6f5260.

5. **Sweep, membership, versions, links**
   - Cold sweep of `src\tests`: 6/6 state 1, control `0 7`.
   - `check_membership.py`: 6 checked, 0 not a member, exit 0.
   - `lv_save_version.py`: all 6 tests, the `.lvlib` and the `.lvproj` are 26.
   - Links (`--links --vilib`, exit 0): only `src\tests\ZM-TST-tests.lvlib`, the SIM and HW classes, and the FL class plus Write outputFolder. Nothing in `src\common`, `src\hardware` or `src\protocol` changed.
   - The description is set ("T6: the data path without actors…").

6. **Commits** (explicit paths, no trailer, not pushed): 558726e, d85a5f9, f6f5260. `git diff 75a1dce HEAD` touches only `ZM-TST-pipeline.vi` and the 1-line `ZM-TST-tests.lvlib` add. `git status --short` at the end: empty.

7. **Deviations and open points**
   - (a) T6 needed a second round; the fault was in the test only (item 2).
   - (b) Each of the three project closes left `Zuehlke MCP.lvproj` modified, and I restored it with `git checkout`, project closed. Twice it was line endings only. Once, after the regeneration close, `git diff --stat` showed "1 insertion" and **I restored it without reading the line**. It was most likely a loose entry for the new VI, but that is not verified. The committed `.lvproj` is unchanged.
   - (c) T6's diagram is over budget: 3117x852 px, 32 stages, the serial chain the spec asks for, the same as T3, T4 and T5.
   - (d) One `lvai_convert_vi_to_aixml` failed with Error 7 because the `proof\ZMP-06\` folder did not exist yet (known trap); it was re-sent after the folder was made.
   - Class VIs at fault: none.

8. **Side effects**
   - Under `output\` (git-ignored):
     - New `test_pipeline_92206171\` (TestPackage.jsonl, 10 lines) and an empty `test_pipeline_92206172\`.
     - New `test_fl_92223081\` from T4.
     - `test_mx_a\` and `test_mx_b\` rewritten by T5.
     - Two T2 marker lines appended to `ZM-error_log.txt`.
   - `proof\ZMP-06\` and `proof\runs\06-checks.txt` (git-ignored). `proof\icons\` regenerated.
   - Read-back, lists and netlist in `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\06\`.
   - Helpers: all cached, none new. One installation VI export was added to the tool's cache.
