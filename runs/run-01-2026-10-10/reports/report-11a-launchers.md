REPORT 11a: the launchers `ZM-launcher.vi` and `ZM-launcher_test.vi`. **DONE** (2026-10-11, 19:58 to 20:04). No NEEDS CLARIFICATION and no CANNOT PROCEED. I made 16 LabVIEW calls, each alone in its own message (`lvai_check_aixml` included).

**1. Status**
- **Start:** `lvai_status` ok. PID 26148, port 52603, 1.9.5-local, up 3940 s, dwarn 5. `lv_windows`: 0 dialogs, LVAutoSave 0, project closed. The 4 unsaved windows were hidden `LVMCP Validate*`.
- **End:** same PID and port, up 4208 s, dwarn 5, not degraded. 0 dialogs. The 8 unsaved windows are all the generator's hidden `LVMCP Validate*` VIs. Project closed.
- LabVIEW starts made: 0. No restart, no kill, no dialog answered.

**2. The two VIs** (AIXML in `proof\ZMP-11a\ZM-launcher.xml` and `ZM-launcher_test.xml`)
- **Route, both VIs:** the direct route.
  - The project was open with `ZM-ROOT-writePrelaunchSettings.vi` opened through it. `lvai_generate_vi` resolved the call (loadedSubVIs, executable).
  - `lvai_bind_typedef_constants` on the qualified subVI name, terminal `settings`: replaced 1 on each VI, which is the 10d answer. The `ZM-ROOT-PRELAUNCH_SETTINGS.ctl` link is in both files.
  - No stubs, no swaps. No `pa_clean_member` needed: nothing read state 0.
- **`ZM-launcher_test.vi`:**
  - **Panel and pane (4815):** `run_time_ms` U32 5000 (11), `output_folder` Path (10), `use_placeholder_hardware` F (9); indicators `lines_written` I32 (3), `last_line` (2), `error_lines` I32 (1), `ui_errors` (4), `error out` (0). No pane violations.
  - **Body:**
    - Delete `TestPackage.jsonl`, then `ZM-error_log.txt`; code 7 is cleared by Select, as in T5.
    - Settings, `writePrelaunchSettings`, `Launch Root Actor` (panel F), then Wait `run_time_ms`.
    - Open VI Reference `ZM-ROOT-root.lvlib:ZM-ROOT-root.lvclass:ZM-ROOT-helperPanel.vi`, then `Front Panel`, then `Controls[]` matched by `Label.Text` = `errors`. Its `Value` goes through Variant To Data into `ui_errors`.
    - Send Normal Stop, Wait 1000.
    - LF count of both files (code 7 = 0 lines). Last line by Read lines, then Index Array at size−1.
    - `error out` = Merge Errors(stop chain, panel read, both file reads).
  - **Diagram:** 3692x542, a 40-stage chain over the 10-stage budget. 02 fixes the chain and no subVI may be invented; left for cleanup in 11b.
- **`ZM-launcher.vi`:**
  - **Panel and pane:** `output_folder` (11) and `error out` (0).
  - **Body:** empty path becomes `<project folder>\output` (Strip Path ×2 + Build Path). Bundle `outputFolder` with `usePlaceholderHardware` F, then `writePrelaunchSettings`, then `Launch Root Actor` (panel F). Done.
  - **Diagram:** 672x133.
- **Descriptions:** both VIs have one, set in the AIXML (texts are in the XML files).
- **Cold state** (project closed): both read 1. I did not run `ZM-launcher.vi`.
- **Project items:** the project close adopted both VIs at the My Computer root, not in a virtual folder: `.lvproj` lines 39–40, URL `../ZM-launcher.vi` and `../ZM-launcher_test.vi`. BOM and 44 CRLF line endings kept, +2 lines and nothing else. `lvproj_add_toplevel.py` was not needed; it would have refused the names as already listed.

