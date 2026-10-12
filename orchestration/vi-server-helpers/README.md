# VI Server helpers: class description, `.ctl` into a class, virtual folders

No labview-mcp tool sets a class description, adds a `.ctl` to a class or moves a member into a class's virtual
folder. LabVIEW's VI Server does all three; the names are not in the VI Server catalogue the tools expose (they were
found in LabVIEW's `resource\lvserver.rsc` and measured in run-01, steps 12f and 12h). These are the derived helper
VIs the run-01 agents wrote, as AIXML. Generic: no product names, no fixed paths; every input is a control.
`CLAUDE.md`, "The build phases set class descriptions, `.ctl` class membership and the virtual folders" says when
they are used (D38).

**How to run one:** convert the AIXML to a VI in `%TEMP%\LabVIEWMCP\helpers\` (`lvai_convert_aixml_to_vi`), then
`lvai_run_vi_and_read_values` with its controls; read every error indicator. **The project must be open and active**
for every helper (each one works on `Project:Active Project` -> `Application`). Afterwards close the project and, if
the close changed only the `.lvproj` BOM or line endings, restore the `.lvproj` from git with the project closed.

| helper | does | inputs |
|---|---|---|
| `zmp12f_set_class_description.xml` | `LVClass.Open` -> write `{LV.LVClassLibrary}` `Description` -> read back -> `Save` | class path, description |
| `zmp12f_add_files_to_class_folder.xml` | `{LV.Library}` `AddItem` (Folder) -> `{LV.ProjectItem}` `AddItem` per file on the folder item -> class Save | class path, folder, item paths (`;`-separated), item type |
| `zmp12f_move_members_to_class_folder.xml` | creates the folder, then `{LV.ProjectItem}` `Move` of the named members into it -> class Save | class path, folder, item names (`;`-separated) |
| `zmp12h2_move_members_to_existing_folder.xml` | the same into a folder that already exists | class path, folder, item names |
| `zmp12f_save_libraries.xml` | `Library.Open` -> `Save All This Library.vi`, only modified | library paths (`;`-separated) |
| `zmp12f_project_vis_modified.xml` | lists every VI/ctl in memory with its modification bitsets; can save the modified ones | save modified? |

**Rules learned in run-01:**
- **Descriptions are stored ANSI (CP1252):** "→" became "?" with no error. Write ASCII only ("->"), read back.
- **Folder moves are structure only:** a virtual folder exists only in the `.lvclass`/`.lvlib` XML; no file moves, no
  renames, no relinks. They need no question (the user, 2026-10-12). Do them as each member is made.
- **Adding a `.ctl` to a class is not structure only:** it renames the typedef (`Class.lvclass:X.ctl`), and every
  caller relinks and must be saved. Best done right after the typedef is created, before anything uses it. Done later:
  open every caller outside the class through the project first (so it relinks in memory), run the add helper, then
  `zmp12f_save_libraries` on each library whose members use the typedef, then `zmp12f_project_vis_modified` with
  `save modified?` = T for top-level VIs. A `.ctl` saves only through a library Save All (`Open VI Reference` answers
  1035 for it). LabVIEW makes an added typedef public.
- The answer of `zmp12f_project_vis_modified` can exceed the tool-result limit on a large project; ask for only what
  you need.
- In run-01 the Claude Code permission classifier refused the typedef-add run once ("Modify Shared Resources") and
  allowed the moves; the user then allowed it.
