REPORT 12g, option A (2026-10-12, first part 08:41-08:45, resumed 08:57, finished 09:03). **DONE.** `releaseProtocol` now logs a release error and passes it on through its `error out`. CM `Stop Core.vi` is unchanged apart from its description. Committed as a0baa7f; not pushed.

**1. Status and calls**
- `lvai_status` at 08:42: ok, PID 26716, port 56779, dwarn 0. At 08:57 after the reconnect: same. At the end (09:02): same, up 44396 s, dwarn 0, not degraded.
- `lv_windows.ps1` at the start and the end: 0 dialogs, LVAutoSave 0. The only 2 unsaved windows are the tool's hidden `LVMCP Validate`.
- No start, restart, close or kill. The project stayed closed the whole time. Every LabVIEW call went alone in its own message.

**2. releaseProtocol: route and new dataflow**
- Route: an in-place scripted edit with a derived helper, `proof\ZMP-12g\zmp12g_release_pass_on.xml`, run in the default instance. No regeneration.
- Dry run first: every node and wire it looks for was found exactly once.
- Apply: every error indicator read 0. The VI reads state 1 cold.
- The export (`proof\ZMP-12g\export-releaseProtocol.xml`) and the before/after nets (26 to 28 wires) show:
  - ZM-CP-close `error out` goes to Unbundle (the log case, unchanged) and now also to `Clear Errors.error in`.
  - The existing "never opened code" constant (1) feeds Clear Errors' `specific error code to clear`.
  - `Merge Errors(Clear Errors out, Write protocol error out)` feeds `error out`. So the close error comes first, then a log failure.
  - Write protocol still gets only the log-case output, so it still runs after a close error.
  - Nothing else changed: pane, private scope and static are as before.

**3. Stop Core**
- Kept as built: Call Parent, then releaseProtocol, then Clear Errors. AF's Stop Core has no error out.
- Only its description changed.
- I corrected D44 in `.labview\decisions.md` to option A, with your words of 2026-10-11 and 2026-10-12.

**4. Descriptions, cleanup, icons**
- Both descriptions were changed with `pa_replace_description`, one replacement each, ASCII only:
  - releaseProtocol: "...and then passed on (D44): error out = Merge Errors(...)".
  - Stop Core: "...passed on by the hook (D44); the hook's error out ends here in Clear Errors, because AF's Stop Core has no error out".
- Clean Up Diagram ran on releaseProtocol only, code 0. I left Stop Core's diagram alone, because only its description changed.
- Icons of both VIs read back at 0 px against `proof\icons` (`pixcmp --tree`, exit 0).

**5. Runs** (evidence in `proof\runs\12g-checks.txt`)
- Normal-stop run of `ZMP-08c-launch_cm.vi`:
  - 3 lines written; launch, send, stop, read and error out all 0.
  - `ZM-error_log.txt` is byte-identical before and after.
  - The Last Ack error could not be read: this proof VI has no indicator for it.
- Forced non-1 close error: **not forced.** Running releaseProtocol directly with `error in` = 5000 was refused with 1390, because a private VI cannot run top-level. A forced run would need an edit to the class.
- T1 to T7 all pass with error 0, except the known flaky T4:
  - T4 ran three times. Run 1 failed on `init_ok` alone (the known flaky F13, error 0); runs 2 and 3 passed.
  - The error log grew from 14 to 18 lines, all expected: 2 T2 markers and 2 ROOT lines from T7.

**6. Sweep, versions, commit**
- Cold sweep of the CM folder: 13/13 state 1, negative control `0 7`. `check_membership`: 13 checked, 0 not a member, exit 0.
- `lv_save_version`: all 13 VIs are 26, the `.lvclass` is 26008000.
- Commit a0baa7f `fix(cm): log and pass on a release error from releaseProtocol (D44)`, by explicit paths, no trailer. It holds the two VIs and `.labview\decisions.md`.
- `git status --short`: only the two untracked runs files, which are not mine.

**7. Side effects**
- Re-saved: only the two committed VIs. No `.lvclass`, `.lvlib` or `.lvproj` change.
- New helper `%TEMP%\LabVIEWMCP\helpers\zmp12g_release_pass_on.vi`, and read-backs in `%TEMP%\LabVIEWMCP\rb\12g*`.
- Git-ignored, new: `proof\ZMP-12g\` (helper source, nets, export, sweep list, error-log copy), `proof\runs\12g-checks.txt` and `output\test_cm_172857696`. The error log grew by 4 lines.
- The 08:44 MCP disconnect was your own fork test, as the coordinator relayed.

DONE
