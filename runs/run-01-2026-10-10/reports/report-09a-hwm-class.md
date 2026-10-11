# Report 09a: ZM-HWM-hardware_manager class, typedefs, fields, accessors and writePrelaunchSettings (2026-10-11 11:49 to 11:56)

**DONE, with one kit bug found and worked around** (item 7a). Every name comes from 02 §7.11 and I made nothing extra. I made about 27 LabVIEW calls, one per message. There is no NEEDS CLARIFICATION.

1. **Status**
   - Start (11:50): `lvai_status` ok, port 59983, PID 14516, 1.9.5-local (f9ee41d9), up 2768 s, dwarn 4.
   - End (11:55): same port and PID, up 3115 s, dwarn 4, not degraded.
   - LabVIEW starts made: 0. The project is closed. `lv_windows`: 0 dialogs, LVAutoSave 0. The 8 "unsaved" windows are the tool's hidden `LVMCP Validate*` windows.

2. **Typedefs** (`...\src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\`)
   - **`ZM-HWM-PRELAUNCH_SETTINGS.ctl`**, by the 08a route:
     - `lvai_create_typedef` with `cluster{path.hardware,uint32.intervalMs}`: ok, typedef, needsLabviewSave false.
     - With the project open and active, the `zm_cluster_element_replace.vi` helper (index 0) answered error 0, label after `hardware`, count 2, typedef flag 3. `grep -a` finds `ZM-HW-hardware.lvclass` in the `.ctl`.
     - **Default 500:** I derived a new helper, `proof\ZMP-09a\zm_cluster_element_default_u32.xml`. It writes `{LV.Control} Default Value` on element index 1 through To Variant, reads it back, then Save.Instrument. Answer: error 0, `default after` 500, label `intervalMs`.
     - The saved file confirms the default: the export of writePrelaunchSettings shows `settings value="[,500]"`, although the AIXML authored `[,0]`. So the default is in the typedef itself.
     - `describe_ctl`: Cluster {hardware: Refnum, intervalMs: NumUInt32}, bindable.
   - **`ZM-HWM-EVENTS.ctl`**: `cluster{ref{UserEvent}{bool.stop}.stop}`, no projectPath, ok. `describe_ctl`: one element `stop`, Refnum. The pilot measured this spelling; `describe_ctl` does not show the user-event subtype.

3. **Class** (`describe_class`, read from the files)
   - Inherits from `Actor Framework.lvlib:Actor.lvclass`. Interface: `ZM-CI-common_interfaces.lvlib:ZM-CI-package_handler.lvclass`. Parent opened 1, interfaces linked 1.
   - Fields:
     - `prelaunchSettings`: TypeDef `ZM-HWM-PRELAUNCH_SETTINGS.ctl`, boundInFile true.
     - `packageCount`: NumUInt32.
     - `events`: TypeDef `ZM-HWM-EVENTS.ctl`, boundInFile true.
   - Route: placeholders at creation, then one `lvai_bind_class_fields` call for both, as in 08a.
   - Members from the XML, all static (from the pane):
     - Folder `Accessors`, MethodScope and LibItem.Scope 2/2: Read events, Read packageCount, Read prelaunchSettings, Write events, Write packageCount.
     - Class root: `ZM-HWM-writePrelaunchSettings.vi`, public (MethodScope 1).
     - `accessUi:"Read"` gave one VI only, so nothing had to be removed.
   - Pane typedefs: Read/Write events carry `ZM-HWM-EVENTS`, Read prelaunchSettings carries `ZM-HWM-PRELAUNCH_SETTINGS`.
   - `.lvproj`: the class is listed once (line 37). The stray `Actor.lvclass` item was dropped (item 7a). The interface was not added.

4. **Custom accessor `ZM-HWM-writePrelaunchSettings.vi`**
   - Source: `proof\ZMP-09a\ZM-HWM-writePrelaunchSettings.xml`, the 08a template.
   - Pane 4815: class in at 11 (optional), `settings` at 10 (required), error in 8, class out 3, error out 0.
   - `lvai_add_class_method` answered `ok:false` at verify with `pathStandInsLeft 1`, as expected (the `hardware` path inside `settings`): classTypedTerminals 2, add member error 0.
   - `lvai_bind_pane_typedef` on `settings`: verified true, typedefInSavedFile true.
   - Export (`proof\ZMP-09a\export-ZM-HWM-writePrelaunchSettings.xml`):
     - class in and class out are `ref{UDClassInst}`.
     - `settings` is `cluster{ref{UDClassInst}.hardware,uint32.intervalMs}`.
     - `Bundle By Name fields="prelaunchSettings"`; the error passes straight through.
   - The description is set.
   - Cold state 0, as expected: "VI has an error of type 8. The full development version of LabVIEW is required to fix the errors." This is the missing interface override, which step b adds.

5. **Sweep, membership, versions** (project closed)
   - Cold sweep of `src\actors\ZM-HWM-hardware_manager`: 6 VIs, all state 0 code 0, control `0 7`, ok count 0, 1.3 s. That is the expected class-level break; step b must bring all six to state 1.
   - `check_membership.py`: 6 checked, 0 not a member, exit 0.
   - `lv_save_version.py`: all 26 (VIs 26:5 and 26:3, `.ctl` 26:4, `.lvclass` 26008000, `.lvproj` 26.0). Saved in `proof\ZMP-09a\ZMP-09a-save-versions.txt`.

6. **Commits** (explicit paths, no trailer, not pushed)
   - 2822f5c, 59b7eaa (PRELAUNCH_SETTINGS); 36fc677 (EVENTS)
   - 5165977 (class + `.lvproj`); e4f0eea (bindings; the close put the `.lvproj` BOM back)
   - a90ca2d (accessors); 34d07ac (accessor scopes)
   - e0337ea (custom accessor)
   - `git status --short` at the end: only `?? runs/.../notes-for-run-02.md`, which is not mine.
   - `git diff 6c9fdf2 HEAD` on `src\common`, `src\hardware`, `src\protocol`, `src\tests` and the CM folder: empty.

7. **Deviations, unmeasured points and items for the user**
   - (a) **Kit bug: `lvproj_drop.py` emptied the `.lvproj`.** It splits on CRLF only, and `lvai_create_class` had written the file with LF. One "removed 1 line" call wrote a 0-byte file. What I did:
     - Restored the file with `git checkout`, project closed.
     - Re-ran `lvai_create_class` with `overwrite:true`; the class had no members yet.
     - Dropped `Actor.lvclass` with `proof\ZMP-09a\lvproj_drop_eol.py`, a copy of the kit script that keeps the file's own line ending and refuses to write when it would remove nothing or nearly everything. It removed 1 line, LF kept.
     - The kit script needs that fix. After a LabVIEW close the file is CRLF, which is why 08a did not hit this.
   - (b) The default-value helper is new and was measured once. The 500 is proven through the export, not by an offline decode of the `.ctl`.
   - (c) As in 08a, writePrelaunchSettings always bundles and passes the error through.
   - **For the user in the IDE (D38):**
     - Set the class description to the brief's text: "Hardware manager actor: owns a hardware object from its pre-launch settings; its helper loop ZM-HWM-helperAcquisition calls the hardware every intervalMs … sends Normal Stop to this actor."
     - Put `ZM-HWM-PRELAUNCH_SETTINGS.ctl` and `ZM-HWM-EVENTS.ctl` into the class's `TypeDefs` folder. Neither is a class member now.
     - `ZM-HWM-writePrelaunchSettings.vi` is at the class root; whether it goes into `Methods` is the user's call.

8. **Side effects**
   - The project was opened and closed by the tools 5 times. The first close dropped the `.lvproj` BOM; I restored it from git. `.aliases`/`.lvlps` were rewritten (git-ignored). The close sweep removed the adopted helper `zm_cluster_element_default_u32.vi` from the `.lvproj`.
   - New helper `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\zm_cluster_element_default_u32.vi`.
   - Two scratch class projects under `%TEMP%\LabVIEWMCP\classes\ZM-HWM-hardware_manager-*`; typedef carriers under `...\typedefs\`; a pylv bundle under `...\bundles\`.
   - `proof\ZMP-09a\` (git-ignored) holds: both helper and method XMLs, the export, `lvproj_drop_eol.py`, `lvproj-before.lvproj.txt`, `sweep_0.txt` and the save versions.
   - No stubs were written to `user.lib`. Nothing was written outside the product folder except those `%TEMP%` items.
