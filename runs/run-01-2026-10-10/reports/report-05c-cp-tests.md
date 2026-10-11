# Report 05c: ZM-TST-udp.vi (T5) and ZM-TST-protocol.vi with mx_placeholder_ok (T4 complete), 2026-10-11 10:04-10:16

DONE. Both tests pass cold in round 1. No production VI changed, and nothing under src\common, src\hardware or src\protocol was touched. No NEEDS CLARIFICATION. About 22 LabVIEW calls, each sent alone in its own message, `lvai_check_aixml` included.

1. **Status, starts, port**
   - `lvai_status` at the start: ok, port 59552, PID 14040, up 67208 s, 1.9.5-local (f9ee41d9), dwarn 0. At the end: ok, same port and PID, up 67799 s, dwarn 0.
   - LabVIEW starts made: 0. No crash, no dialog.
   - `lv_windows.ps1` at the end: no project window, LVAutoSave 0, 28 unsaved windows, all of them the tool's hidden `LVMCP Validate*` pairs.
   - Port check (`Get-NetUDPEndpoint -LocalPort 61557`): free at the start and again before each of the two T5 runs.

2. **Routes**
   - **T5:** AIXML at `proof\ZMP-05c\ZM-TST-udp.xml` (check_aixml 0/0). Direct route: project open and active, with one member of each library opened through it (receiver `Write localPort`, MX `Write protocols`, FL `Write outputFolder`, CP `ZM-CP-init`, `ZM-PC-TP-create`).
     - `lvai_generate_vi` resolved all 10 Call targets. The VI read eBad until the class seeds were swapped, as expected.
     - `lvai_swap_subvis` constantsJson swapped 6 seeds: rx, sender, fl a, fl b, the CP target of `To More Generic Class`, and mx. socketsLeft 0. The export shows the dispatch reaching the sender, receiver and MX overrides; the receiver's publish goes to the parent's.
     - `lvai_add_to_library` put it into ZM-TST-tests.lvlib. The close left no loose `.lvproj` entry. Cold state 1. Commit 53627a4.
   - **T4:** I copied the 04b source to `proof\ZMP-05c\ZM-TST-protocol-04b.xml` and wrote `ZM-TST-protocol.xml` from it with a script. Added: an `mx seed`, then Build Array of the bare seed → `Write protocols` → `publish` → code 5000 on its own chain → `mx_placeholder_ok`. `Pass` is the AND of 7. The description now starts "T4 complete: ... (mx_placeholder_ok added in phase 05 with the MX class)".
     - **First try failed (deviation, recovered):** generating over the path with the project open answered 1357. The loaded ZM-TST-tests.lvlib holds that path. `ZM-TST-protocol.vi` was not written (git confirmed).
     - **Recovery:** I tried to save the possible orphan with my own helper `zmp05c_save_orphan(2).vi`: first error 7, then 1004 (no VI of that name in memory). The project then closed normally, with no 1019.
     - **Route used:** with the project closed, `remove_members.py` took the member out of the `.lvlib`. Then project open, generate, swaps (4 constants), and `lvai_add_to_library` re-added it. The `.lvlib` ends with no net diff. Cold state 1. Commit a1e87f0.
     - This regeneration discarded 04c's Clean Up Diagram and icon on ZM-TST-protocol.vi. **Step d must redo both.**

3. **Run-checks** (evidence in `proof\runs\05c-checks.txt`). Loadability: 2/2, nothing unresolved. Returns: true (no loop or structure). Cold state 1 for both before running.
```
checks named  tests 2/2 pass  runs 0/0  project closed  calls 3  <1 min
ZM-TST-udp  PASS  Pass=T  error 0  rx_init_ok T  roundtrip_ok T  timeout_ok T  no_listener_ok T  mx_ok T  rx_publish_5000_ok T  (358 ms; run 2, files existing before, same readings, 851 ms)
ZM-TST-protocol  PASS  Pass=T  error 0  init_ok T  files_ok T  lines_ok T  append_ok T  placeholder_ok T  close_ok T  mx_placeholder_ok T  (141 ms)
failures: none   rounds 1 each, no fix; no phase-05, ZM-PC, FL or parent VI at fault
```
   - How T5 decides each check:
     - `roundtrip_ok`: received json equals the same package's `getDataAsJson`, AND `timed_out` is F, AND the receive has no error.
     - `mx_ok`: the MX close has no error; each file has exactly 1 LF; its line unflattens, and timestamp, type and destination equal the published package's JSON unflattened, with the data cluster compared element-wise (Cluster To Array → And).
     - The two `TestPackage.jsonl` files are deleted first; code 7 (missing) is cleared by a Select.
   - The second T5 run proved the delete path: each file again holds exactly 1 line.

4. **Sweep, membership, versions, links**
   - Cold sweep of src\tests plus src\protocol: 41 VIs, 41/41 state 1, control `0 7`, 2.5 s.
   - `check_membership.py`: 41 checked across 6 folders, 0 not a member.
   - `lv_save_version.py`: both tests, the `.lvlib` and the `.lvproj` are all 26 (`SaveVersion=26.0`).
   - `lv_loadability.py --links`: both tests link only into src\tests (ZM-TST-tests.lvlib), src\protocol and src\common\ZM-PC-packages. Files are in `proof\ZMP-05c\`.

5. **Commits** (explicit paths, no trailer, not pushed): 53627a4 `test(cp): ZM-TST-udp.vi (T5)`, a1e87f0 `test(cp): ZM-TST-protocol.vi with mx_placeholder_ok (T4 complete)`. `git diff dc015fa HEAD` touches 3 files, all in src\tests. `git status --short` at the end: empty.

6. **Deviations and open points**
   - (a) The 1357 on the T4 regeneration and the remove-and-re-add membership route in item 2. **Trap for later briefs:** a test VI that is already a member of a loaded library cannot be regenerated over its path. Remove the member with the project closed, regenerate, then re-add it.
   - (b) Two project closes rewrote the `.lvproj`: once the UTF-8 BOM was dropped, once a line-ending-only change. Both times I restored it with `git checkout` with the project closed.
   - (c) T5's diagram is over the size budget: 5498x630 px, a chain of 54 stages. T4's is 38 stages. These are the serial chains the spec dictates and no subVI may be invented; left for step d.
   - (d) I edited the rescue helper's AIXML once with `sed` (wiring the name string straight into Open VI Reference). The test AIXML was written with the Write tool and a Python script.
   - (e) VIs at fault: none.

7. **Side effects**
   - Under output\ (git-ignored): `test_mx_a\TestPackage.jsonl` and `test_mx_b\TestPackage.jsonl` (1 line each), and `test_fl_90776108\` with 3 JSONL files. The old `test_fl_49249178\` from 04b is still there.
   - Re-saves: `ZM-TST-tests.lvlib` (by add_to_library). Project opened and closed 3 times; the tool's close sweep removed my 2 rescue helpers from the `.lvproj`.
   - Helpers: `zmp05c_save_orphan.vi` and `zmp05c_save_orphan2.vi` plus an empty folder `zmp05c_orphan\`, all under `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`. I used the cached `pa_exec_state_sweep_file.vi`. No new stubs.
   - Also written outside the product folder: one `vi_nets.py` extract under `%TEMP%`, the tool's diagram-size PNG and repaired-AIXML copies under `%TEMP%\LabVIEWMCP`, and `make_t4.py` in the session scratchpad.
