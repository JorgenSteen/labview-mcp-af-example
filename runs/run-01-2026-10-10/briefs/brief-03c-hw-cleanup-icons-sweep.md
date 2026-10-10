# Brief 03c: finish phase 03: Clean Up Diagram, icons, cold sweep and closing checks for `ZM-HW`, `ZM-HW-SIM` and T3
Type: build (LabVIEW calls). Phase 03 step c of 3 (last step of the phase).

## UPDATES (read first)
- Reports to read: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-03a-hw-parent.md`,
  `report-03b-hw-sim-test.md` (what exists, the sweep baseline), `report-02b-cu-cleanup-icons-sweep.md` and
  `report-01e-pc-icons-apply-sweep.md` (the measured cleanup and icon routes on this station; your report blocks
  follow theirs).
  <<MANAGER: the file list and traps from reports 03a/03b go here before launch>>
- Save version **26.0**; LabVIEW 2026 Q3 32-bit, so a save with no project open writes the same version.
- User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself when it crashes or
  stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported. Never answer a dialog.
- D39: icons are applied as `make_icons.py` draws them, with NO preview prompt. D38: class descriptions, `.ctl`
  membership and `Methods` placement are the user's (list them, do not do them).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; icon helpers need the project CLOSED; `icon_apply_icon_and_save_n.xml` takes
  `vi paths` with no trailing `;`; the read-back folder must be short and exist; `lvai_set_vi_icon` before any
  template; the validator's hidden `LVMCP Validate.vi` may show as unsaved in `lv_windows.ps1` (tool design, ignore).

## Goal
(1) Clean Up Diagram on every VI phase 03 generated (the members of the two HW classes and `ZM-TST-hardware.vi`),
proven. (2) Regenerate the icon PNGs (spec unchanged), set the class templates on `ZM-HW-hardware.lvclass` and
`ZM-HW-SIM-simulated_hardware.lvclass`, the library icons on `ZM-HW-hardware.lvlib` and
`ZM-HW-SIM-simulated_hardware.lvlib`, the own layers on the members, apply the templates, the composite on
`ZM-TST-hardware.vi`; read back, 0 px. (3) The phase-03 closing checks. Nothing else changes.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`
  (CLOSED throughout). Classes: `...\src\hardware\ZM-HW-hardware\ZM-HW-hardware\ZM-HW-hardware.lvclass` and
  `...\src\hardware\ZM-HW-SIM-simulated_hardware\ZM-HW-SIM-simulated_hardware\ZM-HW-SIM-simulated_hardware.lvclass`;
  libraries beside each class folder; test `...\src\tests\ZM-TST-hardware.vi`.
- Icons `...\proof\icons\`; spec `...\.labview\conventions\icon-spec.json`; read-back folder
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\03c\` (create it); scratch `...\proof\ZMP-03c\`; helpers
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\cleanup.md`, `ops\icons.md` (steps 2-8;
  step 2's approval is D39), `ops\sweep.md`, `kit\README.md`, `knowledge\labview-mcp.md` ("Operating rules",
  "lvai_set_vi_icon and icon work"). Conventions `...\.labview\conventions\hygiene.md`, `icons.md`.
- Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §1 (dependency rule), §7.4, §7.5.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point = HEAD; versions scanned (all 26).
2. Cleanup per `ops\cleanup.md` on the phase's VIs (BEFORE sweep, batches of up to 5 then the rest, versions,
   git shows only those `.vi`, AFTER sweep = BEFORE, panel checks none needed unless a source declares one).
   Commit per batch `style(hw): clean up diagrams ...`.
3. `make_icons.py --check` then generate (`--spec`, `--src`, `--out` explicit); PNG counts; the new manifest
   entries for the phase's VIs, `_classes\ZM-HW-hardware.png`, `_classes\ZM-HW-SIM-simulated_hardware.png`,
   `_libs\ZM-HW-hardware.png`, `_libs\ZM-HW-SIM-simulated_hardware.png`.
4. `ops\icons.md` steps 3-8 for the phase's owners: BEFORE read-back; own layers (`lvai_set_vi_icon`) on every
   member and the composite on `ZM-TST-hardware.vi`; `icon_set_class_icon.xml` on both classes;
   `icon_set_library_icon.xml` on both libraries; `icon_apply_icon_and_save_n.xml` per class (`is library` false);
   read-back of every VI and of the 4 owner icons, 0 px; versions; sweep of `src\hardware\` and `src\tests\` equal
   to the baseline. Commit per owner `style(hw): icons ...`. Do not touch `ZM-PC`, `ZM-CU`, the other test VIs or
   `ZM-TST-tests.lvlib`'s icon.
5. Phase-03 closing checks (`orchestration/plan.md`, "Every build phase ends with"): a description on every VI
   of the phase (quote one per class from the AIXML sources in `proof\ZMP-03a\`, `proof\ZMP-03b\`, or an export);
   dependency rule from `lv_loadability.py --links` on the phase's VIs: the parent's VIs link only into
   `src\hardware\ZM-HW-hardware\` and `src\common\ZM-PC-packages\`; the SIM's into `src\hardware\` and
   `src\common\ZM-PC-packages\`; none into `vi.lib\ActorFramework`, `ZM-CU`, `ZM-CP`, `ZM-TST`; the `.lvproj`
   `hardware` folder lists both libraries once each; T3 evidence exists (`proof\runs\03b-checks.txt`, Pass true);
   every file of the phase at version 26; `#customerror 5000` present in the parent's `ZM-HW-do.vi` as 03a reported
   (a label in the export, or the description fallback) and `docs\error-codes.md` still names `ZM-HW-do.vi`;
   `git status --short` clean.
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
1. `lvai_status` start/end; starts made. 2. The `ops\cleanup.md` block. 3. The `ops\icons.md` block (PNG counts,
own layers, templates, apply codes, read-back px, versions, sweep, commits). 4. The closing checks, one line each
with evidence. 5. Commits; `git status`. 6. Deviations / NEEDS CLARIFICATION; items for the user in the IDE
(carried from 03a/03b). 7. Side effects.
