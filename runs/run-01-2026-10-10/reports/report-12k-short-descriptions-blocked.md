REPORT 12k (short descriptions), 2026-10-12, 12:45 to 12:46. NEEDS CLARIFICATION. Nothing was changed. I stopped before any write because LabVIEW is not in the state the brief describes.

1. lvai_status and windows
- `lvai_status` at 12:45: PID 27076, port 61113, up 2955 s, dwarn 0, not degraded. labview-mcp 1.9.5-local. This is the only LabVIEW call I made. No kills and no starts.
- `lv_windows.ps1` at 12:45:34: 0 dialogs, 0 `*` titles. But the project is open: "Zuehlke MCP.lvproj - Project Explorer" is visible. LVAutoSave holds 4 files.
- The brief expected the project closed and LVAutoSave 0. 12j left it that way at 12:00.

2. What the IDE shows (no LabVIEW call needed)
- The 4 autosave files are all from 12:10:39:
  - `NI32LV2631f1ASD1_Zuehlke MCP.lvproj` and its `.txt`
  - `NI32LV2631f1ASD2_ZM-HWM-helperAcquisition.vi` and its `.txt`
- LabVIEW's log, written 12:10:39, has this undo stack: "Maximize, Change Attribute, Window Size", on `Zuehlke MCP.lvproj` and on `src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\ZM-HWM-helperAcquisition.vi`.
- So the project was opened in the IDE after 12j, most likely by the user. The project and `ZM-HWM-helperAcquisition.vi` have unsaved edits in memory, apparently window size or attribute only. This session did not make them.
- Nothing is on disk yet. In `git status`, the product folder is clean.

3. Why I stopped
- Step 1 of the route (VI descriptions) needs the project closed.
- Any way of closing it touches those unsaved edits:
  - `lvai_close_active_project` saves them.
  - A kill discards them.
  - An IDE close raises a save prompt.
- `ZM-HWM-helperAcquisition.vi` is one of the 62 VIs, so a save would also change it beyond its description.
- The standing go-ahead covers close and kill. The skill and CLAUDE.md still require asking before saving or discarding unsaved work this session did not make, and the user may be working in the IDE right now.

QUESTION FOR THE USER (please answer one):
A) You close the project in the IDE yourself (Save or Don't Save, your choice), then tell me to go on. I then work from LVAutoSave 0.
B) I discard the unsaved edits: kill LabVIEW (PID 27076) under the standing go-ahead and start a cold LabVIEW. Your window-size changes on the project and on `ZM-HWM-helperAcquisition.vi` are lost.
C) I close the project with `lvai_close_active_project`, which saves your edits to `Zuehlke MCP.lvproj` and `ZM-HWM-helperAcquisition.vi`. Then:
   - The window or attribute change is committed together with the description commit.
   - Any `.lvproj` BOM/EOL-only change is restored from git.

4. to 6. Read-back, sweep, versions, icons, T1-T7, commits, side effects: not started. No helper was generated, no file was written, and there are no commits. `git status --short` shows only the manager's `runs/` files.

NEEDS CLARIFICATION
