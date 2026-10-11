REPORT 12a: the acceptance runs of 03 §2, then T1-T7. **DONE, with one FAIL (R-pli-failure: the root tree hangs).** 2026-10-11, 20:18 to 20:30. No NEEDS CLARIFICATION. No CANNOT PROCEED. 38 LabVIEW calls, each sent alone in its own message. Evidence: `zuehlke-mcp-af-test-results\proof\runs\12a-checks.txt`, one block per run.

**1. Status**
- Start: `lvai_status` ok, PID 26148, port 52603, 1.9.5-local, up 5141 s, dwarn 5. lv_windows: 0 dialogs, 10 hidden `LVMCP Validate*`, LVAutoSave 0. Project closed. Port 61557 free.
- End: same PID and port, up 5771 s, dwarn 5, not degraded. 0 dialogs. 14 unsaved windows, all hidden `LVMCP Validate*` (generator). Project closed.
- **The ROOT helperPanel panel is still open and running** (the hung tree, run 8 below).
- LabVIEW starts: 0. No restart, no kill, no dialog answered, nothing aborted.

**2. Runs**
1. **R-normal ×3: PASS.**
   - Readings: `lines_written` 10/10/10; `error_lines` 0; `ui_errors` ""; `error out` 0; 6463/6457/6468 ms.
   - `last_line` each time: TestPackage, `"destination":"Communication"`, five data fields.
   - After each run: no ROOT or HWM panel. ROOT helperPanel, ROOT Actor Core, HWM helperAcquisition, HWM Actor Core and CM Stop Core all read 1 cold (control `0 7`).
2. **R-error: pass under D40.**
   - Readings: `lines_written` 0, `last_line` "", `error_lines` 0, `ui_errors` "".
   - `error out` 1556, from Priority Enqueue.vi → ZM-launcher_test.vi: the Normal Stop to a root that is already gone.
   - 6477 ms, no hang. No output files and no panels afterwards; cold states 1.
   - Not measured: "stops by itself within about a second". The launcher has no timer; 09d measured 559/642 ms for the cascade.
3. **R-interactive: PASS.**
   - `src\ZM-launcher.vi` returned in 672 ms with error 0. Both panels were visible.
   - Lines grew from 9 to 29 in 9.7 s (2.06/s). HWM `interval measured (ms)` read 500 (state 3).
   - Root `Stop` pressed by a signalling write: matched 1, error 0. Lines read 30, then 30 again 3 s later.
   - Both panels closed. Both loop VIs answer 1004 (not in memory).
4. **R-receiver: PASS** (proof VI `ZMP-12a-receiver.vi`, 13.0 s).
   - Tree launch 0. `ZM-receiver.vi` started with Run VI (Wait Until Done F), error 0.
   - After 3 s: receiver state 2. `last line` = TestPackage with `"destination":"Communication"`. `packets` 6, then 8 one second later. `interval measured (ms)` 499.
   - Stop pressed by a signalling write: matched 1, error 0. 1.5 s later the receiver reads state 1 and its `error out` is 0.
   - The tree kept running: lines 15, then 19 two seconds later. Normal Stop answered **0**; a second one answered 1556.
   - Port 61557 was free before and after.
5. **R-viewer: PASS (offline).** The 3 R-normal copies and the R-interactive copy (10/10/10/30 lines) were checked with Python's json module:
   - every line parses;
   - keys are exactly timestamp/type/destination/data;
   - every timestamp matches the 03 pattern;
   - every data object has 5 fields.
   - The user opens `tools\jsonl_viewer.html` later.
