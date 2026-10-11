## Report 12f: D38 items done by LabVIEW scripting on ZM-PC-package (probe, one class)

All three items worked through LabVIEW's own VI Server. There was no hand edit and no dialog. Every check passed.

1. **LabVIEW state:** `lvai_status` answered at the start and at the end (port 56779, 0 DWarn). `lv_windows.ps1` at 23:31 showed:
   - the project open, with no dialog;
   - only the `LVMCP Validate` scratch VIs unsaved;
   - one LVAutoSave copy of `Zuehlke MCP.lvproj`. Its content matched the file on disk apart from absolute vs relative URLs, so it is the dirty state the project open leaves, not user work.

   No kill, no restart, no start. Your update ("kill regardless") was not needed.
2. **The API.** Names were taken from the strings in LabVIEW's `resource\lvserver.rsc` (the VI Server catalogue does not list Library or ProjectItem), then measured. The helpers are in `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12f\`:
   - **Description:** `LVClass.Open` on the project's application, write and read back `{LV.LVClassLibrary}` property `Description`, then `Save`. Helper: `zmp12f_set_class_description.xml`.
   - **TypeDefs:** `{LV.Library}` `AddItem` (Type `Folder`) on the class, then `{LV.ProjectItem}` `AddItem` (Name, Path, Type `VI`) on the folder item, then `Edit LVLibs.lvlib:Save All This Library.vi` (only modified). Helper: `zmp12f_add_files_to_class_folder.xml`.
   - **Methods:** `{LV.Library}` `AddItem` folder, `Get All Descendents` (VI), `{LV.ProjectItem}` `Name`, then `{LV.ProjectItem}` `Move` (`New Parent` = the folder), then class `Save`. Helper: `zmp12f_move_members_to_class_folder.xml`.
   - **Saving relinked callers:**
     - `zmp12f_save_libraries.xml`: `Library.Open` plus Save All, only modified.
     - `zmp12f_project_vis_modified.xml`: lists everything in memory in the project's instance with its FP/BD/VI modification bitsets, and can save the modified ones.
3. **Result per item:**
   - Description: done, exact text, in `NI.Lib.Description`.
   - TypeDefs folder: done. The 3 `.ctl` are class members, the files stayed where they were, and LabVIEW gave them public scope (`MethodScope 1`, no `LibItem.Scope`).
   - Methods folder: done for all 6 VIs, each Move error 0. The scopes stayed (`getHeader` is still protected, 3). `Accessors` is unchanged.
4. **Files changed:**
   - **Description step:** only `ZM-PC-package.lvclass`.
   - **Typedef add, files LabVIEW marked modified (12):**
     - the class and the 3 `.ctl`;
     - `Read destination`, `Read type`, `Write destination`, `Write type`, `ZM-PC-getHeader` (relinked);
     - the ROOT private data, so `ZM-ROOT-root.lvclass` and `Write lastPackageType.vi`;
     - `ZM-receiver.vi`. I loaded it through the project before the add so it would relink in memory rather than on a later cold load.
   - **Methods move:** only the `.lvclass`. Nothing was left modified in memory afterwards.
   - **Project close:** the only `.lvproj` change was the dropped BOM, so I restored it from git with the project closed. The close swept the 5 helper items it had adopted out of the `.lvproj`.
   - **Checks:** cold sweep of `src` 137/137 state 1, negative control 0 7. `check_membership` 134 checked, 0 missing; the 3 plain VIs are the launchers and the receiver, as expected. T1 `ZM-TST-packages` PASS, error 0, all 10 sub-checks true. `lv_save_version.py` reads 26 on all 12 changed files.
   - Evidence: `zuehlke-mcp-af-test-results\proof\runs\12f-checks.txt`, plus the in-memory lists `proof\ZMP-12f\mem-*.txt`.
5. **Commits** (no trailer, not pushed):
   - `791ccab refactor(pc): class description of ZM-PC-package by scripting`
   - `b342c98 refactor(pc): TypeDefs folder in ZM-PC-package by scripting, callers relinked`
   - `feadd22 refactor(pc): class description, TypeDefs and Methods folders by scripting`

   I split it into three because the skill says to commit before each structural step; the last message is the brief's. `git status` shows only your own files (`cost.md`, `lessons-mcp-skill.md`, `notes-for-run-02.md`). `proof/` is gitignored, so the helpers and evidence are not committed.
6. **For the other 12 classes, the same way:**
   - **Description:** run the description helper once per class (class path, text). Only the `.lvclass` changes.
   - **Typedefs:** first open every caller that sits outside a class through the project, so it relinks in memory. Then run the add helper, then `zmp12f_save_libraries` on each library whose members use the typedef, then `zmp12f_project_vis_modified` with `save modified?=true` for top-level VIs.
   - **Folders for existing members:** run the move helper with the folder name and the item names. It creates the folder, so run it once per folder.
   - **`.ctl` gap:** `Open VI Reference` by name answers 1035 for a `.ctl`, so modified `.ctl`s can only be saved through a library Save All.
   - **Order:** project open and active for every helper; close it afterwards, restore the `.lvproj` BOM, then sweep.
7. **Side effects:**
   - 6 helper VIs are in `%TEMP%\LabVIEWMCP\helpers` (`zmp12f_*.vi`).
   - The project is closed and LabVIEW stays open; `ZM-receiver.vi` was opened and closed again.
   - In-memory: the receiver's VI mods 520 and the ROOT private data bitset, both saved.
   - Validating AIXML with `{LV.ProjectItem}` nodes (`AddItem`, `Move`) did not crash LabVIEW this time, although labview-mcp's docs record such validates crashing it on 2026-08-26.

DONE
