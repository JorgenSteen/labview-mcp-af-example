# Report 09b: HWM role hooks, evaluateError, ZM-CI-handlePackage, library, PLI and Handle Error (2026-10-11 11:58 to 12:10)

**DONE.** Every name comes from 02 §7.11. The final cold sweep reads 14/14 at state 1, control `0 7`. There is no NEEDS CLARIFICATION. I made about 44 LabVIEW calls, each sent alone in its own message, offline ones and exports included.

1. **Status**
   - Start (11:58): `lvai_status` ok, port 59983, PID 14516, 1.9.5-local (f9ee41d9), up 3286 s, dwarn 4.
   - End (12:09): same port, up 3950 s, dwarn 4, not degraded.
   - LabVIEW starts made: 0. The project is closed. `lv_windows`: 0 dialogs, LVAutoSave 0. The 8 "unsaved" windows are the tool's hidden `LVMCP Validate*` windows.

2. **Hooks** (pane 4815: class 11/3, `error in (no error)` 8, `error out` 0; private 2/2, static; cold state 1 each)
   - Route: AIXML in `proof\ZMP-09b\`, `lvai_add_class_method`, then `lvai_swap_subvis`.
   - **createEvents:** Read events → Create User Event (Boolean constant labelled `stop`) → Bundle By Name `stop` → Write events, on one error chain. Read events supplies the input cluster for the Bundle.
   - **stop:** Read events → Unbundle `stop` → Generate User Event (T). The error passes through.
   - **close:** Read events on a fresh chain → Unbundle → Destroy User Event → Clear Errors (`error in (no error)`). Then Merge Errors(`error in`, Clear Errors out) → `error out`, so an incoming loop or stop error still reaches the Actor Core merge.
   - The 3 hooks went in with one `add_class_method` call and one `swap_subvis` call (editsJson). Read events stub `5a8dc87c83`: the tool flattened it to the real type `cluster{ref{UserEvent}{bool.stop}.stop}`, so the scalar-path trap from 08b did not occur.
   - **createResources (shape F):** createEvents → case on its error. Error frame: `close` on a fresh chain, then Merge Errors (frame error first). No Error frame: pass through.
     - createEvents and close have the same pane signature, so the tool would give them one shared stub. I hand-made `LVMCP Stub ZMP09b-close.vi` (generated into `user.lib\LV_MCP`) so the swap lands reliably.
     - The export with `aixml_frames.py` confirms close and Merge are in the Error frame.
   - **evaluateError:** the CM's AIXML with sender `"HWM"` and log text `HWM\t<code>\t<source>`. Same pane: `stop actor? in` 10 (default T), `stop actor? out` 2. The 4 reused stubs were swapped to ZM-CU-log, ZM-PC-EP-create, Read Caller Enqueuer and Send ZM-CI-handlePackage.

3. **Interface override `ZM-CI-handlePackage.vi`**
   - Pane 4815: class 11/3, `package` 10 (required, retyped to `ZM-PC-package.lvclass`), error 8/0. Dispatch terminals [11, 3]. Public (MethodScope 1).
   - Body: Read packageCount → Increment → Write packageCount → Read Caller Enqueuer → Send ZM-CI-handlePackage(package). The Send error goes to Clear Errors, then Merge Errors(Write's error, cleared) → `error out`.
   - **The type-8 break is gone:** the cold sweep right after this step read 12/12 at state 1, where 09a had six members at state 0.

4. **Library**
   - Cached `zm_create_class_library.vi`, project open and active: create, save, add 1 and save all errors all 0.
   - The close replaced the class item with the library item; no drop was needed. The `.lvproj` was CRLF with a BOM (checked by bytes: 41 CRLF of 41 LF).
   - `lvproj_move.py "ZM-HWM-hardware_manager.lvlib" actors`: CRLF and BOM kept. Reopen + close: no further change. Sweep 12/12 afterwards.
   - `.lvproj` lines 15-18: `<Item Name="actors" Type="Folder">` / `ZM-CM-communication_manager.lvlib` / `<Item Name="ZM-HWM-hardware_manager.lvlib" Type="Library" URL="../actors/ZM-HWM-hardware_manager/ZM-HWM-hardware_manager.lvlib"/>` / `</Item>`.
   - No top-level LVClass item is left.

5. **AF overrides** (exports in `proof\ZMP-09b\export-*.xml`)
```
override HWM:Pre Launch Init created yes (7 errors 0)  protected 3/3  dynamic  member  folder asked (AF Overrides, D38)
hooks: ZM-HWM-createResources shape B-after (class+error; hook out B = `error in (no error)`)  helper errors 0
       panel idx A 2, B 0, wire A terminals 2  saved by pa_save_member (all 0)
