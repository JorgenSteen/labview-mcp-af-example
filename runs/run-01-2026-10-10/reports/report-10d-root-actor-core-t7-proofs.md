REPORT 10d: ROOT Actor Core, T7, two launch proofs, Stop button. **DONE** (2026-10-11, 19:30 to 19:39). No NEEDS CLARIFICATION, no CANNOT PROCEED. I made 31 LabVIEW calls, each alone in its own message.

(Manager's note: the harness escaped `<` in the report as an "instruction-shaped pattern"; the match was the path placeholder `test_root_<tick>`, restored here. Nothing else changed.)

**1. Status**
- Start: `lvai_status` ok, PID 26148, port 52603, 1.9.5-local, up 2260 s, dwarn 4. `lv_windows`: 0 dialogs, 0 unsaved, LVAutoSave 0, project closed.
- End: same PID and port, up 2704 s, dwarn 4, not degraded. Project closed. 0 dialogs. The 4 "unsaved" windows are the generator's hidden `LVMCP Validate*` windows.
- LabVIEW starts made: 0. No kill, no restart.

**2. Actor Core** (export `proof\ZMP-10d\export-Actor Core.xml`)
```
override ROOT:Actor Core created yes (7 errors 0)  protected (MethodScope 3, LibItem.Scope 3)  dynamic  member  folder asked (AF Overrides, D38)
hooks: launchHwm shape B (pa_insert_series2, all 0, wire count 2), then launchCm shape B (all 0) -> order launchCm -> launchHwm -> Call Parent
       helperPanel shape A (af_add_hook_call from "ZM-ROOT-root in", all 0) | ZM-ROOT-stop shape D (pa_insert_seq_hook, frame 1, all 0) + pa_save_member 0
       close shape D-close (derived zmp09d_close_join: call parent/loop/stop/indicator hits 1/1/1/1, merge Bundler, wiring errors 0) + pa_save_member 0
unmeasured shapes used: two B hooks in series on one override (second inserted at the panel, so it lands first)   user asked: no (brief)
sweep 33/33 (ROOT 26 + tests 7), control 0 7, membership 26/0 and 7/0   export ok   commits a401d95 78184a8 e4cbcec b4d9462 d84cc36 e4a94cd
```
- **What the export shows:**
  - The panel `<C> in` and `error in` feed launchCm, then launchHwm, then Call Parent (class and error). An error from a launch goes into Call Parent.
  - helperPanel is branched from `<C> in`, and its `error in` is unwired.
  - In the Flat Sequence: ZM-ROOT-stop with a fresh error chain. Call Parent's `error out` comes in as an order tunnel with no consumer.
  - Merge(helperPanel, stop) → close, with close's class taken from `<C> in`. Then Merge(Call Parent, close) → `error out`.
- **The stop's class wire differs from the HWM:** it comes from launchCm's `<C> out`, not from the panel. The source search ("ZM-ROOT-root in") matched launchHwm's input, which launchCm feeds. This is still a class wire from before Call Parent, and `events` is the same object, so the behaviour does not change.
- **The derived close_join's `delete node error` read 1055.** This is expected: there was nothing to remove, and the derived copy isolates that step (F12). Every other output read 0.
- I needed no `pa_clean_member`: nothing read state 0.

**3. T7 `src\tests\ZM-TST-routing.vi`** (AIXML `proof\ZMP-10d\ZM-TST-routing.xml`)
- **What it does:** reads `output\ZM-error_log.txt` (a missing file counts as empty; that read error goes into Clear Errors). Then three test packages (TP-create, then Write destination Hardware / Unknown / Communication) go in series through ROOT's `ZM-CI-handlePackage` on a ROOT class constant. Then it reads the log again.
- **How it checks:** each check counts a text before and after (Search and Replace String, replace all; then Equal?/Not).
  - Pass = AND(hardware_dropped_ok, unknown_dropped_ok, communication_not_dropped_ok, no_error_ok).
  - `error out` is the error from the second read, which carries the whole chain.
- **Build:** direct route, with the project open and TP-create, Write destination and handlePackage opened. Generate, then the ROOT seed swapped (constantsJson, 1). `lvai_add_to_library` put it into `ZM-TST-tests.lvlib`, which sits under the project's `tests` folder.
  - The `.lvproj` is unchanged: no loose entry, BOM and CRLF kept.
  - Membership 7/0. Save version 26:2. Pane: Pass 3, error out 0.
- **checks.json:** it **already had** the `ZM-TST-routing` entry, with the same path and Pass/error out 0. I made no edit, so it does not gain an entry in this step.
- **Cold run:** PASS. Pass T, error 0, all four checks T, 485 ms. The log went from 5 to 7 lines: `ROOT\t0\tdropped TestPackage for Hardware` and `...for Unknown`.
- Commit 8c4d3d5 `test: routing of the root (T7)`.

**4. Launch proofs** (`proof\ZMP-10d\ZMP-10d-launch_root.vi`, `press stop` F; evidence in `proof\runs\10d-checks.txt`)
- **Route:** settings `{outputFolder = output\test_root_<tick>, usePlaceholderHardware F}` → writePrelaunchSettings → Launch Root Actor. Then Wait 5000, Send Normal Stop (stop1), Wait 3000, then a second Normal Stop on a fresh chain (stop2; 1556 = the root's queue is gone). Then the LF count of TestPackage.jsonl.
  - Built with the project open, settings constant bound (replaced 1), cold state 1, run with the project closed.
- **Run 1:** 10 lines, launch 0, stop1 0, stop2 **1556**, 8017 ms, read 0 (`test_root_124579290`).
- **Run 2:** 10 lines, launch 0, stop1 0, stop2 **1556**, 8019 ms (`test_root_124596336`).
- **Error log:** sha1 `da709a72…` before and after both runs, 7 lines, unchanged.
- **Panels:** after each run only the LabVIEW frames were visible. No ROOT panel and no HWM live panel were left.
- **After the runs, cold:** ROOT helperPanel, ROOT Actor Core, HWM helperAcquisition and HWM Actor Core all read 1. Control `0 7`.

**5. Stop-button run** (same VI, `press stop` T)
- **Route:** after the 5 s wait, the proof opens `ZM-ROOT-root.lvlib:ZM-ROOT-root.lvclass:ZM-ROOT-helperPanel.vi` by qualified name with Open VI Reference. It reads `Execution:State` and `Front Panel`, walks `Controls[]` by `Label.Text`, and writes `Value (Signaling)` = T to the control labelled `Stop`.
  - The spellings come from the kit's measured `pa_press_control_signal`. I cross-checked them in `resource\lvserver.rsc` (`Value (Signaling)` 43 hits, `Controls[]` 28, `Label.Text` 2). No probe.
- **Readings:**
  - Panel state 3 (running), matched 1, press error 0.
  - The proof's later Normal Stop answered **1556**, so the tree stopped by itself.
  - 10 lines, and still 10 three seconds later. Error log unchanged. 8041 ms.
  - Both panels closed, and every loop and Actor Core reads 1 cold.

**6. Sweep, versions, links**
- **Cold sweep** (`proof\ZMP-10d\sweep_1.txt`): 33/33 state 1, control `0 7`. `check_membership`: ROOT 26/0, tests 7/0, exit 0.
- **Versions:** all 39 files in the ROOT folder, `src\tests`, the `.lvlib` and the `.lvproj` read 26.
- **Links:** Actor Core links only ROOT members and vi.lib. T7 links ROOT, PC package/TP and the test library. T7 loadability 1/0 unresolved.

**7. Commits** (explicit paths, no trailer, not pushed)
- a401d95, 78184a8, e4cbcec, b4d9462, d84cc36, e4a94cd (Actor Core); 8c4d3d5 (T7).
- `git status --short`: only the two untracked `runs\` notes, which are not mine.

**8. Deviations and items for the user**
- (a) The stop hook's class wire comes from launchCm's out, not from the panel (item 2).
- (b) The two-series-hook order is unmeasured in the skill. It is verified here by an export after the second insert.
- (c) The checks.json entry for T7 already existed, so there was nothing to add.
- (d) T7 diagram is 1927x516 (23-stage serial chain, as T3-T6). Its `tp data` is a bare cluster coerced into TP-create, not bound to the typedef.
- (e) **Actor Core still has NI's help text as its description.** It needs a D40 text in step e (`pa_replace_description`).
- **For the user in the IDE (D38):** put ROOT `Actor Core.vi` into `AF Overrides`. The 10b and 10c items still stand.

**9. Side effects**
- **The library add re-saved `ZM-TST-pipeline.vi`** (1 byte). I restored it with `git checkout`, project closed. It reads 1 cold afterwards.
- **The proof VI was adopted into the `.lvproj` on close.** I removed it with `lvproj_drop.py`. The `.lvproj` was checked first and after (F10): CRLF and BOM kept, no net diff.
- New output folders (git-ignored): `test_root_124579290`, `test_root_124596336`, `test_root_124612150`, 10 lines each.
- Two T7 lines were appended to `output\ZM-error_log.txt`.
- `proof\ZMP-10d\` (git-ignored) holds the AIXML, the proof VI, both exports, sweep lists, links and the error-log copy. `proof\runs\10d-checks.txt` is new.
- No new helpers or stubs. The generator left hidden unsaved `LVMCP Validate*` VIs in memory.
- The project was opened and closed 2 times.
