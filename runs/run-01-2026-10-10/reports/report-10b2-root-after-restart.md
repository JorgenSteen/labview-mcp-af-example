# Report 10b (updated after the kill and restart): ROOT hooks, launch methods, routing override, library, PLI and Handle Error

**CANNOT PROCEED on one VI, `ZM-ROOT-launchHwm.vi`. It reads cold state 0 even in the fresh LabVIEW.** Every other item is built and reads state 1. Sweep: 24 of 25 at state 1, control `0 7`.

LabVIEW calls: about 71 before the kill and 11 after it, each alone in its message. The one exception is the earlier breach (two exports sent in one message), which I have not repeated.

1. **Status**
   - Start (15:08): `lvai_status` ok, PID 14516, port 59983, 1.9.5-local, dwarn 22.
   - End (18:56): `lvai_status` ok, PID 26148, port 52603, up 37 s at the first read, dwarn 0.
   - `lv_windows`: 0 dialogs, 0 unsaved, LVAutoSave 0. The project is closed.
   - LabVIEW starts made: 1, by `lvai_ensure_labview` after the kill (`startedByThisCall`, launch method breakaway).
```
restart: kill of LabVIEW PID 14516 (StartTime 2026-10-11 11:03:50), go-ahead: the user, 2026-10-11 ~15:40,
  "you may kill LabVIEW" (one kill, PID 14516, relayed by the coordinator, recorded in status.md)
  before: lv_windows 18:52:39: no dialog, LVAutoSave 0, project closed, unsaved 14 = only hidden LVMCP Validate*
  kill: Stop-Process -Id 14516 at 18:52:46 (Nigel PID 19156 untouched); after: LabVIEW count 0, LVAutoSave 0
  start: lvai_ensure_labview -> ready in 31.8 s, new PID 26148 (start 18:52:53), port 52603; autosave already empty
  first reads: lvai_exec_state launchHwm = 0 (eBad); cold sweep 24/25, launchHwm 0
```

2. **Hooks and ST members.** All use pane 4815, are static and private (2/2), and read cold state 1, except launchHwm.
   - **createEvents:** 2× Create User Event (`stop` Boolean, `error` String) → Bundle By Name → Write events.
   - **stop:** Generate User Event (T).
   - **close:** Destroy ×2 → Clear Errors → Merge with `error in`.
   - **createResources (shape F):** the Error frame runs close, then Merge Errors with the original error first.
   - **evaluateError:** pass-through (D40).
   - **notePackageType:** writes the last package type and adds 1 to the package count.
   - **showError:** event to the panel; if the package is an EP with sender = "CM", `cmRunning` is set F.
   - **launchCm:** every row of 02 §7.12.
   - **launchHwm:** the case maps T to a bare HW constant and F to SIM up-cast to HW; then Bundle with `intervalMs` 500, HWM writePrelaunchSettings, Launch Nested Actor and Write hwmEnqueuer. **State 0.**

3. **ZM-CI-handlePackage** (public, dynamic 11/3, `package` 10). Frames as exported:
   - `"Communication"`: notePackageType, then Read cmRunning. True: Read cmEnqueuer → Send ZM-CI-handlePackage.
   - `"Root"`: Read type. `"ErrorPackage"` runs showError; Default runs notePackageType.
   - `"Unknown","Hardware"`: getTypeName → getDestinationName → Concatenate(`ROOT\t0\tdropped `, type, ` for `, destination) → ZM-CU-log.

4. **Library:** `ZM-ROOT-root.lvlib` holds the class. Helper errors were all 0.
   - `.lvproj` (CRLF and BOM kept) lines 15-19: `actors` / CM lvlib / HWM lvlib / `<Item Name="ZM-ROOT-root.lvlib" Type="Library" URL="../actors/ZM-ROOT-root/ZM-ROOT-root.lvlib"/>` / `</Item>`.