override HWM:Handle Error created yes (7 errors 0)  protected 3/3  dynamic  member  folder asked
hooks: ZM-HWM-evaluateError shape E-after (B-after on class + error out)  errors 0  panel idx A 1, B 3, wire A 2  pa_save_member
unmeasured shapes used: F (case in createResources), E-after on Handle Error   user asked: no (brief-prescribed)
sweep 14/14, control 0 7, membership ok   export ok   run order: not run (step d)
```
   - **Export order:**
     - PLI: Call Parent (`Actor out`, `error out`) → createResources (class, `error in (no error)`) → `error out` and class out.
     - Handle Error: Call Parent (`error in (no error)` in) → evaluateError (class, error) → class out and `error out`. The `stop actor?` indicator takes Call Parent's `stop actor?`. evaluateError's `stop actor? in/out` stay unwired, as on the CM.
   - **Descriptions:** `pa_replace_description` (description only, project closed, no regeneration) replaced NI's help text on both overrides with HWM-specific text: 1 replacement each, error 0. Commit 08cb7e7. These texts are mine, not from the spec; please review them.

6. **Checks** (project closed)
   - Cold sweep of the class folder: 14/14 state 1, control `0 7`. The earlier sweeps read 12/12 after step 4 and 12/12 after the library.
   - `check_membership.py`: 14 checked, 0 not a member, exit 0.
   - `lv_save_version.py`: every file is 26.
     - VIs read 26:3 or 26:5; Pre Launch Init also carries the stamp `24:1 26:3`, as the CM's does.
     - `.ctl` 26:4; `.lvclass` and `.lvlib` 26008000; `.lvproj` 26.0.
   - `lv_loadability.py --links --vilib` on all 14 VIs: links go only to the HWM folder, ZM-CI (Msg class, Send), ZM-CU-log, ZM-PC (package, EP class, EP-create), `ZM-HW-hardware.lvclass` (the parent) and vi.lib. Forbidden ZM-HW-SIM/ZM-CM/ZM-ROOT/ZM-CP: **0**.
   - Scopes from the XML: 5 accessors and 5 hooks private 2/2; PLI and Handle Error protected 3/3; handlePackage and writePrelaunchSettings public 1.

7. **Commits** (explicit paths, no trailer, not pushed)
   - 5575e6b, b52628a, 1f910ba, efd43de, d28e722, b986293, d2a6196, 687e191, 4523acf, 08cb7e7.
   - `git status --short`: only `?? runs/.../notes-for-run-02.md`, which is not mine.
   - `git diff 77f8b8e HEAD` outside the HWM folder: only the `.lvproj` (1 line moved).

8. **Deviations, unmeasured points, items for the user**
   - (a) createEvents reads the events field first, so Bundle By Name has a typed source. The spec says "Create → Bundle By Name → Write" and does not name the source of the input cluster.
   - (b) close and handlePackage end in Merge Errors, so Clear Errors' `error out` is consumed and `error in` / the accessor error still go out. For close this means Actor Core's merged loop/stop error is not swallowed.
   - (c) The bare overrides were committed without their own cold read; the sweep after hooking covers them.
   - (d) Unmeasured here (step d needs a run): the forced-failure launch for shape F, the run order, and Handle Error on a real error.
   - (e) The 08b/08c width note may apply to evaluateError (13-stage chain). It was not measured here.
   - **For the user in the IDE (D38):**
     - The class description (the 09a text).
     - `Pre Launch Init.vi` and `Handle Error.vi` into `AF Overrides`.
     - ZM-CI-handlePackage, the 5 hooks and writePrelaunchSettings into `Methods`.
     - `ZM-HWM-PRELAUNCH_SETTINGS.ctl` and `ZM-HWM-EVENTS.ctl` into `TypeDefs`.

9. **Side effects**
   - The project was opened and closed by the tools 7 times; the close sweeps removed nothing. `.aliases` and `.lvlps` were rewritten (git-ignored).
   - The library Save All re-saved all 12 members at the time.
   - New stubs in `user.lib\LV_MCP`: 5a8dc87c83, e34c8b64bf, d0abb2169c, f711bf34d9, ded47d1712, and the hand-made ZMP09b-close.
   - `proof\ZMP-09b\` (git-ignored) holds: the AIXML sources, `desc_inputs.py`, the exports, the sweep lists and results, links and save versions.
   - The tool's bundles are under `%TEMP%\LabVIEWMCP`.
   - Nothing else was written outside the product folder.
