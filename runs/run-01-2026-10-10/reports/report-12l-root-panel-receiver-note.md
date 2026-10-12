Report 12l: receiver hint on the root panel. The label is on the panel, the README line is in, and everything is committed. One deviation: the label has the "Label (modern)" look, not a plain free label (item 3).

1. **Start, end, starts and kills**
   - First check, 13:39: the project was open in the IDE and LVAutoSave held 2 files. I stopped with NEEDS CLARIFICATION.
   - The user then closed the project. Check at 13:40: project closed, LVAutoSave 0, 0 unsaved, 0 dialogs. `lvai_status` answered (up 2144 s, dwarn 0).
   - End, 13:50: the same state, and nothing of the product left open.
   - I worked in the user's LabVIEW, PID 14692. I started, restarted, closed and killed nothing. The project stayed closed throughout.
2. **Route**
   - Derived helpers, run with the project closed in the default instance. Their sources are in `...\zuehlke-mcp-af-test-results\proof\ZMP-12l\`.
   - The edit: the "Owning Pane" of `Controls[0]` → `New VI Object` (class `ref{LV.Generic}`) → `To More Specific Class` `{LV.Text}` → write `Text` → read it back → `Save.Instrument`.
   - Where the spellings came from:
     - Style ring values: NI's `Adding Objects.vi`.
     - Generic class with a panel owner: NI's `New VI Object Location Argument.vi`.
     - "Owning Pane": `resource\lvserver.rsc` (it is not in `lvai_vi_server_reference`).
   - Three failed tries before the one that worked, each answering 1060 ("Object cannot contain the specified object"):
     - style 2321 ("Free Label") with owner Panel and class Text;
     - style 2321 with owner Panel and class Generic;
     - style 2321 with owner Pane and class Generic.
   - None of them saved anything (`git status` was clean after each).
   - Style 21960 ("Label (modern)") worked.
3. **Label**
   - Position: 16,285 to 667,302, on one line. The visible area is 1073x589 from origin 0,0.
   - Nothing overlaps: Stop ends at y 263, and errors / error out end at y 208.
   - The cold read-back shows 1 decoration of class Text, and its text equals the brief's text exactly. The controls and the window bounds are unchanged.
   - Panel image: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12l\ZM-ROOT-helperPanel-panel.png` (651x302). It was made with FP.Get Image → Write to Binary File → a standard-library Python script that writes the PNG.
   - **Deviation:** style 21960 draws the text with a framed, lighter background, not as a plain free label. It reads fine in the image, but it is not what "free label" usually means. If you want the plain look, the user can change it in the IDE.
4. **Panel flags, Stop, state, icon, version** (cold reads):
   - Show front panel on call and close afterwards: 1 and 1, before and after.
   - Stop button: mechanical action 1 (switch when released), visible 1, before and after.
   - `exec_state` is 1.
   - The icon differs from `proof\icons` by 0 px of 1024.
   - `lv_save_version.py` reads 26 (the file grew from 26859 to 27043 bytes).
   - No regeneration and no Clean Up Diagram.
5. **launcher_test and T1-T7**
   - `ZM-launcher_test.vi` (run_time_ms 3000, simulated hardware): lines_written 6, error_lines 0, ui_errors empty, error out 0. The last line is a TestPackage with destination Communication.
   - T1-T7 (packages, log, hardware, protocol, udp, pipeline, routing): each Pass=T with error out 0.
   - Evidence: `...\proof\runs\12l-checks.txt`.
6. **README:** the Receiver bullet in "Run it" now ends with: "The root's panel shows this hint (the `receiver` virtual folder in the project)." Nothing else in the README changed.
7. **Commit and `git status`**
   - Commit `19bc59f feat(root): receiver hint on the root panel` holds the two files only, committed by explicit paths with no trailer.
   - `git status` after the commit still lists files I did not touch:
     - modified: `runs/run-01-2026-10-10/status.md`
     - untracked: `runs/.../lessons-mcp-skill.md`
     - untracked: `runs/.../notes-for-run-02.md`
     - untracked: `zuehlke-mcp-af-test-results/docs/user-guide.html`

     `status.md` and `user-guide.html` showed up during my work. I did not write them and left them alone.
   - `proof/` is git-ignored, so the panel image and evidence are on disk only.
   - Side effects: my helper VIs are in `%TEMP%\LabVIEWMCP\helpers\` (pa12l_*), plus `%TEMP%\LabVIEWMCP\rb12l\`. The project was never opened, so the `.lvproj` was not touched. Scratch `LVMCP Validate` VIs may sit in memory; discard them if LabVIEW asks on close.

DONE
