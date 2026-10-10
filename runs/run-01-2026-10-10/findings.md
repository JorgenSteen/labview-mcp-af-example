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
