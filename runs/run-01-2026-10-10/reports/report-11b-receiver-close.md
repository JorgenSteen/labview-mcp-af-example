REPORT 11b: the UDP receiver `ZM-receiver.vi`, then cleanup, icons and the phase-11 closing checks. **DONE** (2026-10-11, 20:08 to 20:14). No NEEDS CLARIFICATION and no CANNOT PROCEED. I made 24 LabVIEW calls. **One message broke the one-call rule (F9):** it sent two `lvai_set_vi_icon` calls together (the two launchers). Both answered ok and were verified. Every other call went alone in its own message.

**1. Status**
- **Start:** `lvai_status` ok. PID 26148, port 52603, 1.9.5-local, up 4560 s, dwarn 5. `lv_windows` showed 0 dialogs, LVAutoSave 0, project closed, and 8 hidden `LVMCP Validate*` windows.
- **End:** same PID and port, up 4869 s, dwarn 5, not degraded. 0 dialogs, project closed. There are now 10 unsaved windows, all `LVMCP Validate*` (the generator added 2).
- LabVIEW starts made: 0. No restart, no kill, no dialog answered.

**2. The receiver** (AIXML in `proof\ZMP-11b\ZM-receiver.xml`)
- **Route:** the direct route.
  - The project was open with Write localPort, receive, ZM-CP-init and ZM-CP-close opened through it. `lvai_generate_vi` resolved all 4 calls. The VI read eBad until the path seed was swapped, as expected.
  - `lvai_swap_subvis` constantsJson: `rx seed` became the `ZM-CP-UDP-receiver.lvclass` constant.
  - **New route, not measured before:** the same tool with `class` = a `.ctl` path turned the bare clusters into typedef constants of `ZM-PC-HEADER.ctl` and `ZM-PC-TP-DATA.ctl`. Each answered constantsSwapped 1, error 0. Both `.ctl` links are in the file, and `vi_nets` shows both feeding the two Unflatten `type and defaults` inputs as TypeDef.
  - The close put the VI at the project root. `lvproj_move.py` moved it into `receiver` (CRLF checked first; BOM and CRLF kept). Commits 1fa6d23, 48cf1d3.
- **Panel:** `port` U16 61557; `Stop` Boolean F; `chart` (waveform chart); `interval measured (ms)` U32; `last line`; `packets` U32; `error out`. No connector pane terminals (it is a top-level VI). Diagram 1890x676, chain of 16 stages.
- **Body:** as 02 §8. The receive loop runs on shift registers (object, error, previous tick, packets). The loop exits on `Stop` OR the error status. Then `ZM-CP-close`, whose error goes to `error out`.
- **Stop:** `pa_set_mechanical_action` set 1, read back 1. After cleanup, `pa_read_boolean` read it again: found T, action 1, visible T.
- **Plot names:** the 09c helper set `temperature_c` and `duty_percent`, and both read back equal.
- **Cold state:** 1. Not run, as the brief says; the live run is phase 12's R-receiver.
- **Links** (`lv_loadability --links`): `ZM-CP-UDP-receiver.lvclass`, `Write localPort.vi`, `ZM-CP-UDP-receive.vi`, `ZM-PC-HEADER.ctl`, `ZM-PC-TP-DATA.ctl`.
  - Closure: 80 files, 0 unresolved.
  - The UDP, CP and PC libraries link nothing outside UDP, CP and PC.
  - So the receiver depends only on ZM-CP-UDP, ZM-CP and ZM-PC: no AF, no actor, no HW, CI or CU.
- **Description:** set in the AIXML.

**3. Cleanup and icons**
```
cleanup 3 VIs (2 launchers + receiver)  start HEAD 48cf1d3  batches 1 (3)  ~0.34 s per VI  codes 3/3 code 0
versions 26 before/after   git: only the 3 .vi   sweep before/after 3/3 state 1, control 0 7, same   panel: Stop 1 (above)   commit 1ec1eec
icons 3 VIs  mode new, top-level (no_template, no class template)  spec existing  preview approved (D39, not asked)
make_icons --check exit 0, generate exit 0 (163 icons)  own layers: composite via lvai_set_vi_icon 3/3 verified
read-back icon_get_vi_icons_n_file 3/3 code 0, files 3, pixcmp --tree 3/3 0 px   versions 26   commit e86cc0a
```

**4. Closing checks** (evidence in `proof\runs\11b-checks.txt`)
- **Descriptions:** 3/3 VIs have one.
- **Versions:** 175/175 files under `src` read major 26.
  - After the icons, `lv_save_version` also shows stray stamp-like byte counts (`9:2 10:2 16:2` on ZM-launcher, `30:1` on the test launcher). The tool is a heuristic scan, so these are most likely icon pixel bytes; the major still reads 26.
- **`.lvproj`:** the two launchers sit at the My Computer root and `ZM-receiver.vi` sits in the `receiver` folder. BOM and CRLF are kept.
- **Cold sweep** of the `src` top level plus `src\receiver`: 3/3 state 1, control `0 7`.
- **Membership:** `src` 132 checked, 0 missing, 3 plain; `src\receiver` 1 plain.
- **T1–T7, run cold:** every test passed with Pass T and error 0.
  - T1 packages, T2 log, T3 hardware.
  - T4 protocol (`init_ok` T this time).
  - T5 udp (UDP port 61557 was free before the run).
  - T6 pipeline, T7 routing.

**5. Commits** (explicit paths, no trailer, not pushed)
- 1fa6d23: the receiver and the `.lvproj`.
- 48cf1d3: the Stop action and the plot names.
- 1ec1eec: cleanup.
- e86cc0a: icons.
- 1e07b17 `feat: launchers and udp receiver`: an empty marker.
- `git status --short`: only the two untracked `runs\` notes, which are not mine.

**6. Deviations and items for the user**
- (a) **My reading of 02 §8:** chart, interval, last line and packets update only for a TestPackage; any other package type is skipped. The interval is measured between TestPackages and reads 0 for the first.
- (b) **Typedef constants by `{LV.Constant}` Replace with a `.ctl` path:** a new route. It is proven from the file links and the cold state, not by a run.
- (c) The F9 slip described at the top.
- (d) Icons: the generator's known D39 differences (a white 3x5 banner, the library glyph at the left).
- **For the user in the IDE (D38):** none. No class description and no virtual folder is involved.

**7. Side effects**
- The project was opened and closed once. The close rewrote the git-ignored `.aliases`, `.lvlps` and UserState files.
- The tests (git-ignored output):
  - T2 and T7 appended 4 lines to `output\ZM-error_log.txt`, which now has 4 lines.
  - T4 and T6 created `output\test_fl_126795311`, `test_pipeline_126801453` and `test_pipeline_126801454`.
  - T5 rewrote `test_mx_a` and `test_mx_b`.
- `proof\icons\` was regenerated (163 PNGs, 3 of them new). `proof\ZMP-11b\` (AIXML, nets, links, closure, lists, `make_icons` logs) and `proof\runs\11b-checks.txt` are new; all git-ignored.
- Outside the product folder: read-back PNGs in `%TEMP%\LabVIEWMCP\rb\11b`, `11b_own` and the `11b_VL`/`11b_PL` lists; a diagram-size PNG in `%TEMP%\LabVIEWMCP\diagramsize`; `vi_nets` extracts in `%TEMP%`. No new helpers and no new stubs; I used only cached ones.
