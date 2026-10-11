NEEDS CLARIFICATION (phase 09c, run-01). I stopped before touching the member. Nothing is committed and nothing under `src\` changed: `git status` shows only the untracked `notes-for-run-02.md`, which is not mine. The project is closed, there are 0 dialogs, and I started LabVIEW 0 times.

**Question 1: how should a producer-loop error end the event loop?**
Built literally from `02` §7.11, a producer error (for example the 5000 from a bare `ZM-HW-do`) ends only the producer loop. The event loop keeps waiting for the `stop` user event. That event comes only from Actor Core after Call Parent returns, and Call Parent returns only after a stop, which the loop VI sends "after both loops". So the HWM keeps running with a dead producer until something else stops it. The evaluateError log and the error package then go out only at shutdown. `03` R-error reads `ui_errors` before it sends Normal Stop and expects the ErrorPackage there and the HWM already stopped. Built literally, that check will fail.
- (a) **Recommended.** After the producer loop, only when it ended on an error, call the existing private member `ZM-HWM-stop.vi` (Read events → Generate stop). The event loop then exits and the "after both loops" path runs as specified (evaluateError → Read Self Enqueuer → Send Normal Stop). The later stop from Actor Core then goes to an event nobody is registered for, which does nothing. The Generate's error in comes from Register's error out, so it can only run after the registration exists. No new name, one extra call.
- (b) As (a), but unconditional (generate the stop on every producer exit).
- (c) Another shape you name (for example evaluateError + Send Normal Stop right after the producer loop).

**Question 2: should `error out` be the cleared error, not the raw merged one?**
I would build it so `error out` carries the merged loop errors after handling: Error frame = evaluateError (which clears the error per §5) → Read Self Enqueuer → Send Normal Stop. If `error out` carried the raw 5000, Actor Core would merge it into the Last Ack, and that breaks phase 09's done-when ("a clean Last Ack"), `03` R-error and D14. I will build it this way unless you say otherwise.

**Interim status: all five unmeasured points are now measured on throwaways in `proof\ZMP-09c\`.**
- (1) `lvai_generate_vi_with_events` keeps an Event Structure nested in the No Error frame of a case inside a while loop. The export shows Loop / Case / No Error / Event Structure with frames ` Timeout ` and ` <stop>\3A User Event `. A Flat Sequence Frame authored in AIXML also generates.
- (4) A second plain producer loop beside the event loop in the same document generates fine.
- (2) `lvai_wire_dynamic_events` (`finishUserEvents: false`) does not reach that depth: Error 91 / helperDidNotAnswer, the file was not changed. Its search stops two levels down, and this Event Structure is three levels down.
- (3) I wrote a derived helper, `proof\ZMP-09c\zmp09c_wire_dyn_deep.xml`, combining the kit's `pa_wire_dyn_right` and the plugin's diagram fallback, searching three levels; the kit itself is not edited. It wires both sides. Answer: event structure, both terminals, Register and Unregister all found; left wire 2 ends, not broken; right wire 2 ends, not broken; error 0.
  - The case output tunnel LabVIEW creates for the right side has no value in the Error frame. That breaks the VI.
  - The VI Server property "Use Default if Unwired" exists in `lvserver.rsc` but is refused by the AIXML catalogue ("Invalid property").
  - Fix: `proof\ZMP-09c\zmp09c_set_use_default.py` sets that tunnel's flag in the pylv bundle (objFlags 0x100801 → 0x300801). The value is copied from NI's own accessor `ZM-PC-TP Read data.vi`, which exports that kind of tunnel as `cond="true"`. The script runs in the same extract/rebuild round trip as `set_user_event_specs.py 1:stop:1`.
  - Result: cold state **1** with the flag. Negative control without the flag: state **0**.
  - The export shows the shape: Register before the loop with a fresh no-error, the refnum through the loop/case tunnels into the dynamic terminal, the case `Out3 cond="true"` → loop tunnel → Unregister.
- (5) Plot names work with spellings from `lvserver.rsc`: chart `Active Plot` → `Plot` → `{LV.Plot} Plot Name`, set by the derived helper `proof\ZMP-09c\zmp09c_set_plot_names.xml` with the project closed. Answer: `temperature_c` / `duty_percent`, error 0. The saved file holds both `plotName` entries (checked with pylv offline).
- Stubs: the tool flattened `Read prelaunchSettings` to a scalar path (the 08b trap again). I will hand-make `LVMCP Stub ZMP09c-readPrelaunchSettings.vi` and `LVMCP Stub ZMP09c-hwClose.vi`, because HW init and close share stub 8600a790d2.

**Status and side effects**
- `lvai_status` at the start: ok, port 59983, PID 14516, dwarn 4. At the end: ok, same port, dwarn 9 (the latest is "bad to good after compiling" on the throwaway), not degraded.
- About 22 LabVIEW calls, one per message.
- Six new tool stubs in `user.lib\LV_MCP`: 494e8c7848 (unused), 17e772cb85, 8600a790d2, dbed506375, 91950b9cd6, 9475868c6c.
- Two new helpers in `%TEMP%\LabVIEWMCP\helpers\`: `zmp09c_wire_dyn_deep.vi` and `zmp09c_set_plot_names.vi`. The plugin also regenerated its own `lvai_wire_dyn_events.vi` there.
- The project was opened and closed once. The close sweep removed 2 adopted helper entries and dropped the `.lvproj` BOM. I restored the `.lvproj` from git with the project closed, so it is CRLF with the BOM again.
- Proof files (git-ignored): the throwaway VIs, bundles and exports.

When you answer, continue this agent and I will build the member.
