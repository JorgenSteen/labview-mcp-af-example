REPORT 12i: re-checked `03` §3, ran a cold sweep, and ran T1-T7 on a cold LabVIEW (2026-10-12, 09:04:30 to 09:14:28). **DONE.** Nothing in `src\` changed and nothing was committed.

**1. `lvai_status`, kills and starts**
- **Start:** PID 26716, port 56779, up 44880 s, dwarn 0. 0 dialogs. LVAutoSave 0. The only unsaved items were the 2 `LVMCP Validate` scratch windows.
- **Close (for a cold start):** `lv_close.ps1` at 09:10:43. CloseMainWindow returned True, but LabVIEW did not exit within 20 s: a "Save changes? (Exit)" dialog came up for the scratch VI. I did not answer it.
- **Kill:** at 09:11:29 I killed PID 26716 under your standing go-ahead for this session.
- **Start:** `lvai_ensure_labview` started PID 5672 (09:11:51) in 32 s on port 59269. LVAutoSave was already empty.
- **End:** PID 5672, port 59269, dwarn 0, not degraded. 0 dialogs, 0 unsaved, LVAutoSave 0. The project was never opened.
- LabVIEW calls: 15 (3 `lvai_status`, 1 `ensure_labview`, 9 test runs, 2 sweep batches), each alone in its own message.

**2. `03` §3, one line per row**
1. **Every VI runnable: PASS (re-judged).** 137/137 state 1 cold; the negative control read 0 7 in both batches.
2. **Every class member still a member, every class in its library: PASS (re-judged).** `check_membership`: 134 checked, 0 not a member, 3 plain VIs (the 2 launchers and the receiver), exit 0. All 15 classes sit in their own library.
3. **Dependency rule: PASS (re-judged).** 176 files, 0 violations. The dependency graph is the same as in 12b.
4. **Naming: PASS (re-judged).** 177 files, 0 deviations.
5. **Scope and accessors: PASS, one note (re-judged).**
   - The only scope change since 12b is the 11 typedefs added as class members. LabVIEW made them public, and `02` gives no scope for typedefs.
   - The accessor set is unchanged.
   - Note: ZM-HWM-EVENTS, ZM-ROOT-EVENTS, ZM-PC-EP-DATA, ZM-CP-MX-PROTOCOLS and ZM-PC-DESTINATION have no file outside their class that links to them.
6. **Every AF override: PASS (re-judged CM Stop Core and Handle Error).**
   - Stop Core: Call Parent, then releaseProtocol, then Clear Errors (from the nets).
   - Handle Error: its nets are unchanged.
7. **Pre Launch Init: PASS (carried from 12b).** No file in this row changed.
8. **Actor Core (ROOT, HWM; D41): PASS (carried from 12b).** No file changed.
9. **No Stop Core on ROOT and HWM: PASS (carried from 12b).**
10. **Helper loops: PASS (re-judged).** The loop logic is carried from 12b. Both loop VIs now sit in `Helpers` (HWM `helperAcquisition`, ROOT `helperPanel`).
11. **User events: PASS (carried from 12b).** The EVENTS `.ctl` files are now class members; nothing else changed.
12. **Pre-launch settings: PASS (carried from 12b).** `launchCm` and `launchHwm` were only relinked; their diagram geometry is identical to 12b.
13. **Messages: PASS (carried from 12b).** `ZM-CI-handlePackage Msg` is in the library's `Messages` folder.
14. **Ignored errors: PASS under D44 option A (re-judged).**
    - 0 unwired `error out` in all 137 VIs (12b found 6 in the routing test).
    - In `releaseProtocol`, the close error goes into Clear Errors (code 1, the "never opened code" constant). Then Merge Errors(Clear Errors out, Write protocol `error out`) feeds `error out`; the log case is unchanged.
    - Stop Core ends that error in Clear Errors.
15. **Error code 5000: PASS (carried from 12b).** No file in this row changed.
16. **Virtual folders: PASS (re-judged).**
    - All 15 classes have only Accessors, AF Overrides, Helpers, Methods and TypeDefs folders, none of them empty.
    - Nothing sits at a class root except the private data `.ctl` (the interface has none).
    - The 11 typedefs are class members in TypeDefs: PC 5 (package 3, TP 1, EP 1), MX 1, ROOT 2, HWM 2, CM 1.
    - The CI library has its `Messages` folder.
17. **Descriptions: PASS (re-judged).**
    - All 15 classes have a description, and none holds a stray "?" (the ROOT one uses "->").
    - The CM, HWM and ROOT descriptions state the D40 error plan.
    - All 137 VIs have a description. The only "?" are the legitimate `stop actor?` and `Equal?`.
18. **Icons: PASS (re-judged).** Every VI icon (ICON, icl4, icl8) is 0 px different from the 12b extract (411/411 PNGs). The icon properties of all 28 classes and libraries are present and unchanged.
19. **Clean Up Diagram: PASS (re-judged for the 33 VIs changed after 12b).**
    - 30 were only relinked or had their description edited: their diagram geometry is identical to 12b.
    - Clean Up was the last diagram step on releaseProtocol (12g), the routing test (12e) and CM Handle Error (12e).
    - 12b's note stands: `Do.vi` and `Send` (Message Maker products) were never cleaned.
20. **Project tree: PASS under D42 and D43 (re-judged).**
    - 13 libraries.
    - 2 launchers, each with an `error out` indicator.
    - 7 tests in `ZM-TST-tests.lvlib`, and the receiver.
    - The folders common, hardware, protocol, actors, tests and receiver.
21. **A clean stop leaves the error log empty: PASS (carried from 12b, R-normal in 12a and 12d).** It was not re-run here. 12g's normal-stop run after D44 left the log byte-identical.

**3. Sweep, membership, versions**
- Batch 0: 30/30 state 1, control 0 7, 6.4 s. Batch 1: 107/107 state 1, control 0 7, 22.2 s. Not state 1: none.
- Membership: 134 checked, 0 missing, exit 0.
- `lv_save_version.py`: 177 of 177 files read 26.

**4. T1-T7 (cold LabVIEW, project closed)**
- T1, T2, T3, T5, T6 and T7: PASS, error 0, every sub-check T.
- T4: run 1 PASS; run 2 PASS; run 3 FAIL on `init_ok` alone with error 0 (the known flaky F13). Its one allowed rerun passed.
- The error log went from 18 to 22 lines: 2 T2 markers and 2 ROOT drop lines from T7, all expected.

**5. Defects**
- None that fail a row.
- Optional: if the policy "private unless needed outside" is meant to cover typedefs, set the 5 typedefs named in row 5 to private (the kit's `set_scope.py`, project closed). Check first that no public VI has them on its connector pane.

**6. Side effects; `git status`**
- LabVIEW was killed once and started once (PIDs above).
- New git-ignored files: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12i\` (scripts, extracts, nets, results, sweep lists) and `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\runs\12i-checks.txt`.
- The tests wrote to `output\` (the error log and temp JSONL folders).
- `git status --short`: only your two untracked runs files (`lessons-mcp-skill.md`, `notes-for-run-02.md`).

DONE
