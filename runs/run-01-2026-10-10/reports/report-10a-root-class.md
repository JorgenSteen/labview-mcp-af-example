# Report 10a: ZM-ROOT-root class, typedefs, fields, accessors and writePrelaunchSettings (2026-10-11 14:57 to 15:03)

**DONE.** Every name comes from 02 §7.12. I made nothing extra. I made 24 LabVIEW calls, one per message. No NEEDS CLARIFICATION.

1. **Status**
   - Start (14:57): `lvai_status` ok, port 59983, PID 14516, 1.9.5-local (f9ee41d9), up 14050 s, dwarn 22, not degraded.
   - End (15:03): same port and PID, up 14367 s, dwarn 22, not degraded.
   - Starts made: 0. Project CLOSED. `lv_windows`: 0 dialogs. The 12 "unsaved" windows are the tool's hidden `LVMCP Validate*` windows.
2. **Typedefs** (`lvai_create_typedef`, no projectPath; verifiedFromFile typedef, needsLabviewSave false)
   - `ZM-ROOT-PRELAUNCH_SETTINGS.ctl`: `describe_ctl` Cluster {outputFolder: Path, usePlaceholderHardware: Boolean}, bindable.
   - `ZM-ROOT-EVENTS.ctl`: `describe_ctl` Cluster {stop: Refnum, error: Refnum}, bindable.
3. **Class** (`describe_class`, read from the file)
   - Inherits from `Actor Framework.lvlib:Actor.lvclass`. Interface `ZM-CI-common_interfaces.lvlib:ZM-CI-package_handler.lvclass`. Parent opened 1, interfaces linked 1.
   - Fields, in 02 order: prelaunchSettings TypeDef `ZM-ROOT-PRELAUNCH_SETTINGS.ctl` (bound); cmEnqueuer Refnum UDClassInst; hwmEnqueuer Refnum UDClassInst; cmRunning Boolean; lastPackageType TypeDef `ZM-PC-PACKAGE_TYPE.ctl` (bound); packageCount NumUInt32; events TypeDef `ZM-ROOT-EVENTS.ctl` (bound).
   - Bindings:
     - The 3 typedefs bound in one call: boundInFile true each.
     - The 2 enqueuers bound with `force:true`: `ok:false`, as expected.
     - `grep -a` finds `Message Enqueuer.lvclass` in the members' link info.
   - `lvai_create_class` (1.9.5) now works in a throwaway scratch project and writes the class entry into our `.lvproj`. It still added the stray `Actor.lvclass` item. The `.lvproj` was LF without BOM, so I used `proof\ZMP-09a\lvproj_drop_eol.py`: 1 line removed, 2995 bytes, LF kept. The next close put CRLF and the BOM back.
   - Members from the XML, all static (from the pane):
     - Folder `Accessors`, private (MethodScope 2 and LibItem.Scope 2), 11 VIs: Read prelaunchSettings; Read/Write cmEnqueuer; Write hwmEnqueuer; Read/Write cmRunning; Write lastPackageType; Read/Write packageCount; Read/Write events.
     - Class root: `ZM-ROOT-writePrelaunchSettings.vi`, public (MethodScope 1).
   - New measurement: `accessUi:"Write"` makes one VI only, as `"Read"` does. `remove_members.py` was not needed.
   - Pane typedefs: Read/Write events carry `ZM-ROOT-EVENTS`, Read prelaunchSettings carries `ZM-ROOT-PRELAUNCH_SETTINGS`, Write lastPackageType carries `ZM-PC-PACKAGE_TYPE`.