**3. Runs** (project closed; evidence in `proof\runs\11a-checks.txt`)
- **Before:** ROOT helperPanel read 1 cold. `TestPackage.jsonl` was absent. The error log had 11 lines; a copy is in `proof\ZMP-11a\error_log_before.txt`.
- **Run 1, defaults:**
  - `lines_written` 9, `error_lines` 0, `ui_errors` "", `error out` 0, 6492 ms.
  - `last_line` = `{"timestamp":"2026-10-11T18:01:59.224Z","type":"TestPackage","destination":"Communication","data":{temperature_c, sample_index 373, duty_percent 84, sensor_ok F, status "ok"}}`: five data fields.
  - Afterwards: only the LabVIEW frames were visible, with no ROOT or HWM panel. The file stayed at 9 lines.
- **Run 2, `use_placeholder_hardware` T:**
  - `lines_written` 0, `last_line` "", `error_lines` 0, `ui_errors` "".
  - **`error out` 1556**, source `…Message Priority Queue.lvclass:Priority Enqueue.vi…->ZM-launcher_test.vi`. That is the Send Normal Stop error: the root's queue was gone, so the tree stopped by itself, as D40 predicts.
  - 6443 ms, no hang. Both output files absent afterwards; no panels.
  - Cold afterwards: ROOT helperPanel 1, HWM helperAcquisition 1.
- **Not distinguishable in run 2:** `error out` merges the stop chain first. So whether the panel read itself failed (e.g. 1004, panel loop ended) is hidden behind the 1556.
- **Not proven in run 1:** that the `errors` control was matched. The VI exposes no match count. Error 0 does prove the open and the panel read of the running VI succeeded.

**4. Versions and links**
- Both VIs read 26:2; the `.lvproj` reads 26.0. No other file under `src\` changed.
- **Links** (`lv_loadability --links`, `proof\ZMP-11a\links.txt`): `ZM-ROOT-root.lvclass`, `ZM-ROOT-writePrelaunchSettings.vi`, `ZM-ROOT-PRELAUNCH_SETTINGS.ctl`. Plus AF in vi.lib: Actor / Launch Root Actor, and in the test launcher also Stop Msg / Send Normal Stop and Message Enqueuer. The helperPanel name is a string constant and in the description, not a link.

**5. Commits** (explicit paths, no trailer, not pushed)
- 292b08f `feat(launchers): ZM-launcher.vi and ZM-launcher_test.vi at the project root` (the two VIs and the `.lvproj`).
- `git status --short`: only the two untracked `runs\` notes, which are not mine.

**6. Deviations and items for the manager**
- (a) **`ZM-launcher.vi` has an `error out` indicator, which 02 §8 does not list.** It is there because `errors.ignored-errors` forbids an unwired error out, and Clear Errors would hide a launch failure. Please confirm, or I remove it.
- (b) **The error-log path:** `ZM-error_log.txt` is deleted and counted at `<project folder>\output`, where `ZM-CU-log` writes it. `TestPackage.jsonl` is in the effective `output_folder`. The two are the same with the defaults.
- (c) **Error chains:** the panel read is chained after the wait, but Send Normal Stop takes the launch chain. A failed read therefore never skips the stop. All chains are merged into `error out`; this adds no error handling.
- (d) **Run 2 readings against D40:** they match the brief's expectation, except that `error out` is 1556, not 0. The brief allows this ("may carry the error of the post-stop calls").
- (e) The test launcher's diagram is over budget (item 2).
- **For the user in the IDE:** none. No class description and no virtual folder is involved.

**7. Side effects**
- Run 1 deleted `output\ZM-error_log.txt` (11 lines; copy in proof). Run 2 deleted `output\TestPackage.jsonl` (9 lines; copy `proof\ZMP-11a\11a-run1-TestPackage.jsonl`). Both are git-ignored.
- The project was opened and closed once. The close also rewrote the git-ignored `.aliases`, `.lvlps` and UserState files.
- `proof\ZMP-11a\` (AIXML, links, copies) and `proof\runs\11a-checks.txt` are new; both are git-ignored.
- The tool's diagram-size PNGs are under `%TEMP%\LabVIEWMCP\diagramsize`. No new helpers or stubs.
- The generator left 4 more hidden, unsaved `LVMCP Validate*` VIs in memory (8 in total).
