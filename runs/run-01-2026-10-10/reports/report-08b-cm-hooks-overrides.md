# Report 08b: CM hooks, ZM-CI-handlePackage override, library, AF overrides (2026-10-11 11:13-11:26)

**DONE.** Every name comes from 02 §7.10. The final cold sweep reads 13/13 state 1 with control `0 7`. No NEEDS CLARIFICATION. About 45 LabVIEW calls. One rule breach: two `lvai_convert_vi_to_aixml` exports went out in one message (item 8).

1. **Status.** `lvai_status` at the start (11:13): ok, port 59983, PID 14516, 1.9.5-local (f9ee41d9), up 577 s, dwarn 0. At the end (11:26): ok, same port, up 1357 s, dwarn 4, not degraded. LabVIEW starts made: 0. The project is closed. `lv_windows`: 0 dialogs; the 2 unsaved windows are the tool's hidden `LVMCP Validate`.

2. **Hooks** (all private and static, pane 4815; cold state 1 for each):
   - **evaluateError**:
     - Pane: class 11/3, `stop actor? in` 10 (default T), `stop actor? out` 2, error 8/0.
     - Body: the case runs when status AND code ≠ 1608. In it: Number To Decimal String + Concatenate builds `CM\t<code>\t<source>` → ZM-CU-log (fresh chain) → ZM-PC-EP-create("CM", the error as data) → Read Caller Enqueuer → Send ZM-CI-handlePackage → Unbundle status → Select(no error) → `error out`, and `stop actor?` = T.
     - The False frame passes the error and `stop actor?` through. The class wire goes straight through.
   - **releaseProtocol**:
     - Body: Read protocol → ZM-CP-close → Write protocol.
     - Errors: code 1 is cleared without a log; any other close error goes to ZM-CU-log and is then cleared. `error out` carries only a failure of the log itself.
     - **Probe** (`proof\ZMP-08b\ZMP-08b-probe.vi`, run cold): an MX holding [FL, UDP-sender] that was never initialised → close gives **code 1** (`UDP Close in ZM-CP-UDP-closeConnection.vi`). UDP-sender alone also gives 1; FL alone gives 0.
   - **createResources**:
     - Body: Read prelaunchSettings → Unbundle `protocol` → ZM-CP-init → Write protocol → Merge Errors → case. The Error frame runs releaseProtocol on a fresh chain, then Merge Errors (the original error first). The No Error frame passes through.
     - Write protocol takes the read's error, not init's, so a partly initialised protocol is stored for the release (Deviation b).

3. **Interface override ZM-CI-handlePackage.vi.**
   - Built with `lvai_add_class_method`. Pane 4815: class 11/3, `package` 10 (required, retyped to ZM-PC-package), error 8/0. Dispatch on 11/3.
   - `describe_class`: public, dynamic true.
   - Body: Read protocol → ZM-CP-publish(package) → Write protocol → Read publishedCount → Increment → Write publishedCount, on one error chain.
   - **The 1003 is gone.** Right after this step the cold sweep read 9/9 state 1, where 08a had six members at state 0. So 08a's "error of type 8" was the missing interface override.

4. **Library.**
   - Cached `zm_create_class_library.vi`, project open and active: create, save, add 1 and save-all errors all 0.
   - The close replaced the class item with the library item; `lvproj_drop` was not needed.
   - `lvproj_move.py "ZM-CM-communication_manager.lvlib" actors`. Reopen + close: no further change.
   - `.lvproj` lines 15-17: `<Item Name="actors" Type="Folder">` / `<Item Name="ZM-CM-communication_manager.lvlib" Type="Library" URL="../actors/ZM-CM-communication_manager/ZM-CM-communication_manager.lvlib"/>` / `</Item>`.

5. **AF overrides** (`ops\override.md` blocks; exports in `proof\ZMP-08b\export-*.xml`):
```
override CM:Pre Launch Init created yes (7 errors 0)  protected  dynamic  member  folder asked (AF Overrides, D38)
hooks: ZM-CM-createResources shape B-after (class+error)  helper errors 0  hits panel A 2, B 0, wire A 2  saved by pa_save_member
override CM:Stop Core created yes  protected  dynamic  member  folder asked
hooks: ZM-CM-releaseProtocol B-after block A only (B skipped, idx -1)  errors 0  hits A 1, wire A 2  pa_save_member
       + Clear Errors via af_add_hook_call_node (source `error out`, hook `error in (no error)`)  errors 0  source hits [1,0]  pa_save_member
override CM:Handle Error created yes  protected  dynamic  member  folder asked
hooks: ZM-CM-evaluateError shape E-after (B-after on class + error out)  errors 0  hits A 1, B 3, wire A 2  pa_save_member
unmeasured shapes used: F (case in createResources), B-after on Stop Core, Clear Errors node on Stop Core, E-after on Handle Error   user asked: no (brief-prescribed)
sweep 13/13, control 0 7, membership ok   export ok   run order: not run (step c)
```
   - **Export order:**
     - PLI: Call Parent (`Actor out`, `error out`) → createResources → both indicators.
     - Stop Core: Call Parent → releaseProtocol (error in unwired) → class indicator; releaseProtocol `error out` → Clear Errors.
     - Handle Error: Call Parent → evaluateError (class, error) → class out and error out. `stop actor?` indicator ← Call Parent's `stop actor?`; evaluateError's `stop actor? in` and `stop actor? out` stay unwired (the shape the brief chose).

