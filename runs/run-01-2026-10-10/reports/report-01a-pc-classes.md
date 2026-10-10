# Report 01a: three package classes, five typedefs, fields bound, accessors (2026-10-10 15:38-15:45)

DONE except the three class descriptions (NEEDS CLARIFICATION, item 8). Every name from 02 §7.1, nothing extra.

1. lvai_status start 15:38: ok, port 59552, up 865 s, PID 14040, labview-mcp 1.9.5-local (f9ee41d9), dwarn 0, LVAutoSave 0. End 15:45: ok, port 59552, up 1271 s, dwarn 0. LabVIEW starts made: none. No crash, no DeadlineExceeded, no dialog (lv_windows.ps1 after every close: unsaved 0, dialogs 0).

2. Per class (all calls strictly sequential, one per message):
- ZM-PC-package: create_typedef x3 (ok, verifiedFromFile typedef, needsLabviewSave false) -> describe_ctl HEADER (cluster timestamp/type/destination String) -> create_class fields `timestamp.timestamp,typedef.type,typedef.destination` + typedefFieldsJson + projectPath (ok; scratch project for the provider, then bind in the real project with boundInFile true for type and destination, project closed by the tool) -> describe_class: fields timestamp MeasureData (plain), type TypeDef ZM-PC-PACKAGE_TYPE.ctl, destination TypeDef ZM-PC-DESTINATION.ctl, inheritsFrom LabVIEW Object -> open_file (projectBecameActive true) -> create_accessors fromField 0/1/2, fieldCount 1, R/W, dynamicDispatch false, folder Accessors (6 VIs, membersAfter 6, moreToDo false) -> describe_class: 6 members, all dynamicDispatch false (connectorPane), pane terminals ZM-PC-PACKAGE_TYPE / ZM-PC-DESTINATION -> close_active_project (closed true, sweep removed nothing) -> set_scope.py: Read/Write timestamp 2, Write type 3; Read type, Read/Write destination 1 (unchanged). XML: MethodScope+LibItem.Scope 2/2/3 on those three, 1 on the rest, folder `Accessors`.
- ZM-PC-TP-test_package: create_typedef ZM-PC-TP-DATA (ok) -> describe_ctl: temperature_c NumFloat64, sample_index NumInt32, duty_percent NumUInt8, sensor_ok Boolean, status String, in that order -> create_class parentClassPath=ZM-PC-package.lvclass, `typedef.data` (parent opened 1, boundInFile true) -> describe_class: parentLinks ZM-PC-package.lvclass (Parent Libraries item), field data TypeDef ZM-PC-TP-DATA.ctl -> open_file -> create_accessors fromField 0 (Read data, Write data; static) -> close -> set_scope.py Write data 2. XML: Read data 1, Write data 2/2.
- ZM-PC-EP-error_package: same route; ZM-PC-EP-DATA sender String, code NumInt32, source String; parent ZM-PC-package.lvclass; field data TypeDef ZM-PC-EP-DATA.ctl; Read data public, Write data private (2/2); static.