4. **Custom accessor** `ZM-ROOT-writePrelaunchSettings.vi`
   - Source: `proof\ZMP-10a\ZM-ROOT-writePrelaunchSettings.xml`, the HWM template. The class stand-in is a cluster that mirrors the 7 fields (path stand-ins for the enqueuers, the enum for lastPackageType).
   - Pane 4815: class in 11 (optional), settings 10 (required), error in 8, class out 3, error out 0.
   - `lvai_add_class_method`: `ok:false` at verify, `pathStandInsLeft 1`. That is the `outputFolder` path inside `settings`, as expected. classTypedTerminals 2, add member error 0.
   - `lvai_bind_pane_typedef` on `settings`: verified true, typedefInSavedFile true.
   - Export (`proof\ZMP-10a\export-ZM-ROOT-writePrelaunchSettings.xml`):
     - class in and class out are `ref{UDClassInst}`.
     - `Bundle By Name fields="prelaunchSettings"`; the error passes straight through.
     - The description is set.
   - Cold state 0, as expected: "VI has an error of type 8. The full development version of LabVIEW is required to fix the errors." Step b adds the interface override that clears it.
5. **Sweep, membership, versions** (project closed)
   - Cold sweep of `src\actors\ZM-ROOT-root`: 12 VIs, all state 0 code 0 (the expected type-8 break at class level), control `0 7`, ok count 0, 2.9 s. Step b must bring all 12 to 1.
   - `check_membership.py`: 12 checked, 0 not a member, exit 0.
   - `lv_save_version.py`: all 26 (VIs 26:5 and 26:3, `.ctl` 26:4, `.lvclass` 26008000, `.lvproj` 26.0 with SaveVersion 26.0). Saved in `proof\ZMP-10a\ZMP-10a-save-versions.txt`.
6. **Commits** (explicit paths, no trailer, not pushed)
   - 2670a13 (PRELAUNCH_SETTINGS), 7138350 (EVENTS)
   - b360ebb (class + `.lvproj`)
   - 4f7e747 (bindings; the close restored the `.lvproj` BOM)
   - 1502434 (accessors), 84a01e4 (scopes)
   - c32ec2c (custom accessor)
   - `git diff c5a6e14 HEAD` on the product: only `src\actors\ZM-ROOT-root\` (15 files) and the `.lvproj` (+1 line: the ROOT class item).
   - `git status --short`: only `?? runs/.../notes-for-run-02.md`, which is not mine.
7. **Deviations, unmeasured points, items for the user**
   - No deviation from the brief.
   - The 1.9.5 `lvai_create_class` scratch-project route differs from 09a, with the same stray item.
   - Git's `.gitattributes` (`text=auto eol=lf`) warns that it will turn the `.lvclass`/`.lvproj` CRLF into LF. This was already the case before; it is the source of the LF `.lvproj` (F10).
   - The class mirror in the AIXML is a stand-in only. The export proves it was retyped.
   - **For the user in the IDE (D38):**
     - Class description, the brief's text: "Root actor: launches the communication manager (CM, first) and the hardware manager (HWM) from its Actor Core with their pre-launch settings, routes every package by destination (Communication → forwarded to the CM while it runs; Root → an error package is shown on the panel; Unknown and Hardware → dropped with one log line), and shows its panel loop helperPanel with the Stop button and the errors list. Error plan (D40, for now): evaluateError is a pass-through; an error stops the root and, through AF's Stop Core, the whole tree; a child's error reaches the root through its Last Ack and stops it."
     - Put `ZM-ROOT-PRELAUNCH_SETTINGS.ctl` and `ZM-ROOT-EVENTS.ctl` into the class's `TypeDefs` folder. Neither is a class member now.
     - `ZM-ROOT-writePrelaunchSettings.vi` is at the class root; whether it goes into `Methods` is the user's call.
8. **Side effects**
   - The project was opened and closed by the tools 4 times. `.aliases`/`.lvlps` were rewritten (git-ignored).
   - Scratch class projects `%TEMP%\LabVIEWMCP\classes\ZM-ROOT-root-10020-17c3fb4` and `...-14156-26b476f`; typedef carriers under `...\typedefs\`; a pylv bundle under `...\bundles\`.
   - `proof\ZMP-10a\` (git-ignored) holds the AIXML, the export, `sweep_0.txt`, the save versions and `lvproj-before.lvproj.txt`.
   - No helper was regenerated and nothing went to `user.lib`. Nothing was written outside the product folder except those `%TEMP%` items.
