# Brief 12l: a note on the root's panel pointing to the receiver VI, and the README
Type: small front-panel edit (LabVIEW calls) plus a README line. After the run (run-01 accepted). Asked for by the user
2026-10-12: "add to the front panel of the actor core that you should look in the reciever virtual folder and run the VI
there to look at the data that is being sent? add this to the documentation too". Which panel (the user's choice, asked
2026-10-12): **the root's panel loop, `ZM-ROOT-helperPanel.vi`** (the window with Stop and the errors list; the root's
Actor Core panel itself is never opened).

## Goal
1. **A free label (decoration text) on the front panel of**
   `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\src\actors\ZM-ROOT-root\ZM-ROOT-root\ZM-ROOT-helperPanel.vi`,
   text exactly (ASCII):
   `To watch the data being sent: in the project, open the virtual folder "receiver" and run ZM-receiver.vi (UDP 127.0.0.1:61557).`
   Place it in free space inside the panel's visible area (it opens when called; read the window bounds and the controls'
   bounds first), not overlapping Stop or errors; it may wrap over two lines. Nothing else on the panel or diagram
   changes: no control, label, value default, mechanical action, panel-on-call flag, pane, scope or icon. No Clean Up
   Diagram (the diagram does not change). The VI description stays as it is.
2. **README:** in `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\README.md`, section "Run it", the
   **Receiver** bullet: add that the root's panel shows this hint (one short sentence, same style). Nothing else changes.
Route: an in-place scripted edit with a derived helper (VI Server: the panel's `New VI Object`/decoration text or the
nearest measured route; find spellings from NI's scripting examples or `lvai_vi_server_reference`, never guess), then
`Save.Instrument`, project closed. Regenerate nothing.

## Checks
- A panel image after the edit (`{LV.Panel}` Get Image or the nearest route) saved as PNG in `...\proof\ZMP-12l\`, and
  its path in the report, so the manager can look at it. The label text read back from the panel equals the text above.
- The panel flags (show on call, close afterwards) and the Stop button's mechanical action read back unchanged (cold
  reads, `kit\pa_read_panel_on_call.xml`, `kit\pa_read_boolean.xml`).
- `exec_state` 1 cold; icon 0 px against `proof\icons`; `lv_save_version.py` 26.
- A headless run of `src\ZM-launcher_test.vi` (simulated hardware, a short run_time_ms): lines written > 0, ui_errors
  empty, error out 0 (this reads the errors control of the running helperPanel, so it proves the panel still works);
  then T1-T7 once.
- `git status` lists only `ZM-ROOT-helperPanel.vi` and `README.md` (restore anything else from git, project closed).
- Commit: `feat(root): receiver hint on the root panel` (both files), by explicit paths, no trailer of any kind.

## LabVIEW now
Not running (the manager killed it at the user's request, 2026-10-12 ~13:20). Start it with `lvai_ensure_labview`.
The user may have LabVIEW or the project open in the IDE when you start: check `lv_windows.ps1` and LVAutoSave first;
unsaved items this session did not make, or the project open in the IDE: stop and ask (NEEDS CLARIFICATION); do not
save, discard, close or kill them. **Standing go-ahead for this session (the user): you may start, restart, close and
kill a LabVIEW that this session started;** report each.

## Paths and skill
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; proof `...\proof\ZMP-12l\`; evidence
  `...\proof\runs\12l-checks.txt`.
- `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`knowledge\labview-mcp.md`: "Operating rules", "Project
  open or closed, per kind of call", "LabVIEW scripting quirks"; `ops\run-checks.md`; `ops\icons.md`; kit `pa_*`).
- Traps: texts are stored ANSI (the text is ASCII); a member of a LOADED library cannot be regenerated over its path
  (1357): no regeneration; panel flags are lost on regeneration (none here, but read them back); a scratch `LVMCP
  Validate*` VI brings up a save dialog on a LabVIEW close: kill instead; a project close may change only the `.lvproj`
  BOM/EOL: restore from git.

## Hard rules
- Strictly sequential LabVIEW calls: **one lvai_*/pylv_* call per message, never two, offline ones included.**
- A modal dialog: `lv_windows.ps1`, stop, never answer it. If labview-mcp does not answer: CANNOT PROCEED.
- No hand edits of `.vi`, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj`. Write only inside
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\`. Never push.
- Take times from `date`/`Get-Date`, not from memory.

## Report (max 35 lines), as your final message
1. `lvai_status`/windows start and end; starts and kills. 2. Route (helper, spellings, where they came from). 3. Label:
position, read-back, panel image path. 4. Flags, mechanical action, exec_state, icon, version. 5. launcher_test run,
T1-T7. 6. README change. 7. Commit, `git status`, side effects. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
