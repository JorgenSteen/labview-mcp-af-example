# Report 08c: CM launch proof, forced PLI failure, cleanup, icons, closing checks (2026-10-11 11:32-11:46)

**DONE, with one route deviation** in the PLI proof (item 3). About 69 LabVIEW calls, each sent alone in its own message. No NEEDS CLARIFICATION.

1. **Status.** `lvai_status` at the start (11:32): ok, port 59983, PID 14516, 1.9.5-local (f9ee41d9), up 1720 s, dwarn 4. At the end (11:46): same, up 2563 s, dwarn 4, not degraded. LabVIEW starts: 0. Project closed. `lv_windows`: 0 dialogs, LVAutoSave 0; the 8 "unsaved" windows are the tool's hidden `LVMCP Validate*` pairs.

2. **Launch proof** (`proof\ZMP-08c\ZMP-08c-launch_cm.vi`, run cold with the project closed, timeout 30 s; evidence in `proof\runs\08c-checks.txt`).
   - Build: direct route with the project open, then swaps (fl, cp target, mx), then `lvai_bind_typedef_constants` turned the `settings seed` cluster into the typedef `ZM-CM-PRELAUNCH_SETTINGS`. Cold state 1.
   - Run 1, 1788 ms: lines 3; launch, send, stop, read and error out all 0. The file `output\test_cm_95656555\TestPackage.jsonl` has 3 TestPackage/Communication lines.
   - Run 2, 1830 ms: the same readings (`test_cm_95669199`, 3 lines).
   - Error log: 5 lines before, 5 after each run, byte-identical.
   - How the stop was proven: both runs returned by themselves; `lv_windows.ps1` after each showed no CM or Actor Core window; run 2 gave the same readings as run 1. Send Normal Stop answered 0.

3. **PLI failure** (`ZMP-08c-pli_failure.vi`).
   - Launch Root Actor returned **code 1**. Source: `Create Folder in ZM-CP-FL-createFolder.vi -> FL ZM-CP-init -> ZM-CP-MX-initAll -> MX ZM-CP-init -> ZM-CM-createResources -> CM Pre Launch Init -> Actor.vi`, with the bad path appended.
   - The run returned in 1793 ms (this includes 1500 ms of waits). No hang. Send Normal Stop to the returned enqueuer gave 1556 (no actor queue).
   - Error log unchanged (5 lines). No output folder was created.
   - Caveat: the unchanged log does not prove that Stop Core was skipped. FL close returns 0, so releaseProtocol would log nothing either way.
   - **Deviation in the route:**
     - The brief's VI (String To Path `Q:\nope\cm`; `Q:` checked absent) generated eBad 3 times: once swap then bind, once a re-bind, once a full regeneration with bind then swap.
     - My default-instance broken-wires helper named the cause: `output cluster @ NamedBundler | settings @ SubVI`. The bundle fragment is identical to the one in the executable launch VI (exports and nets compared). The cause is not found.
     - Instead I file-copied the working `launch_cm.vi` and used `lvai_set_constant` to set `temp folder prefix` = `test_cm_bad<>|_`, a path with invalid characters that Create Folder rejects.
     - So the injected fault is an invalid folder name, not a missing drive. The copied VI's own description still describes the launch VI (proof file only). The broken first VI is kept as `broken-pli_failure-route1.vi.bak`.