3. The five .ctl (all `...\src\common\ZM-PC-packages\`): ZM-PC-package\ZM-PC-PACKAGE_TYPE.ctl, ZM-PC-DESTINATION.ctl, ZM-PC-HEADER.ctl; ZM-PC-TP-test_package\ZM-PC-TP-DATA.ctl; ZM-PC-EP-error_package\ZM-PC-EP-DATA.ctl. Each: verifiedFromFile isTypedef true, strict false, wrappedType TypeDef, needsLabviewSave false. NONE is a class member (no tool adds a .ctl to a class: known gap `add-to-class`); they are flat in the class folders and not listed in the .lvproj either (Dependencies only when loaded).

4. Sweep (ops/sweep.md), after the last close:
```
cold sweep src\common\ZM-PC-packages  labview-mcp 1.9.5-local  LabVIEW up 1250 s  baseline none: new code
not loadable: none
batch 0  10 VIs  10/10 state 1  control 0 7  0.27 s
not state 1: none
membership: checked 10 (6+2+2)  not a member 0 (0 new, 0 pre-existing)  plain 0   (check_membership.py exit 0 per folder)
git: unchanged   side effects: project closed x3 (lvproj rewritten only by the tool's own class-entry writes)
LabVIEW calls 1   sweep calls 0.27 s in total
```
Report saved: proof\ZMP-01a\ZMP-01a-sweep-after-0.txt, sweep_0.txt (git-ignored).

5. lv_save_version.py, all 26: Zuehlke MCP.lvproj (SaveVersion=26.0); ZM-PC-package.lvclass, ZM-PC-TP-test_package.lvclass, ZM-PC-EP-error_package.lvclass (LVVersion=26008000); 10 VIs (26:5); 5 .ctl (26:4). No file newer than 26.0.

6. .lvproj under My Computer after the last close (lines 15-25): the six folders actors, common, hardware, protocol, receiver, tests; `<Item Name="ZM-PC-EP-error_package.lvclass" Type="LVClass" URL="../common/ZM-PC-packages/ZM-PC-EP-error_package/ZM-PC-EP-error_package.lvclass"/>`, `<Item Name="ZM-PC-package.lvclass" Type="LVClass" URL="../common/ZM-PC-packages/ZM-PC-package/ZM-PC-package.lvclass"/>`, `<Item Name="ZM-PC-TP-test_package.lvclass" Type="LVClass" URL="../common/ZM-PC-packages/ZM-PC-TP-test_package/ZM-PC-TP-test_package.lvclass"/>`; Dependencies; Build Specifications. Each class once; the predicted duplicate parent entry did not appear (this plugin build opens the parent from its path), so lvproj_drop.py was not needed and not run.

7. Commits (newest last): 63c4179 feat(pc): typedefs ZM-PC-PACKAGE_TYPE, ZM-PC-DESTINATION, ZM-PC-HEADER; 60b06a1 feat(pc): class ZM-PC-package with fields timestamp, type, destination; 727ee40 feat(pc): six static accessors of ZM-PC-package with scopes; 404b897 feat(pc): typedef ZM-PC-TP-DATA; 607ac93 feat(pc): class ZM-PC-TP-test_package with field data; e65fafe feat(pc): accessors Read data (public) and Write data (private) of ZM-PC-TP-test_package; f8f6094 feat(pc): typedef ZM-PC-EP-DATA; cb0581c feat(pc): class ZM-PC-EP-error_package with field data; 0148c39 feat(pc): accessors Read data (public) and Write data (private) of ZM-PC-EP-error_package. All by explicit paths, no trailer, not pushed. `git status --short` at the end: `?? runs/run-01-2026-10-10/briefs/brief-01b-pc-methods-library.md` only (the manager's file, present since my first commit; not mine).

8. Deviations / decisions:
- NEEDS CLARIFICATION: the three class descriptions (hygiene.descriptions) were NOT set. No labview-mcp tool takes a class description (lvai_create_class has no such parameter), no kit script writes NI.Lib.Description, the plugin's docs say the property is "usually absent", and the only VI Server route ({LV.Library} Description) is an unmeasured name that I may not probe (today's crash trap). A byte-exact text edit of the .lvclass would be a hand edit outside the kit. Options for the user: (a) set the three descriptions by hand in the IDE (class Properties > Documentation) and commit; (b) allow a kit-style byte-exact script that inserts `<Property Name="NI.Lib.Description" Type="Str">...</Property>` into the closed .lvclass; (c) defer to step b/d. Texts are in the brief.
- Accessors: the wizard made both directions per field as listed; no unlisted accessor arose, so remove_members.py was not needed.
- The timestamp field was passed as `timestamp.timestamp`; describe_class reports it as MeasureData (LabVIEW's Time Stamp), not a typedef, as intended.
- The `.ctl` typedefs are not class members (item 3), so `layout.typedef-placement` (member of the class, TypeDefs folder) is NOT met by any tool; left for the user/IDE.

9. Side effects: files written by LabVIEW only inside src\common\ZM-PC-packages\ (3 .lvclass, 10 .vi, 5 .ctl) and src\Zuehlke MCP.lvproj (class entries added by the tool; the three closes saved it, no entry removed; .aliases/.lvlps/.UserState rewritten, git-ignored). The three .lvclass were then edited offline by set_scope.py only (project closed). Helper VIs left (all pre-existing, none generated by me): lvai_run_and_read_typed.vi, lvai_create_class.vi, lvai_create_accessors.vi, lvai_close_active_project.vi, pa_exec_state_sweep.vi; the tools left carrier VIs and scratch projects under %TEMP%\LabVIEWMCP\typedefs\ and \classes\ (the plugin's own work dirs). Nothing written outside the product folder except proof files inside it (git-ignored). LabVIEW restarts: none. Project state at the end: closed, no active project, no unsaved window.
