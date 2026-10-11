# Brief 12f: D38 items by LabVIEW's own scripting - probe on ONE class, `ZM-PC-package`
Type: probe + build (LabVIEW calls). After phase 13 (the run is closed, result partial); the user's go-ahead
2026-10-11: "yes launch it, try on one class first". If this route works, later steps do the other classes.

## UPDATES (read first; they override the rest)
- D38 (product `.labview\decisions.md`) left class descriptions, `.ctl` class membership and the `Methods`/`TypeDefs`/
  `Helpers`/`AF Overrides` virtual folders to the user, because no labview-mcp tool or kit script does them. Nobody
  has measured whether LabVIEW's VI Server project/library API (driven by a derived helper VI through the kit, the
  same way as `pa_replace_description`, `pa_clean_member`, `pa_press_control_signal` and run-01's `zm_*`/`zmp*`
  helpers) can. That is this step.
- **Finding (manager, 2026-10-11, from the files):** none of the 11 typedefs is a project item anywhere. The five PC
  typedefs exist only on disk (`ZM-PC-PACKAGE_TYPE.ctl`, `ZM-PC-DESTINATION.ctl`, `ZM-PC-HEADER.ctl` in
  `...\ZM-PC-package\`; `ZM-PC-TP-DATA.ctl`, `ZM-PC-EP-DATA.ctl` in their class folders); no `.lvclass`, `.lvlib`
  or `.lvproj` lists them. So they must be ADDED to the class, not moved.
- **LabVIEW state:** the user says LabVIEW is open (last known PID 26716, port 56779), and the user may have
  `Zuehlke MCP.lvproj` open in the Project Explorer. First run `lv_windows.ps1`. If anything other than `LVMCP
  Validate*` scratch VIs is unsaved, or a dialog is up: STOP and report (do not save, do not discard). Standing kill
  go-ahead for this session: "feel free to kill labview at will for this session" (report each kill).
- Traps: **broken wire first** (`pa_clean_member`) before any rebuild; F10 (`lvproj_drop.py` empties an LF `.lvproj`:
  use `proof\ZMP-09a\lvproj_drop_eol.py` or none); `.lvproj` BOM/EOL changes on close: restore from git if the
  content is otherwise unchanged; one call per message.

## Goal (only `ZM-PC-package.lvclass`)
1. **Class description** (`NI.Lib.Description`), exactly: "Parent of every package. Carries a timestamp and a type
   (both written by init) and a destination (set by the creator). getDataAsJson produces the JSON; nothing outside
   the package looks inside its data."
2. **`TypeDefs` virtual folder** in the class holding `ZM-PC-PACKAGE_TYPE.ctl`, `ZM-PC-DESTINATION.ctl`,
   `ZM-PC-HEADER.ctl` as class members (files stay where they are, flat in the class folder). Scope: public (other
   classes and VIs use them); report the scope LabVIEW gives.
3. **`Methods` virtual folder** holding `ZM-PC-init.vi`, `ZM-PC-getDataAsJson.vi`, `ZM-PC-getTypeName.vi`,
   `ZM-PC-getDestinationName.vi`, `ZM-PC-getTimestampString.vi`, `ZM-PC-getHeader.vi` (`Accessors` stays as is).

Route: find the API with `lvai_vi_server_reference` (e.g. LabVIEW class/library properties and methods for the
description, adding items, virtual folders and moving items; project item methods), write one derived helper per
operation as AIXML in `...\proof\ZMP-12f\`, generate and run it. A dialog-driven or hand-edit route is not allowed.
If one of the three cannot be done by the API, say exactly which and why (the call, the error), and do the others.
Adding a typedef to a class changes its qualified name; LabVIEW relinks the callers. Save what LabVIEW marks
modified because of THIS change, list each file, check each one's state cold, and restore anything else from git
(project closed).

## Checks (from the files, after the project is closed)
The `.lvclass` XML shows the description, the two folders with the right members, and the three `.ctl` items;
`check_membership.py` clean; cold `exec_state` 1 for the class's members and every re-saved caller; T1 (`ZM-TST-
packages.vi`) PASS; `lv_save_version.py` 26 on every changed file; `git status` lists only expected files.
Commit: `refactor(pc): class description, TypeDefs and Methods folders by scripting` (explicit paths).

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; class
  `...\src\common\ZM-PC-packages\ZM-PC-package\ZM-PC-package.lvclass`; library `...\ZM-PC-packages.lvlib`; project
  `...\src\Zuehlke MCP.lvproj`; proof `...\proof\ZMP-12f\`; evidence `...\proof\runs\12f-checks.txt`.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`knowledge\labview-mcp.md`, `kit\README.md`,
  `ops\sweep.md`, `ops\run-checks.md`, `kit\pa_replace_description.xml` as a model of a derived helper).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- A modal dialog: `lv_windows.ps1`, stop, never answer it. Kills: the standing go-ahead (reported).
- No hand edits of `.vi`, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj`: LabVIEW makes every change. Write only inside
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\`.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0.
- Take times from `date`/`Get-Date`, not from memory.

## Report (max 40 lines), as your final message
1. `lvai_status` start/end; LabVIEW state found; kills/starts. 2. The API found per item (class/property/method
names), the helper files. 3. Result per item: done / not possible (why). 4. Files changed and why, states, T1,
versions. 5. Commit; `git status`. 6. What a later step needs to do the other 12 classes the same way (one line per
kind of item). 7. Side effects. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
