# Brief 12k: apply the short VI and class descriptions (62 VIs, 6 classes)
Type: docs in the VIs (LabVIEW calls). After the run (run-01 accepted 2026-10-12). Asked for by the user 2026-10-12:
"The VI desription is too long. your shorter description is good. lets do that"; the texts were written by the manager
and the user waived a review ("for 3 you dont need my review").

## Input
`C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\descriptions-new.json` (read-only for you):
- `vis`: 62 entries, `path` relative to the product folder (`src/...`), `new` = the new description. Replace the
  **whole** description with `new`, exactly (ASCII, as written). `current` is the 12i read; T4's (`ZM-TST-protocol.vi`)
  changed since (12j), so match on the live text, not on `current`.
- `classes`: 6 entries (`.lvclass` paths), `new` = the new class description (`NI.Lib.Description`).
- Nothing else changes: no diagram, pane, panel, icon or scope; every VI and class not in the file keeps its text.

## Route
1. **VIs, project closed:** read the live `VI Description`, write `new`, read it back, `Save.Instrument`, the same way
   `<skill>\kit\pa_replace_description.xml` does (it keeps icon, layout and state 1). A derived batch helper that writes
   the whole text for a list of VIs is fine; dry run on one VI first, then the rest. Clean Up Diagram is NOT needed
   (the diagram does not change).
2. **Classes, project open and active:** `<skill>\kit\pa_set_class_description.xml` (the same file as
   `C:\project\claude\LabVIEW-AFAItest\orchestration\vi-server-helpers\zmp12f_set_class_description.xml`; README there):
   `LVClass.Open` on the project's application, write `Description`, read back, `Save`. Then close the project; if the
   close changed only the `.lvproj` BOM/EOL, restore it from git with the project closed.

## Checks
- Offline read-back of all 137 VI descriptions (the 12i extract scripts in `...\proof\ZMP-12i\scripts\`, e.g.
  `extract_all.py`, into `...\proof\ZMP-12k\`): the 62 equal `new` byte for byte; the other 75 equal 12i's
  `...\proof\ZMP-12i\inventory.json` (T4 aside). The 6 `.lvclass` `NI.Lib.Description` equal `new`; the other 9 unchanged.
- Cold sweep of all `src\` (`ops\sweep.md`) with the negative control; `lv_save_version.py` 26 on every changed file;
  icons 0 px against `proof\icons` (`pixcmp --tree`); T1-T7 once (`ops\run-checks.md`).
- `git status` lists only the 62 VIs and the 6 `.lvclass` (restore anything else from git, project closed).
- Commits by explicit paths: `docs(src): short VI descriptions` (the VIs) and `docs(src): short class descriptions`
  (the classes). No trailer of any kind. Never push.

## LabVIEW now
PID 27076, port 61113 (started by the 12j agent 11:56:42), project closed, 0 unsaved, no dialog, LVAutoSave 0.
**Standing go-ahead for this session (the user): you may start, restart, close and kill LabVIEW at will;** report each.

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; proof `...\proof\ZMP-12k\`; evidence
  `...\proof\runs\12k-checks.txt`.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`kit\README.md`, `kit\pa_replace_description.xml`,
  `kit\pa_set_class_description.xml`, `ops\sweep.md`, `ops\run-checks.md`, `ops\icons.md`, `knowledge\labview-mcp.md`:
  "Project open or closed, per kind of call", "LabVIEW scripting quirks").
- Traps: texts are stored ANSI (ASCII only; every `new` is ASCII); a member of a LOADED library cannot be regenerated
  over its path (1357): no regeneration here at all; a project close may change only the `.lvproj` BOM/EOL: restore
  from git; the scratch `LVMCP Validate*` VIs bring up a save dialog on a LabVIEW close: kill instead (go-ahead above);
  the in-memory list helper's answer can exceed the tool-result limit (`...\proof\ZMP-12h1\mem_lines.py`); a Claude Code
  permission check may refuse a helper run: report it word for word and stop, do not retry.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: **one lvai_*/pylv_* call per message, never two, offline ones included.**
- A modal dialog: `lv_windows.ps1`, stop, never answer it. If labview-mcp does not answer, stop: CANNOT PROCEED.
- No hand edits of `.vi`, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj`. Write only inside
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\`.
- Take times from `date`/`Get-Date`, not from memory.

## Report (max 40 lines), as your final message
1. `lvai_status` start/end; kills/starts. 2. Route for VIs and classes (helpers, dry run). 3. Read-back: 62 + 6 equal,
the rest unchanged (counts; any mismatch named). 4. Sweep, versions, icons, T1-T7. 5. Commits, `git status`. 6. Side
effects. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
