# Findings: run-01-2026-10-10

Requirement errors, skill gaps and tool issues, each with its evidence. Newest last.

## F1 (2026-10-10): labview-mcp MCP server failed to connect at session start

- **What:** at the start of the first session of run-01 the harness reported the MCP server
  `plugin:labview-mcp:labview` as "configured but failed to connect"; every `lvai_*`/`pylv_*` tool
  was unavailable to the manager and would be to any subagent. `lvai_status` (step 4 of
  `orchestration/phases/00-setup.md`) could not be called.
- **Also:** `<skill>/kit/lv_windows.ps1` at 14:44:14 showed LabVIEW process count 0 (exit 2),
  `NI.NigelLocalService` running (PID 19156, started 10:36:32), `LVNigelChat` not running,
  `LVAutoSave` count 0. So LabVIEW itself was not running either.
- **Effect:** phase 00 stopped after step 3 (manager-only steps). Steps 4 to 8 wait for the plugin
  to reconnect. No retry loop was run (`CLAUDE.md`, stop conditions).
- **Owner:** the user (reconnect the plugin, e.g. `/mcp`, or restart the Claude Code session).

## F2 (2026-10-10): LabVIEW 2026 Q3 crashed in `lvai_validate_aixml` on an invented VI Server method (tool issue)

- **What:** the 00b agent, following the plugin's documented probing recipe (`bin/docs/vi-server-reference.md`,
  "Probing for a name"), validated a negative-control AIXML with an invented method `ZZZNotAMethodZZZ` on
  `{LV.Application}`. LabVIEW (PID 2428) terminated at 15:13:55.
- **Evidence:** NI log `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEW_32_26.3.1f1_interactive_jorgen.steen_cur.txt`:
  `DWarn 0x762E6013: Out of bounds TypedObjList access (index: 1, nObj: 0)`, `source\diagram\invoke.cpp(74)`,
  executing `LV AI Core.lvlibp:VI generator.vi`, call stack through `ValidateAIXML.vi` and `RunService.vi`,
  minidump `fd529ccf-601a-49a4-d740-28409e75b42d`. `lv_windows.ps1` at 15:14:20: LabVIEW process count 0.
- **Why it matters:** the plugin's `bin/docs/ni-bug-validateaixml-crash.md` says an invented METHOD on a known
  class is reported as an error, not a crash. This is a new data point for that family. The probing recipe is
  unsafe on this station and is not to be used in this run.
- **Also a skill gap:** no source of the skill or the plugin has a measured route to create a `.lvproj` or an empty
  virtual folder; `lvai_lvproj_reference` says `.lvproj` generation is on NI's unsupported list. The vocabulary
  found offline in `lvserver.rsc` is in `status.md`, "Traps carried forward".
- **Owner:** labview-mcp (crash); the skill (project-creation route). Report: `reports/report-00b-project.md`.
