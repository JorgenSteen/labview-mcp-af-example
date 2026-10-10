# Brief 01e: apply the approved icons to phase 01's classes, library and VIs; read back; final sweep
Type: build (LabVIEW calls). Phase 01 step e of 5 (last step of the phase).

## UPDATES (read first)
- Reports to read: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-01d-pc-cleanup-icons-preview.md`
  (the generated PNGs, the manifest, the kit TODO differences) and `report-01c-pc-test.md` (sweep baseline 25/25).
  <<MANAGER: the user's approval of the preview, quoted with the date, and traps from report 01d go here>>
- Save version **26.0**; LabVIEW 2026 Q3 32-bit: a save with no project open writes the same version, no conflict.
- User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself when it crashes or
  stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported. Never answer a dialog.
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error 1059;
  `sweep_paths.py` needs `--out`; class and library icon helpers need the project CLOSED (open = 1562);
  `icon_apply_icon_and_save_n.xml` takes `vi paths` with NO trailing `;`; `Save VI Icon to File` writes nothing into
  a missing folder or a path over ~260 characters, so the read-back folder must be short and must exist;
  `lvai_set_vi_icon` flattens a VI's icon, so it always comes BEFORE the class template is applied.

## Goal
Every VI, class and library phase 01 made carries the approved icon per `icons.md`: the class template (banner +
glyph) set on each of the three classes and on `ZM-PC-packages.lvlib` and `ZM-TST-tests.lvlib`, applied by LabVIEW
to every member as the `NI_Library` layer; each VI its own glyph layer; `ZM-TST-packages.vi` its composite (it has
a library template from `ZM-TST-tests.lvlib`: follow `icons.md` for a library owner, `library_owners`/`no_template`
as the spec says). Proven by a pixel read-back, unchanged versions and a sweep equal to the baseline. Then the
phase-01 closing checks below. Nothing else changes.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`
  (CLOSED for every icon helper). Classes: `...\src\common\ZM-PC-packages\ZM-PC-package\ZM-PC-package.lvclass`,
  `...\ZM-PC-TP-test_package\ZM-PC-TP-test_package.lvclass`, `...\ZM-PC-EP-error_package\ZM-PC-EP-error_package.lvclass`;
  libraries `...\src\common\ZM-PC-packages\ZM-PC-packages.lvlib`, `...\src\tests\ZM-TST-tests.lvlib`.
- Generated icons: `...\zuehlke-mcp-af-test-results\proof\icons\` (`manifest.json`, `_own\`, `_classes\`, `_libs\`,
  composites). Read-back folder (short!): `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\01e\` (create it).
  Scratch: `...\proof\ZMP-01e\`. Helpers: `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\icons.md` steps 3-8 and Traps (follow
  literally), `ops\sweep.md`, `kit\README.md` (icon helpers), `knowledge\labview-mcp.md` ("lvai_set_vi_icon and icon
  work", "Helper VIs (the kit)"). Conventions: `...\.labview\conventions\icons.md` (rules `labview-template`,
  `vi-glyph`, `library-icon`, `existing-icons`), `icon-spec.json`.
- Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §1 (dependency rule), §7.1.

## Route
1. `lvai_status`; project closed; `git status --short`; commit point = HEAD. Versions scanned (all 26 expected).
2. `ops\icons.md` step 3: BEFORE read-back of the 25 VIs and of the 3 class and 2 library icons.
3. Step 4: the VI's own layer for each of the 24 class members (`lvai_set_vi_icon` with its `_own` PNG), and the
   composite for `ZM-TST-packages.vi` if the spec treats `tests` as a no-template owner (else its own layer).
   Commit per class folder.
4. Step 5: class template on the three classes (`icon_set_class_icon.xml`) and the library icons on the two
   libraries (`icon_set_library_icon.xml`). Commit.
5. Step 6: `icon_apply_icon_and_save_n.xml` per class (`vi paths` = that class's members, `is library` false) and,
   if the spec makes `ZM-TST-tests.lvlib` a library owner, per library (`is library` true). `open codes` and `save
   codes` all 0. Commit per owner.
6. Step 7: read-back (`icon_readback_inputs.py`, `icon_get_vi_icons_n_file.xml`, `pixcmp.py --tree`): every VI 0 px
   against the composites in `proof\icons`; class and library icons read into a folder outside the read-back tree
   and compared with their template PNGs. Count the PNG files = the VI count.
7. Step 8 and the phase-01 closing checks (`orchestration/plan.md`, "Every build phase ends with"):
   - versions re-scanned, all 26; cold sweep of `src\common\ZM-PC-packages\` and `src\tests\` equal to the
     baseline (25/25, control `0 7`, membership clean);
   - descriptions: every VI of the phase has one (read the AIXML sources in `proof\ZMP-01b\`, `proof\ZMP-01c\`, or
     export one VI per class and quote the attribute); class descriptions are the user's (D38);
   - dependency rule: `python <skill>\kit\lv_loadability.py --links "<ZM-PC-packages.lvlib>"` (or the `.lvclass` files)
     shows no link into `vi.lib\ActorFramework` and no link to another `ZM-` library; quote the link summary;
   - the `.lvproj` lists `ZM-PC-packages.lvlib` once under `common` and `ZM-TST-tests.lvlib` once under `tests`;
   - `git status --short` clean after the last commit.
8. Final `lvai_status`; project closed; no unsaved window (`lv_windows.ps1`).

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops. Error 1562 on a class icon: report it; the fallback (`lvai_set_vi_icon` with composites,
  no `NI_Library` layer) only if the UPDATES grant it, else stop and report.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. Every icon helper runs with the project CLOSED.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj. Only the 25 VIs, the 3 `.lvclass` and the 2 `.lvlib` may change
  on disk; a `.lvproj` or `.ctl` change = stop and report. Absolute long-form paths.
- Nothing outside the product folder except helper VIs and the read-back folder named above. Never push. Commit by
  explicit paths, Conventional Commits (`style(pc): icons ...`), no attribution trailer. Save version 26.0 or stop.

## Report (max 50 lines), as your final message
1. `lvai_status` start/end; LabVIEW starts made. 2. The `ops\icons.md` report block (own layers, templates, apply
codes, read-back px and file counts, owners, versions, sweep, git, commits, kit TODO differences, issues).
3. The phase-01 closing checks, one line each with its evidence (descriptions, dependency links, `.lvproj` lines,
sweep, versions). 4. Commits; `git status`. 5. Deviations / fallbacks / NEEDS CLARIFICATION. 6. Side effects.
