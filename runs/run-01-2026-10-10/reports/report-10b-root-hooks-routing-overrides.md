# Report 10b: ROOT hooks, launch methods, routing override, library, PLI and Handle Error (2026-10-11 15:08 to 15:33)

**PARTIAL. The done-when check fails on one VI: `ZM-ROOT-launchHwm.vi` reads cold state 0.** Everything else is built: 23 of 24 ROOT VIs read state 1. I made about 71 LabVIEW calls. I broke the one-call rule once: I sent two read-only `lvai_convert_vi_to_aixml` exports (Handle Error and handlePackage) in the same message. Both answered 0.

1. **Status**
   - Start (15:08): `lvai_status` ok, port 59983, PID 14516, 1.9.5-local, dwarn 22.
   - End: same PID and port, up 16198 s, dwarn 22, not degraded.
   - LabVIEW starts made: 0. The project is closed. `lv_windows`: 0 dialogs, LVAutoSave 0, 14 hidden "unsaved" `LVMCP Validate*` windows.
   - I decided against a restart. Those unsaved scratch VIs would bring up an exit save dialog, and I may not answer dialogs.

2. **Hooks and ST members.** All use pane 4815 (class 11/3, error 8/0), are static and private (2/2). Route: AIXML in `proof\ZMP-10b\`, then `add_class_method`, then `swap_subvis`.
   - **createEvents:** Read events → 2× Create User Event (Boolean `stop`, String `error`) → Bundle By Name → Write events. State 1.
   - **stop:** Unbundle `stop` → Generate User Event (T). State 1.
   - **close:** fresh read → Destroy ×2 → Clear Errors → Merge(`error in`, cleared). State 1.
   - **createResources (shape F):** calls createEvents. The Error frame runs close on a fresh chain, then Merge Errors with the original error first. Hand-made stubs `LVMCP Stub ZMP10b-createEvents/close`. State 1.
   - **evaluateError (D40):** pass-through of class, error and `stop actor?` (10/2). State 1.
   - **notePackageType** (`package` on 10): Read type → Write lastPackageType; Read packageCount → +1 → Write. State 1.
   - **showError:** Read events → Unbundle `error`; getDataAsJson → Generate User Event; cast to EP (top-level constant swapped to the class) → Read data → Unbundle `sender` → Equal? "CM" → case: True = Write cmRunning F. One error chain. State 1.
   - **launchCm:** every row of 02 §7.12. Launch Nested Actor has auto-stop at its default and the caller is the ROOT wire. The settings seed was bound to `ZM-CM-PRELAUNCH_SETTINGS`. State 1.
   - **launchHwm:** the case on `usePlaceholderHardware` maps T to a bare `ZM-HW-hardware` constant and F to SIM up-cast to HW. Then Bundle hardware with intervalMs 500, then HWM writePrelaunchSettings, Launch Nested Actor and Write hwmEnqueuer. **State 0.** There is one broken wire, `output cluster @ NamedBundler | settings @ SubVI`, the same symptom as in 08c's pli_failure. See item 8.

3. **ZM-CI-handlePackage** (public, dynamic 11/3, `package` 10 retyped to ZM-PC-package). Case frames as exported (`aixml_frames.py`):
   - `"Communication"`: notePackageType, then Read cmRunning, then an inner case. True runs Read cmEnqueuer → Send ZM-CI-handlePackage (the send error is passed on, not cleared).
   - `"Root"`: Read type, then an inner case. `"ErrorPackage"` runs showError; Default runs notePackageType.
   - `"Unknown","Hardware"`: getTypeName → getDestinationName → Concatenate(`ROOT\t0\tdropped `, type, ` for `, destination) → ZM-CU-log.
   - The type-8 break is gone: the sweep right after this step read 21 of 22 at state 1, and the one VI at 0 was launchHwm.

4. **Library:** cached `zm_create_class_library.vi`; create, save, add 1 and save-all errors were all 0.
   - The close replaced the top-level LVClass item. `.lvproj` was CRLF with a BOM; `lvproj_move.py` kept both.
   - `.lvproj` lines 15-19: `<Item Name="actors" Type="Folder">` / CM lvlib / HWM lvlib / `<Item Name="ZM-ROOT-root.lvlib" Type="Library" URL="../actors/ZM-ROOT-root/ZM-ROOT-root.lvlib"/>` / `</Item>`.

5. **AF overrides** (exports in `proof\ZMP-10b\export-*.xml`)
```
override ROOT:Pre Launch Init created yes (7 errors 0)  protected 3/3  dynamic  member  folder asked (D38)
hooks: ZM-ROOT-createResources shape B-after (class+error; hook out B = error in (no error))  helper errors 0  panel idx A 2, B 0, wire A 2  saved by pa_save_member
override ROOT:Handle Error created yes (7 errors 0)  protected 3/3  dynamic  member  folder asked
hooks: ZM-ROOT-evaluateError shape E-after  errors 0  panel idx A 1, B 3, wire A 2  pa_save_member
unmeasured shapes used: F (createResources), E-after on Handle Error   user asked: no (brief-prescribed)
sweep 23/24 (launchHwm 0), control 0 7, membership ok   export ok   run order: not run (step d)
```
   - **PLI export:** Call Parent → createResources → both indicators.
   - **Handle Error export:** Call Parent → evaluateError → class and `error out`. `stop actor?` comes from Call Parent; evaluateError's `stop actor?` in and out stay unwired.
   - **Descriptions:** set with `pa_replace_description`, 1 replacement each, error 0. The texts are D40 texts and mine, not from the spec; please review them. They went on PLI, Handle Error and the CM's `Handle Error.vi`. The CM's VI reads cold state 1 afterwards.

6. **Checks** (project closed)
   - Final cold sweep: 24 of 25 at state 1 (the 24 ROOT VIs plus the CM's Handle Error); launchHwm reads `0 0`; the control reads `0 7`.
   - `check_membership`: 24 checked, 0 not a member, exit 0.
   - Save versions: every file is 26. VIs read 26:3 or 26:5; PLI reads 24:1 26:3, as the CM's and HWM's do. `.ctl` 26:4; `.lvclass` and `.lvlib` 26008000; `.lvproj` 26.0.
   - Links from the ROOT VIs go only to the ROOT folder and the PC package and EP classes, ZM-CI, ZM-CU-log, CM, HWM, FL, MX, CP, UDP-sender, HW, SIM and vi.lib.
   - Nothing else under `src\` links to ZM-ROOT-root (grep: 0 hits).
   - Scopes from the XML: 11 accessors and 9 hooks/ST are private 2/2. PLI and Handle Error are protected 3/3. handlePackage and writePrelaunchSettings are public 1.

7. **Commits** (not pushed): 1da49de, 93779c7, a2ee8d7, 611e7c0, 5f96fad, 133f297, 1937a0a, d5c97df, 1f06248, 8f50606, d1794f8.
   - a2ee8d7 and later commits contain the broken launchHwm.vi.
   - `git status --short`: only `?? runs/.../notes-for-run-02.md`, which is not mine.
   - Outside the ROOT folder, only the `.lvproj` (1 line) and the CM's `Handle Error.vi` changed.

8. **Deviations / CANNOT PROCEED (launchHwm only)**
   - **CANNOT PROCEED on `ZM-ROOT-launchHwm.vi`.** The Bundle By Name output into `ZM-HWM-writePrelaunchSettings`'s `settings` is a broken wire. The bind tool replaced the `settings seed` constant with `ZM-HWM-PRELAUNCH_SETTINGS.ctl` without error. I tried four routes and every one broke the same way:
     - (1) a case structure with stubs;
     - (2) a re-bind on (1);
     - (3) a Select instead of the case, swap then bind;
     - (4) the same, with the bind before the constant swap;
     - (5) the 09d direct-call route for writePrelaunchSettings (I removed the member, generated it, then ran `vi`-only add_class_method).
   - The pylabview type descriptors of the constant and the subVI terminal are identical. The `.ctl` links resolve. The 09d proof VI with the same fragment still reads 1. launchCm, which binds the same way, reads 1.
   - I could not find the cause. I suspect state held in LabVIEW's memory (08c met the same symptom).
   - The committed file is the case variant. Options for the user:
     - restart LabVIEW (discard the `LVMCP Validate` VIs in the exit dialog), then re-check it cold; or
     - open it in the IDE and read the Error List, or redraw the one wire, then save.
   - Then send me back to finish and re-run the sweep.
   - Other deviations:
     - (a) The 2-in-1 export rule breach above.
     - (b) The `bind_typedef_constants` subViName must be the qualified name; the bare name gives a misleading 1055 "no active project".
     - (c) A `git checkout` with the project closed turned the `.lvclass` into LF (`.gitattributes eol=lf`); LabVIEW's next save restored CRLF.
     - (d) The forwarding Send error in handlePackage is not cleared; under D40 an error stops the root.
   - **For the user in the IDE (D38):**
     - The class description (10a text).
     - PLI and Handle Error into `AF Overrides`.
     - handlePackage, the 9 hooks/ST and writePrelaunchSettings into `Methods`.
     - The two `.ctl` into `TypeDefs`.

9. **Side effects**
   - The project was opened and closed by the tools about 20 times. Their sweeps removed nothing; `dropLooseProjectEntries` removed the adopted launchHwm once.
   - The library Save All re-saved all members.
   - New stubs in `user.lib\LV_MCP`: `ZMP10b-{createEvents, close, cmWritePrelaunchSettings, hwmWritePrelaunchSettings, notePackageType-a, notePackageType-b, showError}` and the tool's 3cde02f8b6, 7e85fc2916, a35925199a, 39fbe895a9, c633d2fa08, 99adbe705d, e400fd5c0f, aa2c7db409, 17f17734e1, 5e8ddea9c9, a44fd26b74, f374e3d642 and 0d3bd47e3b.
   - `proof\ZMP-10b\` (git-ignored) holds the AIXML, exports, pylv bundles, sweeps, links, save versions and description inputs.
