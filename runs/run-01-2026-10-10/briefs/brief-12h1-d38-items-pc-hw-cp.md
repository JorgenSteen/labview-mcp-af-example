# Brief 12h1: D38 items by the 12f helpers - PC children, HW, CP layer (9 classes)
Type: build (LabVIEW calls), structure only. After phase 13 (the run is closed, result partial). Post-run step 12h,
part 1 of 2 (12h2 does CM, HWM, ROOT and the CI interface and message class). Session 4 start message (2026-10-11):
"Continue run-01's post-run steps (12h, 12g, 12i). You may restart and kill LabVIEW at will for this session;
agents may too."

## UPDATES (read first; they override the rest)
- 12f (791ccab, b342c98, feadd22; `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-12f-ide-items-probe.md`)
  proved all three D38 items by VI Server on `ZM-PC-package`: description, `.ctl` added into a class `TypeDefs`
  folder, members moved into a `Methods` folder. **Read report-12f in full first; its item 6 is your route.** The
  helpers (git-ignored AIXML) are in `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12f\`:
  `zmp12f_set_class_description.xml`, `zmp12f_add_files_to_class_folder.xml`, `zmp12f_move_members_to_class_folder.xml`,
  `zmp12f_save_libraries.xml`, `zmp12f_project_vis_modified.xml`; generated VIs in `%TEMP%\LabVIEWMCP\helpers\zmp12f_*.vi`.
  Reuse them; copy any you must change into `...\proof\ZMP-12h1\` under a new name.
- LabVIEW at 23:54 (manager, `lv_windows.ps1`): PID 26716 running, project closed, no dialog, LVAutoSave 0, unsaved 2
  (only `LVMCP Validate*` scratch VIs). **Standing go-ahead for this session (the user, 2026-10-11): you may start,
  restart, close and kill LabVIEW at will;** report each one. A close raises the save dialog for the scratch VIs:
  kill instead.
- `ZM-PC-package` is DONE; do not touch it again.
- Traps (status.md "Traps carried forward"): **a broken wire: `pa_clean_member` (Remove Bad Wires) first**, before any
  rebuild; F10: `lvproj_drop.py` empties an LF `.lvproj` (use `proof\ZMP-09a\lvproj_drop_eol.py`, or none); a project
  close may drop the `.lvproj` BOM or change EOLs: restore from git with the project closed if the content is otherwise
  unchanged; a project close may adopt helper items into the `.lvproj`: they must not stay (12f saw 5, swept by the close);
  `Open VI Reference` answers 1035 for a `.ctl`: a modified `.ctl` saves only through its library's Save All; adding a
  typedef to a class renames it (qualified name), so open every caller OUTSIDE that class's library through the project
  BEFORE the add so it relinks in memory, and save what LabVIEW marks modified because of the add; one call per message.

## Goal (9 classes; files stay where they are on disk; nothing else changes)
Folder rule (`02` §2, `layout.class-folders`): `Accessors` (exists, leave it), `AF Overrides`, `Helpers`, `Methods`
(methods, hooks, and overrides of a parent's method), `TypeDefs` (the class's typedefs as class members); only folders
that hold something. **After the step no member of these classes sits at the class root.** If a member fits none of
the folders, do not guess: list it in the report.

| class (`.lvclass` under `...\zuehlke-mcp-af-test-results\src\`) | description (`NI.Lib.Description`, exactly) | TypeDefs | Methods |
|---|---|---|---|
| `common\ZM-PC-packages\ZM-PC-TP-test_package` | "A measurement package: the five-field data cluster ZM-PC-TP-DATA (temperature_c, sample_index, duty_percent, sensor_ok, status). init calls the parent, then sets type TestPackage." | `ZM-PC-TP-DATA.ctl` (add) | `ZM-PC-init`, `ZM-PC-getDataAsJson`, `ZM-PC-TP-setType`, `ZM-PC-TP-create` |
| `common\ZM-PC-packages\ZM-PC-EP-error_package` | "An error travelling upward as a package: data = sender, code, source. Created by ZM-PC-EP-create with destination Root. init calls the parent, then sets type ErrorPackage." | `ZM-PC-EP-DATA.ctl` (add) | `ZM-PC-init`, `ZM-PC-getDataAsJson`, `ZM-PC-EP-setType`, `ZM-PC-EP-create` |
| `hardware\...\ZM-HW-hardware` | "Parent of every hardware object. init and close do real work on the initialized flag (close is where real hardware is put into a safe state); do is a placeholder that returns error 5000 and must be overridden by a child." | - | `ZM-HW-init`, `ZM-HW-do`, `ZM-HW-close` |
| `hardware\...\ZM-HW-SIM-simulated_hardware` | "Pluggable simulated hardware: do returns a random TestPackage addressed to Communication; init/close inherited." | - | `ZM-HW-do`, `ZM-HW-SIM-randomData` |
| `protocol\...\ZM-CP-communication_protocol` | "Parent of every communication protocol. init and close do real work on the opened flag; publish is a placeholder that returns error 5000 and must be overridden by a child. Never looks inside a package: it asks getDataAsJson and getTypeName." | - | `ZM-CP-init`, `ZM-CP-publish`, `ZM-CP-close` |
| `protocol\...\ZM-CP-FL-file_logger` | "Pluggable file logger: one JSON Lines file per package type under outputFolder; init creates the folder after the parent; publish appends getDataAsJson to <getTypeName>.jsonl; close inherited." | - | `ZM-CP-init`, `ZM-CP-publish`, `ZM-CP-FL-createFolder`, `ZM-CP-FL-buildPath`, `ZM-CP-FL-appendLine` |
| `protocol\...\ZM-CP-UDP-sender` | "UDP sender: one JSON line per datagram, unicast to remoteAddress:remotePort (defaults 127.0.0.1:61557, D34). Sending to nobody is silent (codes 66 and 56 cleared, D25)." | - | every non-accessor member (overrides, `publish`, hooks) |
| `protocol\...\ZM-CP-UDP-receiver` | "UDP receiver: the reading side of the transport; receive returns one JSON line or timed_out. Does not override publish (5000 through the parent is correct, D25)." | - | every non-accessor member (overrides, `ZM-CP-UDP-receive`, hooks); `Write localPort` is an accessor: `Accessors` if it is not already there |
| `protocol\...\ZM-CP-MX-multi_protocol` | "Composite protocol: holds an array of ZM-CP-communication_protocol objects; init, publish and close go to every element in order, stopping at the first error, which is returned. The root gives the CM an MX holding [file logger, UDP sender] (D26)." | `ZM-CP-MX-PROTOCOLS.ctl` (add) | `ZM-CP-MX-initAll`, `ZM-CP-MX-closeAll`, the three overrides |

The `...` are the library folders; find each `.lvclass` with Glob. Take the member names from the `.lvclass` XML, not
from this table, and report any difference.

Also, read only: the reentrancy setting of `ZM-CP-MX-initAll.vi` and `ZM-CP-MX-closeAll.vi` (expected "shared clone
reentrant"; report-05b item 8b says the flags read differently after a re-save). Read it through VI Server (VI property
for reentrancy / clone type, spelling from `resource\lvserver.rsc` or `lvai_vi_server_reference`); change nothing;
report the reading.

## Order
One class at a time: description, typedef add (with the callers opened first and saved after), moves. **Commit after
each class** (explicit paths): `refactor(<pc|hw|cp>): class description and folders of <class> by scripting`. Close the
project, restore the `.lvproj` BOM/EOL if that is the only change, sweep at the end.

## Checks (from the files, project closed)
Each `.lvclass` XML: the description, the folders with the right members, the `.ctl` items; no member at the class root;
`check_membership.py` clean; cold sweep of `src` (`ops\sweep.md`): every VI state 1, negative control 0 7; T1
`ZM-TST-packages.vi`, T3 `ZM-TST-hardware.vi`, T4 `ZM-TST-protocol.vi`, T5 `ZM-TST-udp.vi`, T6 `ZM-TST-pipeline.vi` PASS (`ops\run-checks.md`);
`lv_save_version.py` 26 on every changed file; `git status` lists only expected files. Evidence:
`...\proof\runs\12h1-checks.txt`.

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`;
  proof `...\proof\ZMP-12h1\`; spec `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §2, §7.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`knowledge\labview-mcp.md`, `kit\README.md`,
  `ops\sweep.md`, `ops\run-checks.md`).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: **one lvai_*/pylv_* call per message, never two, offline ones included.**
- A modal dialog: `lv_windows.ps1`, stop, never answer it. Kills and restarts: the standing go-ahead above (reported).
- No hand edits of `.vi`, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj`: LabVIEW makes every change. Write only inside
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\`.
- Do not rename or invent anything; no change to any diagram, pane, scope or description of a VI.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0.
- Take times from `date`/`Get-Date`, not from memory.

## Report (max 45 lines), as your final message
1. `lvai_status` start/end; kills/starts/restarts. 2. Per class: description / TypeDefs / folders done or not (why),
members not placed. 3. Typedef adds: callers opened, files LabVIEW modified and saved. 4. MX reentrancy reading.
5. Sweep, membership, T1 T3 T4 T5 T6, versions. 6. Commits; `git status`. 7. Side effects, new traps. Ends with DONE,
or NEEDS CLARIFICATION / CANNOT PROCEED.
