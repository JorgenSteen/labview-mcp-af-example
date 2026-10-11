# Brief 12h2: D38 items by the 12f helpers - CM, HWM, ROOT, the CI interface and message class (5 classes)
Type: build (LabVIEW calls), structure only. After phase 13 (the run is closed, result partial). Post-run step 12h,
part 2 of 2 (12h1 did the PC children, HW, SIM, CP, FL, UDP sender/receiver, MX). Session 4 start message
(2026-10-11): "Continue run-01's post-run steps (12h, 12g, 12i). You may restart and kill LabVIEW at will for this
session; agents may too."

## UPDATES (read first; they override the rest)
- 12h1 DONE (e6b8c9b..49fa58a, 9 commits, 21 files at 26; sweep 137/137, membership clean, T1 T3-T6 PASS). Route
  unchanged from 12f. LabVIEW at its end (00:06): PID 26716, port 56779, project closed, no dialog, LVAutoSave 0, only
  the 2 `LVMCP Validate*` scratch VIs unsaved. New traps from 12h1: the in-memory list helper's answer (~85 KB) is over
  the tool-result limit: parse the saved answer with `proof\ZMP-12h1\mem_lines.py`; LabVIEW decides which callers a
  typedef add modifies (save only those; the cold sweep is the proof); the close dropped the `.lvproj` BOM again
  (restored from git) and swept one adopted helper item.
- "No member at the class root" means: only the class's private data `.ctl` and `Parent Libraries` stay at the root
  (as in the 10 classes done); every other member is in a folder.
