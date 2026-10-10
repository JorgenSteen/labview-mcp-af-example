# Brief 04c: finish phase 04: Clean Up Diagram, icons, cold sweep and closing checks for `ZM-CP`, `ZM-CP-FL` and T4
Type: build (LabVIEW calls). Phase 04 step c of 3 (last step of the phase).

## UPDATES (read first)
- Reports to read: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-04a-cp-parent.md`,
  `report-04b-cp-fl-test.md` (what exists, the sweep baseline), `report-03c-hw-cleanup-icons-sweep.md` (the measured
  cleanup and icon routes on this station for a parent + child pair; your report blocks follow its).
- The phase's VIs (12): `src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\` `Write opened.vi`,
  `ZM-CP-init.vi`, `ZM-CP-publish.vi`, `ZM-CP-close.vi`; `src\protocol\ZM-CP-FL-file_logger\ZM-CP-FL-file_logger\`
  `Read outputFolder.vi`, `Write outputFolder.vi`, `ZM-CP-FL-createFolder.vi`, `ZM-CP-FL-buildPath.vi`,
  `ZM-CP-FL-appendLine.vi`, `ZM-CP-init.vi`, `ZM-CP-publish.vi`; `src\tests\ZM-TST-protocol.vi` (diagram 4144x837, a
  38-stage chain: clean it, report its size before and after). Sweep baseline 15/15
  (`proof\ZMP-04b\ZMP-04b-sweep-final.txt`). AIXML sources with descriptions: `proof\ZMP-04a\`, `proof\ZMP-04b\`. The
  parent's `ZM-CP-publish.vi` carries the `FreeLabel` `#customerror 5000` (export `proof\ZMP-04a\export-ZM-CP-publish.xml`):
  export again after the cleanup and confirm. Items for the user in the IDE from 04a/04b: both class descriptions
  (texts in report-04a item 7 and report-04b item 8), the `Methods` folders (init/publish/close in the parent; init,
  publish, createFolder, buildPath, appendLine in the FL).
- Save version **26.0**; LabVIEW 2026 Q3 32-bit, so a save with no project open writes the same version.
- User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself when it crashes or
  stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported. Never answer a dialog.
- D39: icons are applied as `make_icons.py` draws them, with NO preview prompt. D38: class descriptions, `.ctl`
  membership and `Methods` placement are the user's (list them, do not do them).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib "C:\Program Files (x86)\National
  Instruments\LabVIEW 2026\vi.lib"`; icon helpers need the project CLOSED; `icon_apply_icon_and_save_n.xml` takes
  `vi paths` with no trailing `;`; the read-back folder must be short and exist; `lvai_set_vi_icon` before any
  template; the validator's hidden `LVMCP Validate.vi` may show as unsaved in `lv_windows.ps1` (tool design, ignore).

## Goal
(1) Clean Up Diagram on every VI phase 04 generated (the members of the two CP classes and `ZM-TST-protocol.vi`),
proven. (2) Regenerate the icon PNGs (spec unchanged), set the class templates on
`ZM-CP-communication_protocol.lvclass` and `ZM-CP-FL-file_logger.lvclass`, the library icons on
`ZM-CP-communication_protocol.lvlib` and `ZM-CP-FL-file_logger.lvlib`, the own layers on the members, apply the
templates, the composite on `ZM-TST-protocol.vi`; read back, 0 px. (3) The phase-04 closing checks. Nothing else.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`
  (CLOSED throughout). Classes: `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol.lvclass`
  and `...\src\protocol\ZM-CP-FL-file_logger\ZM-CP-FL-file_logger\ZM-CP-FL-file_logger.lvclass`; libraries beside each
  class folder; test `...\src\tests\ZM-TST-protocol.vi`.
- Icons `...\proof\icons\`; spec `...\.labview\conventions\icon-spec.json`; read-back folder
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\04c\` (create it); scratch `...\proof\ZMP-04c\`; helpers
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\cleanup.md`, `ops\icons.md` (steps 2-8;
  step 2's approval is D39), `ops\sweep.md`, `kit\README.md`, `knowledge\labview-mcp.md`. Conventions
  `...\.labview\conventions\hygiene.md`, `icons.md`. Spec: `02-specification.md` §1, §7.6, §7.7.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point = HEAD; versions scanned (all 26).
2. Cleanup per `ops\cleanup.md` on the phase's VIs (BEFORE sweep, batches of up to 5 then the rest, versions, git
   shows only those `.vi`, AFTER sweep = BEFORE, panel checks none needed unless a source declares one). Commit
   per batch `style(cp): clean up diagrams ...`.
3. `make_icons.py --check` then generate (`--spec`, `--src`, `--out` explicit); PNG counts; the manifest entries
   for the phase's VIs, the two `_classes` and the two `_libs` PNGs.
4. `ops\icons.md` steps 3-8 for the phase's owners: BEFORE read-back; own layers on every member and the composite
   on `ZM-TST-protocol.vi`; `icon_set_class_icon.xml` on both classes; `icon_set_library_icon.xml` on both
   libraries; `icon_apply_icon_and_save_n.xml` per class; read-back of every VI and of the 4 owner icons, 0 px;
   versions; sweep of `src\protocol\` and `src\tests\` equal to the baseline. Commit per owner `style(cp): icons
   ...`. Do not touch `ZM-PC`, `ZM-CU`, `ZM-HW`, the other test VIs or `ZM-TST-tests.lvlib`'s icon.
5. Phase-04 closing checks: a description on every VI of the phase (quote one per class from the AIXML sources in
   `proof\ZMP-04a\`, `proof\ZMP-04b\`); dependency rule from `lv_loadability.py --links` on the phase's VIs: the
   parent's VIs link only into `src\protocol\ZM-CP-communication_protocol\` and `src\common\ZM-PC-packages\`; the
   FL's into `src\protocol\` and `src\common\ZM-PC-packages\`; none into `vi.lib\ActorFramework`, `ZM-CU`, `ZM-HW`,
   `ZM-TST`; the `.lvproj` `protocol` folder lists both libraries once each; T4 evidence exists
   (`proof\runs\04b-checks.txt`, Pass true, six checks, `mx_placeholder_ok` deferred to phase 05); every file of the
   phase at version 26; `#customerror 5000` present in the parent's `ZM-CP-publish.vi` export and
   `docs\error-codes.md` names `ZM-CP-publish.vi`; `git status --short` clean.
6. Final `lvai_status`; project closed; no unsaved window of ours.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops. Error 1562 on a class or library icon that a project open/close does not cure:
  report, no fallback.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj. Only the phase's VIs, the 2 `.lvclass` and the 2 `.lvlib` may
  change on disk; a `.lvproj` or `.ctl` change = stop and report. Absolute long-form paths. Nothing outside the
  product folder except helpers and the read-back folder.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop.

## Report (max 45 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The `ops\cleanup.md` block. 3. The `ops\icons.md` block. 4. The closing
checks, one line each with evidence. 5. Commits; `git status`. 6. Deviations / NEEDS CLARIFICATION; items for the
user in the IDE (carried from 04a/04b). 7. Side effects.
