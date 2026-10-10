# Brief 02b: finish phase 02: Clean Up Diagram, icons, cold sweep and closing checks for `ZM-CU` and T2
Type: build (LabVIEW calls). Phase 02 step b of 2 (last step of the phase).

## UPDATES (read first)
- Reports to read: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-02a-cu-log-test.md`
  (what 02a built, its sweep baseline), `report-01d-pc-cleanup-icons-preview.md` and `report-01e-pc-icons-apply-sweep.md`
  (the measured cleanup and icon routes on this station, their report blocks are your models).
  <<MANAGER: traps from reports 01e and 02a go here before launch>>
- Save version **26.0**; LabVIEW 2026 Q3 32-bit, so a save with no project open writes the same version.
- User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself when it crashes or
  stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported. Never answer a dialog.
- Decided D39 (2026-10-10): the icons are applied as `make_icons.py` draws them, with NO preview prompt; the
  preview was approved once for the whole project. Decided D38: class descriptions and folder placement are the
  user's (no class in this phase).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; icon helpers need the project CLOSED; `icon_apply_icon_and_save_n.xml` takes
  `vi paths` with no trailing `;`; the read-back folder must be short and exist; `lvai_set_vi_icon` before any template.

## Goal
(1) Clean Up Diagram on the two VIs phase 02 generated (`ZM-CU-log.vi`, `ZM-TST-log.vi`), proven. (2) Regenerate the
icon PNGs (the spec is unchanged; `make_icons.py` draws the whole `src`, only the new VIs are applied), set the
`ZM-CU-common_utilities.lvlib` icon, and give the two VIs their icons per the spec (`ZM-CU-common_utilities` is a
`library_owner` in `no_template`/`library_owners`: its VI gets the library template applied through
`icon_apply_icon_and_save_n.xml` with `is library` true after its own layer; `ZM-TST-log.vi` gets its composite).
Read back, 0 px. (3) The phase-02 closing checks. Nothing else changes; nothing under `src\common\ZM-PC-packages\`.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`
  (CLOSED throughout). VIs: `...\src\common\ZM-CU-common_utilities\ZM-CU-log.vi`, `...\src\tests\ZM-TST-log.vi`.
  Library: `...\src\common\ZM-CU-common_utilities\ZM-CU-common_utilities.lvlib`.
- Icons: `...\proof\icons\` (regenerate there); spec `...\.labview\conventions\icon-spec.json`; read-back folder
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\02b\` (create it). Scratch `...\proof\ZMP-02b\`.
  Helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\cleanup.md`, `ops\icons.md` (steps 2-8;
  step 2's "show the preview and get approval" is satisfied by D39: say so, do not ask), `ops\sweep.md`,
  `kit\README.md`, `knowledge\labview-mcp.md` ("Operating rules", "lvai_set_vi_icon and icon work").
- Conventions: `...\.labview\conventions\hygiene.md` (`cleanup-diagram`), `icons.md`.
- Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §1 (dependency rule), §7.2.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point = HEAD; versions scanned.
2. Cleanup per `ops\cleanup.md` on the two VIs (BEFORE sweep, one batch, versions, git shows only the two `.vi`,
   AFTER sweep = BEFORE, panel checks none needed). Commit `style(cu): clean up diagrams ...`.
3. `python <skill>\kit\make_icons.py --spec <spec> --src <src> --out <out> --check`, then generate; count the
   PNGs; the new entries in `manifest.json` for the two VIs and `_libs\ZM-CU-common_utilities.png`.
4. `ops\icons.md` steps 3-8 for the two VIs and the one library: BEFORE read-back; own layer / composite with
   `lvai_set_vi_icon`; `icon_set_library_icon.xml` on `ZM-CU-common_utilities.lvlib`; `icon_apply_icon_and_save_n.xml`
   on `ZM-CU-log.vi` with `is library` true (if the spec treats it as a library owner; else report what the spec
   says and do what `icons.md` prescribes for it); read-back of both VIs and the library icon, 0 px; versions;
   sweep of `src\common\ZM-CU-common_utilities\` and `src\tests\` equal to the baseline. Commit per owner
   `style(cu): icons ...`. Do not touch `ZM-TST-tests.lvlib`'s icon or `ZM-TST-packages.vi` (done in 01e).
5. Phase-02 closing checks (`orchestration/plan.md`, "Every build phase ends with"): descriptions on both VIs
   (quote from the AIXML sources in `proof\ZMP-02a\`); dependency rule: `python <skill>\kit\lv_loadability.py
   --links` on `ZM-CU-common_utilities.lvlib` shows no link to any `ZM-` library or to `vi.lib\ActorFramework`;
   the `.lvproj` lists `ZM-CU-common_utilities.lvlib` once under `common`; T2 evidence exists
   (`proof\runs\02a-checks.txt`, Pass true); every file of the phase at version 26; `git status --short` clean.
6. Final `lvai_status`; project closed; no unsaved window.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops. Error 1562 on a library icon that a project open/close does not cure: report, no fallback.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj. Only the two VIs and the one `.lvlib` may change on disk.
  Absolute long-form paths. Nothing outside the product folder except helpers and the read-back folder.
- Commit by explicit paths, Conventional Commits, no attribution trailer. Never push. Save version 26.0 or stop.

## Report (max 45 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The `ops\cleanup.md` block. 3. The `ops\icons.md` block (PNG counts,
own layers, templates, apply codes, read-back px, versions, sweep, commits). 4. The closing checks, one line each
with evidence. 5. Commits; `git status`. 6. Deviations / NEEDS CLARIFICATION. 7. Side effects.
