REPORT 12j (F13), 2026-10-12, 11:53 to 12:00. DONE. T4's second Create Folder now runs after ZM-CP-init, and T4 passed 10 of 10 runs on a cold LabVIEW. Committed as c429e56; not pushed.

1. Status, kills and starts
- Start: `lvai_status` PID 5672, port 59269, dwarn 0. 0 dialogs, 0 unsaved, LVAutoSave 0.
- Kill at 11:56:35 (PID 5672, under the standing go-ahead), to get a cold LabVIEW. I did not try a close, because the scratch `LVMCP Validate` VI would bring up a save prompt.
- Start: `lvai_ensure_labview` started PID 27076 at 11:56:42 on port 61113.
  - The first call answered "starting" and flagged a possible dialog. `lv_windows` showed 0 dialogs; the second call answered ready.
- End: PID 27076, dwarn 0, not degraded. 0 dialogs, 0 unsaved, LVAutoSave 0. The project was never opened.

2. Export before: race confirmed
- Offline nets of the current VI (`vi_nets.py`, 135 wires).
- Create Folder prim#5124 had only its path wire, from Build Path 5115. Its `error in` was unwired.
- Its `error out` goes to Unbundle 5125 (code), then Equal? 5126 with the "duplicate path code" constant (10), then And 5127, then `init_ok`.
- The UIDs and wiring match the 05c source.

3. Route, and the export after
- In-place scripted edit with a derived helper, `proof\ZMP-12j\zmp12j_wire_after_init.xml`, in the default instance. No regeneration.
- Dry run: the node labelled "ZM-CP-init.vi" was found once, and the node labelled "Create Folder" once. Errors 0.
- Apply: Connect Wire (Create Folder `error in` from init `error out`), then Save.Instrument. Every error 0.
- Nets after (135 wires): wire 6380 now runs from init `error out` to Unbundle 5122, ZM-PC-TP-create `error in` and Create Folder `error in`.
- A diff before and after shows only that wire changed. It survives the cleanup.
- `exec_state` reads 1 after the edit, and 1 again on the cold LabVIEW.

4. Description, cleanup, icon
- `pa_replace_description`: 1 replacement, error 0. The text now reads "...answering code 10, wired after init on init's error chain (F13)".
- Clean Up Diagram: code 0, ok count 1.
- Icon read back with error 0; `pixcmp` against `proof\icons\tests\ZM-TST-protocol.png`: 0 px of 1024 differ.

5. Runs (evidence in `proof\runs\12j-checks.txt`)
- T4 x10: every run PASS, Pass=T, error 0, `init_ok`=T, 7/7 sub-checks T. Each run made one new `output\test_fl_<tick>` folder with its 3 JSONL files:
  - run 1: test_fl_183430588
  - run 2: test_fl_183446538
  - run 3: test_fl_183455288
  - run 4: test_fl_183463320
  - run 5: test_fl_183471349
  - run 6: test_fl_183479749
  - run 7: test_fl_183494530
  - run 8: test_fl_183506144
  - run 9: test_fl_183513634
  - run 10: test_fl_183524135
- T1 to T7 once: all PASS with error 0 and every sub-check T (10, 3, 5, 7, 6, 2 and 4).
- The error log grew from 22 to 26 lines: 2 T2 markers and 2 ROOT lines from T7, as expected.

6. Versions, commit, git
- `lv_save_version`: 26 before and after.
- Commit c429e56 `fix(tst): run T4's second Create Folder after init (F13)`, by explicit path, no trailer.
- `git status --short`: only your two untracked runs files (`lessons-mcp-skill.md`, `notes-for-run-02.md`).

7. Side effects
- Re-saved: only `src\tests\ZM-TST-protocol.vi` (helper save, description save, cleanup save).
- After the save, pylabview reads node labels that it did not show before ("Tick Count (ms)" etc.). The wiring is unchanged.
- New helper `%TEMP%\LabVIEWMCP\helpers\zmp12j_wire_after_init.vi` and the read-back `%TEMP%\LabVIEWMCP\rb\12j\`.
- Git-ignored, new: `proof\ZMP-12j\` (helper source, nets, extracts, folder lists), `proof\runs\12j-checks.txt`, and 11 `output\test_fl_*` folders plus `output\test_mx_*` from T5.
- LabVIEW calls: 25, each alone in its own message.

DONE