5. **AF overrides**
```
override ROOT:Pre Launch Init created yes (7 errors 0)  protected 3/3  dynamic  member  folder asked (D38)
hooks: ZM-ROOT-createResources shape B-after (class+error)  helper errors 0  panel idx A 2, B 0  saved by pa_save_member
override ROOT:Handle Error created yes (7 errors 0)  protected 3/3  dynamic  member  folder asked
hooks: ZM-ROOT-evaluateError shape E-after  errors 0  panel idx A 1, B 3  pa_save_member
unmeasured shapes used: F, E-after on Handle Error   user asked: no (brief-prescribed)
sweep 24/25 (launchHwm 0), control 0 7, membership ok   export ok   run order: not run (step d)
```
   - **Exports:** PLI runs Call Parent → createResources → indicators. Handle Error runs Call Parent → evaluateError → class and `error out`; `stop actor?` comes from Call Parent.
   - **Descriptions:** D40 texts set with `pa_replace_description` (1 replacement each) on the ROOT's PLI and Handle Error and on the CM's `Handle Error.vi`. The CM's VI still reads 1.

6. **Checks**
   - `check_membership`: 24 checked, 0 missing.
   - Save versions: every file is 26.
   - Links from the ROOT VIs go only to PC, EP, CI, CU-log, CM, HWM, FL, MX, CP, UDP-sender, HW, SIM and vi.lib. Nothing outside the ROOT folder links to the ROOT.
   - Scopes: 20 private, PLI and Handle Error protected 3/3, handlePackage and writePrelaunchSettings public.

7. **Commits:** 1da49de, 93779c7, a2ee8d7, 611e7c0, 5f96fad, 133f297, 1937a0a, d5c97df, 1f06248, 8f50606, d1794f8 (not pushed).
   - After the restart I restored launchHwm.vi and the `.lvclass` to d1794f8 with the project closed. The fresh-instance attempt had stripped the `.lvclass` BOM and was broken the same way.
   - `git status --short`: only `?? runs/.../notes-for-run-02.md`.

8. **CANNOT PROCEED: `ZM-ROOT-launchHwm.vi`**
   - Broken-wire text (`zm_broken_wires_default`, fresh instance, 23 wires seen): **`output cluster @ NamedBundler | settings @ SubVI`**. The wire runs from Bundle By Name's output to `ZM-HWM-writePrelaunchSettings`'s `settings`.
   - The one extra attempt on the fresh instance re-ran the stub route: `add_class_method` from the case AIXML, swaps, then `bind_typedef_constants` with the qualified subVI name. This time the bind answered `ok:true`, coercedBefore 0, coercedAfter 0. Cold state was still 0.
   - Earlier attempts in the old instance also broke the same way: a Select instead of the case, the bind before the constant swap, and the direct-call route.
   - The pylabview type descriptors of the bound constant and the `settings` terminal are identical (both `ZM-HWM-PRELAUNCH_SETTINGS.ctl` {HW class `hardware`, U32 `intervalMs`}).
   - The 09d proof VI with the same fragment reads 1, and launchCm (same pattern, CM settings) reads 1.
   - **Ask:** the user opens `ZM-ROOT-launchHwm.vi` in the IDE and reads the Error List. If needed, they redraw the Bundle → `settings` wire and save. I then re-sweep and commit.
   - Other deviations:
     - (a) The earlier breach of one call per message (two exports in one message).
     - (b) `bind_typedef_constants` needs the qualified subVI name; the bare name answers a misleading 1055.
     - (c) A `git checkout` of a `.lvclass` writes LF (`.gitattributes`).
     - (d) handlePackage passes the forwarding Send error on, as D40 wants.
   - **For the user in the IDE (D38):**
     - The class description (10a text).
     - PLI and Handle Error into `AF Overrides`.
     - handlePackage, the 9 hooks/ST and writePrelaunchSettings into `Methods`.
     - The 2 `.ctl` into `TypeDefs`.

9. **Side effects**
   - LabVIEW PID 14516 was killed and 26148 started. 14 unsaved scratch `LVMCP Validate*` VIs were lost with the kill; LVAutoSave stayed 0.
   - The project was opened and closed by the tools about 23 times; their sweeps removed nothing.
   - The library Save All re-saved all members.
   - New stubs in `user.lib\LV_MCP`: 7 `ZMP10b-*` hand stubs and 13 tool stubs.
   - `proof\ZMP-10b\` (git-ignored) holds the AIXML (`ZM-ROOT-launchHwm.xml` is the case variant; `-select`/`-direct` are the alternatives), exports, pylv bundles, sweeps, links, save versions and description inputs.