- 12f (791ccab, b342c98, feadd22; `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-12f-ide-items-probe.md`)
  proved all three D38 items by VI Server on `ZM-PC-package`; 12h1 did nine more classes (report
  `...\reports\report-12h1-d38-items-pc-hw-cp.md`). **Read both reports in full first; they are your route.** Helpers
  (git-ignored AIXML) in `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12f\` (and any
  12h1 copies in `...\proof\ZMP-12h1\`); generated VIs in `%TEMP%\LabVIEWMCP\helpers\`. Reuse them; copy any you must
  change into `...\proof\ZMP-12h2\` under a new name.
- **Standing go-ahead for this session (the user, 2026-10-11): you may start, restart, close and kill LabVIEW at
  will;** report each one. A close raises the save dialog for the `LVMCP Validate*` scratch VIs: kill instead.
- Done, do not touch again: `ZM-PC-package` (12f) and the nine classes of 12h1.
- Traps (status.md "Traps carried forward"): **a broken wire: `pa_clean_member` (Remove Bad Wires) first**, before any
  rebuild; F10: `lvproj_drop.py` empties an LF `.lvproj` (use `proof\ZMP-09a\lvproj_drop_eol.py`, or none); a project
  close may drop the `.lvproj` BOM or change EOLs: restore from git with the project closed if the content is otherwise
  unchanged; a close may adopt helper items into the `.lvproj`: they must not stay; `Open VI Reference` answers 1035
  for a `.ctl`: a modified `.ctl` saves only through its library's Save All; adding a typedef to a class renames it, so
  open every caller OUTSIDE that class's library through the project BEFORE the add (e.g. the launchers
  `ZM-launcher.vi`, `ZM-launcher_test.vi`, the tests, `ZM-receiver.vi`, and the ROOT's `launchCm`/`launchHwm`, which
  call the CM's and HWM's `PRELAUNCH_SETTINGS`), and save what LabVIEW marks modified because of the add; one call per
  message.

## Goal (5 classes; files stay where they are on disk; nothing else changes)
Folder rule (`02` §2, `layout.class-folders`): `Accessors` (exists, leave it), `AF Overrides` (Pre Launch Init, Actor
Core, Stop Core, Handle Error), `Helpers` (helper-loop VIs), `Methods` (methods, hooks, and overrides of a parent's or
interface's method; `init` is a method), `Accessors` also holds the custom accessor `writePrelaunchSettings` (`02` §6: "a public custom accessor"; manager correction 2026-10-12, sent to the agent at launch +2 min), `TypeDefs` (the class's typedefs as class
members); only folders that hold something. **After the step no member of these classes sits at the class root.** If
a member fits none of the folders, do not guess: list it in the report.

| class (under `...\zuehlke-mcp-af-test-results\src\`) | description (`NI.Lib.Description`, exactly) | TypeDefs | AF Overrides | Helpers | Methods |
|---|---|---|---|---|---|
| `actors\ZM-CM-communication_manager\ZM-CM-communication_manager\ZM-CM-communication_manager.lvclass` | "Communication manager actor: owns a communication protocol object from its pre-launch settings, initialises it in Pre Launch Init (createResources), hands every package it receives to it (publish), and closes it in Stop Core. Error plan (D40, for now): evaluateError is a pass-through; an error stops the actor, and its Last Ack stops the root and through it the whole tree." | `ZM-CM-PRELAUNCH_SETTINGS.ctl` | Pre Launch Init, Stop Core, Handle Error | - | `ZM-CI-handlePackage`, createResources, releaseProtocol, evaluateError (writePrelaunchSettings: `Accessors`) |
| `actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager.lvclass` | "Hardware manager actor: owns a hardware object from its pre-launch settings; init registers for its stop event before Call Parent (D41); its helper loop ZM-HWM-helperAcquisition calls the hardware every intervalMs (init before, do in the loop, close after) and sends each package to this actor, which counts it and forwards it to its caller through ZM-CI-handlePackage. Error plan (D40, for now): evaluateError is a pass-through; the loops stop each other, a loop error ends the loop VI with the raw error and Normal Stop to this actor, and the error in its Last Ack stops the root and the tree." | `ZM-HWM-PRELAUNCH_SETTINGS.ctl`, `ZM-HWM-EVENTS.ctl` | Pre Launch Init, Actor Core, Handle Error | `ZM-HWM-helperAcquisition` | `ZM-CI-handlePackage`, init, createEvents, stop, close, createResources, evaluateError (writePrelaunchSettings: `Accessors`) |
| `actors\ZM-ROOT-root\ZM-ROOT-root\ZM-ROOT-root.lvclass` | "Root actor: launches the communication manager (CM, first) and the hardware manager (HWM) from its Actor Core with their pre-launch settings, routes every package by destination (Communication → forwarded to the CM while it runs; Root → an error package is shown on the panel; Unknown and Hardware → dropped with one log line), and shows its panel loop helperPanel with the Stop button and the errors list. Error plan (D40, for now): evaluateError is a pass-through; an error stops the root and, through AF's Stop Core, the whole tree; a child's error reaches the root through its Last Ack and stops it. init launches the CM and the HWM and registers for the panel loop's events before Call Parent (D41)." | `ZM-ROOT-PRELAUNCH_SETTINGS.ctl`, `ZM-ROOT-EVENTS.ctl` | Actor Core, Pre Launch Init, Handle Error | `ZM-ROOT-helperPanel` | `ZM-CI-handlePackage`, init, close, createEvents, createResources, evaluateError, launchCm, launchHwm, notePackageType, showError, stop (writePrelaunchSettings: `Accessors`) |
| `common\ZM-CI-common_interfaces\ZM-CI-package_handler\ZM-CI-package_handler.lvclass` (interface) | "Interface: one method, ZM-CI-handlePackage; every actor that receives packages implements it." | - | - | - | `ZM-CI-handlePackage` |
| `common\ZM-CI-common_interfaces\ZM-CI-handlePackage Msg\ZM-CI-handlePackage Msg.lvclass` | "Message (made by Message Maker) that carries one package to an actor: Do casts the actor to ZM-CI-package_handler and calls ZM-CI-handlePackage. Send it with Send ZM-CI-handlePackage." | - | - | - | `Do`, `Send ZM-CI-handlePackage` |

Take the member names from each `.lvclass` XML, not from this table, and report any difference (the ROOT list is from
report-10e item 6 plus `init` from 12d; the HWM `init` from 12c). If the interface or the message class refuses a
virtual folder or a description through the 12f route, report the call and the error and go on.

## Order
One class at a time: description, typedef adds (callers opened first, saved after), moves. **Commit after each class**
(explicit paths): `refactor(<cm|hwm|root|ci>): class description and folders of <class> by scripting`. Close the
project, restore the `.lvproj` BOM/EOL if that is the only change, sweep at the end.

## Checks (from the files, project closed)
Each `.lvclass` XML: the description, the folders with the right members, the `.ctl` items; no member at the class
root; `check_membership.py` clean; cold sweep of `src` (`ops\sweep.md`): every VI state 1, negative control 0 7; T1-T7
PASS (`ZM-TST-packages`, `-log`, `-hardware`, `-protocol`, `-udp`, `-pipeline`, `-routing`; `ops\run-checks.md`);
`lv_save_version.py` 26 on every changed file; `git status` lists only expected files. Evidence:
`...\proof\runs\12h2-checks.txt`.

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`;
  proof `...\proof\ZMP-12h2\`; spec `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §2, §7.
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
members not placed. 3. Typedef adds: callers opened, files LabVIEW modified and saved. 4. Sweep, membership, T1-T7,
versions. 5. Commits; `git status`. 6. Side effects, new traps. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
