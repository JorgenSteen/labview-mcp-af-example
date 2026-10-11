# Brief 05a2: finish 05a: recover the open project, hook the four UDP overrides, checks, report
Type: build (LabVIEW calls). Phase 05 step a2 (the rest of 05a; a fresh agent, because the 05a agent of session 1
cannot be resumed).

## UPDATES (read first)
- Read `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\briefs\brief-05a-cp-udp.md` in full: it is the
  original task (names, shapes, hook typing, hard rules). This brief covers only what is left of it.
- **State at the hand-over (2026-10-11 09:30, from git and `lv_windows.ps1`, no LabVIEW call):** HEAD 29e2187 "bare
  overrides ZM-CP-init and ZM-CP-close with Call Parent in ZM-CP-UDP-sender and ZM-CP-UDP-receiver (restore point
  before the hooks)". Done and committed: both classes with fields, accessors and scopes; hooks `openSender`,
  `openReceiver`, both `closeConnection` (parent-typed pane, cast inside); the sender's `publish` override; the
  receiver's `receive`; `ZM-CP-UDP-udp_transport.lvlib` holding both classes, listed once under `protocol`; the four
  bare overrides. A cold sweep after that step read 18/18 state 1 (`proof\ZMP-05a\ZMP-05a-sweep-after-library-and-bare-overrides.txt`).
  Then the agent opened the project to start hooking and was cut off: LabVIEW PID 14040 still runs with
  `Zuehlke MCP.lvproj` OPEN and LVAutoSave 2 (unsaved edits in memory, probably a half-made hook).
- **Not done:** the four hooks into the overrides, the exports, `check_membership.py`, the final sweep, the probe
  (sender with no listener: `error out` 0), the versions and links checks, and the report.
- AIXML sources and sweeps of 05a: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-05a\`.
- Model: the session runs on Opus 5.5 since the user's `/model` on 2026-10-11.
- <<MANAGER: the user's LabVIEW go-ahead for THIS session, quoted with the date, goes here; without it, the agent
  may not restart or close LabVIEW, only close the project (step 1)>>

## Route
1. **Recover.** `lv_windows.ps1` (no LabVIEW call), then `lvai_status`. If no dialog and the project is open:
   `lvai_open_file` with the project path (check `activeProjectPath` is ours), then `lvai_close_active_project` with
   `projectPath` (it SAVES what is in memory). Then `git status --short`: every product file the save changed is
   compared with HEAD 29e2187. If only the `.lvproj` changed in a way the earlier closes also produced (BOM,
   ordering), keep it and say so; if an override or hook VI changed, **restore it from git with the project closed**
   (`git checkout 29e2187 -- <paths>`) and say which. Then a cold sweep of the library folder must read 18/18 state 1
   again.
2. **Hooks** (brief 05a, step 5 and the "Hook typing" paragraph; `ops\override.md` shapes B and B-after; project
   open and active; commit after each; `pa_save_member` in a separate call after each `pa_insert_series2`):
   - sender `ZM-CP-init.vi`: Call Parent → `ZM-CP-UDP-openSender` (B-after);
   - sender `ZM-CP-close.vi`: `ZM-CP-UDP-closeConnection` → Call Parent (B, before Call Parent);
   - receiver `ZM-CP-init.vi`: Call Parent → `ZM-CP-UDP-openReceiver` (B-after);
   - receiver `ZM-CP-close.vi`: `ZM-CP-UDP-closeConnection` → Call Parent (B).
   Export each override and quote the order (Call Parent and hook lines).
3. **Checks** (brief 05a, step 6): project closed; cold sweep of `src\protocol\ZM-CP-UDP-udp_transport\` (18 VIs,
   state 1, control `0 7`); `check_membership.py` clean; `lv_save_version.py` all 26; links of the UDP VIs only into
   `src\protocol\` and `src\common\ZM-PC-packages\`; the behaviour probe (`proof\ZMP-05a\ZMP-05a-probe.xml` exists:
   reuse it) sender `init` → `publish` of one TP → `close` with no receiver: `error out` 0.
4. **Report** in brief 05a's format (max 70 lines), covering the whole of 05a: items 1-10, with the recovery of step 1
   as the first item of "Deviations" and the cut-offs of session 1 as side effects.

## Hard rules
As brief 05a, "Hard rules", unchanged. In particular: one lvai_*/pylv_* call at a time; never answer a LabVIEW
dialog; never probe a VI Server name with `lvai_validate_aixml`; no hand edits of LabVIEW files; commit by explicit
paths, Conventional Commits, no attribution trailer; never push; nothing outside the product folder except the
helpers folder and the tool's stub cache.