6. **R-close-order: pass on the dataflow proof (order not timed).**
   - Timing it without touching `src\` is not possible. The loop VIs read state 3 until the whole actor hierarchy ends, and the Actor Cores are clones.
   - Exports (ROOT: `proof\ZMP-10d`; HWM: `proof\ZMP-09d`): `close` is fed only by Merge(loop error out, stop-frame error), and `error out` = Merge(Call Parent, close). The same holds for both actors.
   - R-pli-failure shows the converse: the loop never exited, so `close` never ran.
7. **R-stop-reset: PASS.**
   - `ZMP-12a-stop_reset.vi` is a file copy of the 09d proof; it reads 1 cold.
   - Lines: 6 after HWM#1, 12 in total (6 + 6).
   - Every launch and stop code 0. ack1 timed out T. CM Last Ack 0. 8456 ms.
8. **R-pli-failure: FAIL.**
   - Route: proof VI `ZMP-12a-pli_failure.vi`. The ROOT has `outputFolder` = `output\test_bad<>|_127563400` and is launched with Launch Actor and a proof-owned caller queue.
   - Launch 0. **No Last Ack within 5000 ms.** The Normal Stop 1 s later answered 0, so the queue still existed. No folder was created and nothing was logged.
   - Afterwards: the ROOT helperPanel stays visible in state 3 with `errors` "". HWM helperAcquisition reads state 3, panel closed, interval 0, so it was not launched.
   - Pressing the root `Stop` by a signalling write (allowed by the go-ahead): matched 1, error 0, and **no effect**. helperPanel's Stop only sends Normal Stop to its own message loop, which has already ended.
   - **The tree is hung and stays in memory.** "Nothing hangs" does not hold, and the CM's error code cannot be observed.
   - What this does not prove: the ROOT's own `createResources` failure, which was not injected.

**3. T1-T7** (project closed; LabVIEW not strictly cold, because the hung ROOT tree is in memory)
- T1 packages, T2 log, T3 hardware, T5 udp (61557 free), T6 pipeline, T7 routing: all PASS, Pass T, error 0.
- **T4 protocol ×5:** all PASS. `init_ok` T, T, T, T, T. No failure, so no `test_fl` folder was kept as failure evidence.

**4. Defects found**
- **(D-a) The ROOT hangs when a nested launch fails** (owner: phase 10, ROOT Actor Core and helperPanel; the shape comes from 09/10, D40).
  - What was seen: Call Parent gets the launchCm error and returns, but the helperPanel never gets the stop user event.
  - Probable cause (not proven): ZM-ROOT-stop fires the stop event before helperPanel has registered for it. helperPanel opens its panel first.
  - Effect: `close` never runs, there is no Last Ack, and neither Normal Stop nor the Stop button frees the tree.
  - The same race is possible in the HWM, but it was not seen.
- **(D-b) A PLI failure under the root is invisible.** No log line, no `ui_errors`, and no Last Ack reaches the caller. This is consistent with D40 (pass-through), but the R-pli-failure code is not reportable.

**5. Side effects**
- **A hung ROOT tree is in LabVIEW:** the helperPanel panel is open and the actor clones are running.
  - Clearing it needs a LabVIEW restart. The hidden `LVMCP Validate*` VIs will raise a save dialog on close, so the user must do it (no kill go-ahead).
- **Project opened and closed once** to build the two proof VIs.
  - The close adopted both VIs into the `.lvproj`. `lvproj_drop.py` removed both lines, after the F10 check (CRLF and BOM kept).
  - The `.lvproj` sha1 is identical to the start (d472b3a7). The close also rewrote the git-ignored `.aliases`/`.lvlps`.
- **Nothing in `src\` changed. No re-saves. Nothing committed.**
- **Proof files** (git-ignored), all in `proof\ZMP-12a\`: the AIXML and VIs of the two proof VIs, the stop_reset copy, 4 JSONL copies and `lvproj-before.lvproj`.
- **Output** (git-ignored):
  - New folders: `test_rx_127532422` (19 lines), `test_hwm_reset_127273307` (12), `test_fl_1276881xx`–`1276987xx` ×5, `test_pipeline_127705903/4`.
  - `test_mx_a`/`test_mx_b` were rewritten.
  - The R-interactive run left `output\TestPackage.jsonl` (30 lines).
  - `output\ZM-error_log.txt` now holds 4 lines from T2 and T7.

**6. git status --short**
- `?? runs/run-01-2026-10-10/lessons-mcp-skill.md` and `?? runs/run-01-2026-10-10/notes-for-run-02.md`: not mine. Nothing else.
