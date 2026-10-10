# Brief 05d: finish phase 05: Clean Up Diagram, icons, cold sweep and closing checks for `ZM-CP-UDP`, `ZM-CP-MX`, T5 and the regenerated T4
Type: build (LabVIEW calls). Phase 05 step d of 4 (last step of the phase).

## UPDATES (read first)
- Reports to read: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-05a-cp-udp.md`,
  `report-05b-cp-mx.md`, `report-05c-cp-tests.md` (what exists, the sweep baseline), `report-04c-cp-cleanup-icons-sweep.md`
  (the measured cleanup and icon routes for CP owners; your report blocks follow its).
  <<MANAGER: the file list and traps from reports 05a-05c go here before launch>>
- Save version **26.0**; LabVIEW 2026 Q3 32-bit, so a save with no project open writes the same version.
- User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself when it crashes or
  stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported. Never answer a dialog.
- D39: icons are applied as `make_icons.py` draws them, with NO preview prompt. D38: class descriptions, `.ctl`
  membership and `Methods`/`TypeDefs` placement are the user's (list them, do not do them).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib`; icon helpers need the project CLOSED;
  `icon_apply_icon_and_save_n.xml` takes `vi paths` with no trailing `;`; the read-back folder must be short and
  exist; `lvai_set_vi_icon` before any template; the validator's hidden `LVMCP Validate.vi` may show as unsaved.
- The reentrant hooks `ZM-CP-MX-initAll.vi`/`closeAll.vi`: Clean Up Diagram and the icon save must keep their
  reentrancy flags; prove it after the step from a `pylv_extract` of each (`IsReentrant`, `PooledReentrancy`).

## Goal
(1) Clean Up Diagram on every VI phase 05 generated or regenerated (the members of the three classes,
`ZM-TST-udp.vi`, `ZM-TST-protocol.vi`), proven. (2) Regenerate the icon PNGs (spec unchanged), set the class templates
on the three classes, the library icons on `ZM-CP-UDP-udp_transport.lvlib` and `ZM-CP-MX-multi_protocol.lvlib`, the own
layers on the members, apply the templates, the composites on the two test VIs; read back, 0 px. (3) The phase-05
closing checks. Nothing else.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`
  (CLOSED throughout). Classes: `...\src\protocol\ZM-CP-UDP-udp_transport\ZM-CP-UDP-sender\ZM-CP-UDP-sender.lvclass`,
  `...\ZM-CP-UDP-receiver\ZM-CP-UDP-receiver.lvclass`, `...\src\protocol\ZM-CP-MX-multi_protocol\ZM-CP-MX-multi_protocol\ZM-CP-MX-multi_protocol.lvclass`;
  libraries `...\src\protocol\ZM-CP-UDP-udp_transport\ZM-CP-UDP-udp_transport.lvlib`,
  `...\src\protocol\ZM-CP-MX-multi_protocol\ZM-CP-MX-multi_protocol.lvlib`; tests `...\src\tests\ZM-TST-udp.vi`,
  `...\src\tests\ZM-TST-protocol.vi`.
- Icons `...\proof\icons\`; spec `...\.labview\conventions\icon-spec.json`; read-back folder
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\05d\` (create it); scratch `...\proof\ZMP-05d\`; helpers
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\cleanup.md`, `ops\icons.md` (steps 2-8;
  step 2's approval is D39), `ops\sweep.md`, `kit\README.md`, `knowledge\labview-mcp.md`. Conventions
  `...\.labview\conventions\hygiene.md`, `icons.md`. Spec: `02-specification.md` §1, §7.8, §7.9.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point = HEAD; versions scanned (all 26).
2. Cleanup per `ops\cleanup.md` on the phase's VIs (BEFORE sweep, batches of up to 5 then the rest, versions, git
   shows only those `.vi`, AFTER sweep = BEFORE, panel checks none needed unless a source declares one). Commit per
   batch `style(cp): clean up diagrams ...`.
3. `make_icons.py --check` then generate; PNG counts; the manifest entries for the phase's VIs, the three `_classes`
   and the two `_libs` PNGs.
4. `ops\icons.md` steps 3-8 for the phase's owners: BEFORE read-back; own layers on every member and the composites
   on the two test VIs; `icon_set_class_icon.xml` on the three classes; `icon_set_library_icon.xml` on the two
   libraries; `icon_apply_icon_and_save_n.xml` per class; read-back of every VI and of the 5 owner icons, 0 px;
   versions; reentrancy flags re-checked; sweep of `src\protocol\` and `src\tests\` equal to the baseline. Commit
   per owner `style(cp): icons ...`. Do not touch `ZM-PC`, `ZM-CU`, `ZM-HW`, the CP parent, FL, the other test VIs
   or `ZM-TST-tests.lvlib`'s icon.
5. Phase-05 closing checks: a description on every VI of the phase (quote one per class from the sources in
   `proof\ZMP-05a\`, `proof\ZMP-05b\`, `proof\ZMP-05c\`); dependency rule from `lv_loadability.py --links` on the
   phase's VIs: UDP and MX VIs link only into their own class folders, `src\protocol\ZM-CP-communication_protocol\`
   and `src\common\ZM-PC-packages\`; none into `vi.lib\ActorFramework`, `ZM-CU`, `ZM-HW`, `ZM-TST`, `ZM-CP-FL`, nor
   between UDP and MX; the `.lvproj` `protocol` folder lists the four CP libraries once each; T4 and T5 evidence
   exist (`proof\runs\05c-checks.txt`, both Pass true, T4 with seven checks); every file of the phase at version 26;
   `docs\error-codes.md` names the sender's `ZM-CP-publish.vi` for the ignored codes 66 and 56 (it does already;
   edit only if a VI name differs); `git status --short` clean.
6. Final `lvai_status`; project closed; no unsaved window of ours.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops. Error 1562 on a class or library icon that a project open/close does not cure:
  report, no fallback.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj. Only the phase's VIs, the 3 `.lvclass` and the 2 `.lvlib` may
  change on disk; a `.lvproj` or `.ctl` change = stop and report. Absolute long-form paths. Nothing outside the
  product folder except helpers and the read-back folder.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop.

## Report (max 45 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The `ops\cleanup.md` block. 3. The `ops\icons.md` block. 4. The closing
checks, one line each with evidence (reentrancy flags included). 5. Commits; `git status`. 6. Deviations /
NEEDS CLARIFICATION; items for the user in the IDE (carried from 05a/05b). 7. Side effects.