6. **Checks** (project closed):
   - Cold sweep: 13/13 state 1, control `0 7`. Also after step 4 (9/9), after step 3 (10/10) and with the bare overrides (13/13).
   - `check_membership`: 13 checked, 0 not a member, exit 0.
   - `lv_save_version`: every file is 26 (VIs 26:x, `.ctl` 26:4, `.lvclass`/`.lvlib` 26008000, `.lvproj` 26.0).
   - `--links` (with `--vilib` of 2026): links go only into the CM folder, `ZM-CI` (Msg class, Send), `ZM-CP-communication_protocol.lvclass`, `ZM-PC` (package, EP class, EP-create) and `ZM-CU-log`. Forbidden-pattern hits: **0**.
   - Scopes from the XML: createResources, evaluateError and releaseProtocol private 2/2; the 3 AF overrides protected 3/3; handlePackage and writePrelaunchSettings public.

7. **Commits** (not pushed): a4c3ee7, 274ebcf, 749b8c3, 855e2dc, 093cb2c, bce4dc5, 44afe72, 52ea716, 81b8157, 7e4c648, bc3ecb7, d1f94ea, 17ce3f9. `git status --short`: only `?? runs/.../notes-for-run-02.md`, which is not mine. Nothing outside the CM folder and the `.lvproj` changed.

8. **Deviations, unmeasured steps, items for the user.**
   - (a) **Rule breach:** the PLI and Stop Core exports were sent in one message. Both are read-only and both answered 0.
   - (b) **createResources:** Write protocol is fed the read's error, so the write runs after a failed init. The accessor has an error case and would otherwise skip the write, and the release would then close the default object. Not in the brief.
   - (c) **Hand-made stub** `LVMCP Stub ZMP08b-readPrelaunchSettings.vi`, typed cluster{path.protocol}, generated into `user.lib\LV_MCP`. The tool's stub typed the settings cluster as a scalar path, and validation refused the Unbundle.
   - (d) **Build order:** I built evaluateError, releaseProtocol and handlePackage first, then createResources (it needs a releaseProtocol stub).
   - (e) **Commits:** the three bare overrides are one commit (81b8157), because they share one `.lvclass`.
   - (f) Clear Errors' hook terminal is `error in (no error)`, not `error in`. Its `error out` is unwired.
   - (g) **Diagram width:** evaluateError has a 13-stage chain and releaseProtocol 11 (budget 10); no subVI was invented, left for step c.
   - (h) **Not measured here** (step c needs LabVIEW): the forced-failure launch for shape F, a run-order log, and the Handle Error behaviour.
   - **For the user in the IDE (D38):**
     - The CM class description (text in report 08a).
     - Overrides into `AF Overrides`: Pre Launch Init, Stop Core, Handle Error.
     - Into `Methods`: ZM-CI-handlePackage, the 3 hooks and writePrelaunchSettings.
     - Into `TypeDefs`: `ZM-CM-PRELAUNCH_SETTINGS.ctl`.
     - The AF overrides keep NI's VI descriptions.

9. **Side effects.**
   - The project was opened and closed by the tools about 9 times. `.aliases`, `.lvlps` and `.UserState` were rewritten (git-ignored).
   - The probe was adopted into the `.lvproj` and dropped with `lvproj_drop.py` (1 line).
   - The library Save All re-saved all CM members.
   - New stubs in `user.lib\LV_MCP`: fa1374cfd0, fbed2c3960, 7186ef06e8, 19734a74e5, 85eded684e, 1d9cf0b035, 0626c40994, 148ce4c519, and ZMP08b-readPrelaunchSettings.
   - `proof\ZMP-08b\` (git-ignored) holds the AIXML sources, the probe VI and its readings, the sweeps, exports, links and save versions.
   - The tool's bundles are under `%TEMP%\LabVIEWMCP`.