4. **Cleanup and icons:**
```
cleanup 13 VIs (all CM VIs from 08a/08b)  start HEAD 318d71d  batches 2 (5 + 8)  0.32 / 0.34 s per VI
codes: 13/13 code 0   versions: 26 before and after (17/17 files)   git: only the .vi of each batch yes
sweep before/after: same (13/13 state 1, control 0 7)   membership unchanged (13, not a member 0)
panel checks: none needed (08a/08b AIXML: 0 hits)   commits 3a71740 2342169
sizes before -> after: Pre Launch Init 565x270 -> 621x100; Stop Core 565x390 -> 624x147; Handle Error 581x278 -> 623x162;
  evaluateError 1441x264 -> 1441x264; releaseProtocol 1301x225 -> 1290x224 (13- and 11-stage chains stay; no subVI invented)
icons 13 VIs  mode new (class template + own layer)  spec icon-spec.json existing  preview approved yes (D39, not asked)
make_icons --check exit 0 (CM 13 VIs: close/create/error/inbox/launch/read/stop/write); generate exit 0 (117 icons)
before read-back yes (13/13; 13/13 changed afterwards, 566-598 px)   own layers 13 (lvai_set_vi_icon, each 0 px)
templates: class 1, library 1 (all error clusters 0)   apply 13: open and save codes all 0
read-back 13/13 at 0 px (pixcmp --tree exit 0; repeated after the description saves: still 13/13)   owners 2/2 at 0 px
commits 7a755f3 55eecab ad8d80f   kit TODO differences: D39 (white 3x5 banner, library glyph on the left)
```

5. **Closing checks:**
   - Descriptions: 13/13 VIs have one (offline read, `descriptions-final.txt`).
     - The three AF overrides had NI's help text. `pa_replace_description` (description only, project closed, no regeneration) now gives them CM-specific text: commit e3efe7a. After it, icons are 0 px and the sweep is 13/13.
   - Class description for the user (D38): the 08a text, which carries the error plan (D14).
   - Links (`links.txt`): only the CM folder, ZM-CI, ZM-CU, ZM-PC and ZM-CP-communication_protocol. FL, UDP, MX, HW and TST: 0 hits.
   - `.lvproj`: the `actors` folder (lines 15-17) lists `ZM-CM-communication_manager.lvlib` once.
   - Versions: 17/17 files are 26 (VIs, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj` 26.0).
   - Final cold sweep: 13/13 state 1, control 0 7. Membership: 13 checked, 0 not a member, exit 0.
   - `git status --short`: only `?? runs/.../notes-for-run-02.md`, which is not mine.

6. **Commits** (not pushed): 3a71740, 2342169, 7a755f3, 55eecab, ad8d80f, e3efe7a. I did not add a separate `feat(cm): communication manager actor` commit: the 08a/08b `feat(cm)` commits already carry the build, and nothing was left to commit.

7. **Deviations, open points and IDE items.**
   - (a) The PLI route in item 3.
   - (b) Not run here: Handle Error on a real message error. Only the normal-stop path (43) ran, with a clean log. No behaviour that differs from 02 §5 was seen.
   - (c) Override descriptions were written by me, not taken from the spec. Please review them in the commit.
   - For the user in the IDE (D38):
     - Set the CM class description (08a text).
     - Move the 3 overrides into `AF Overrides`.
     - Put handlePackage, the 3 hooks and writePrelaunchSettings into `Methods`.
     - Put `ZM-CM-PRELAUNCH_SETTINGS.ctl` into `TypeDefs`.

8. **Side effects.**
   - Output: `output\test_cm_95656555` and `output\test_cm_95669199`, 3 lines each (git-ignored).
   - Project opened and closed 3 times. The closes adopted proof VIs into the `.lvproj`; `lvproj_drop.py` removed them (2 lines, then 1). The tool's sweep removed the strays `lvbd_bind_constant.vi` and `lvbd_coercion_dots.vi`.
   - I read each `.lvproj` diff first: only the BOM and line endings were left, and I restored the file with `git checkout` with the project closed. `.aliases`/`.lvlps` were rewritten (git-ignored).
   - New helpers in `%TEMP%\LabVIEWMCP\helpers\`: `zm_broken_reason_default.vi/.xml` and `zm_broken_wires_default.vi/.xml` (default-instance variants of the plugin helpers), and `lvbd_bind_constant.vi` (generated by the tool).
   - Read-back folders: `%TEMP%\LabVIEWMCP\rb\08c*`.
   - `proof\ZMP-08c\` (git-ignored) holds: the proof VIs and AIXML, exports, renders, sweep/clean lists, versions, links, descriptions, and `pngsize.py`/`descs.py`. `proof\runs\08c-checks.txt` is new, and `proof\icons\` was regenerated.
