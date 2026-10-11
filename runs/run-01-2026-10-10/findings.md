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

## F3 (2026-10-10): library count: `02` §10 and the README say 14, the spec's own tables list 13 (requirement inconsistency)

- **What:** `02-specification.md` §1 and §9 name 13 libraries: `ZM-PC-packages`, `ZM-CU-common_utilities`,
  `ZM-CI-common_interfaces`, `ZM-HW-hardware`, `ZM-HW-SIM-simulated_hardware`, `ZM-CP-communication_protocol`,
  `ZM-CP-FL-file_logger`, `ZM-CP-UDP-udp_transport`, `ZM-CP-MX-multi_protocol`, `ZM-HWM-hardware_manager`,
  `ZM-CM-communication_manager`, `ZM-ROOT-root` (12 shipped) and `ZM-TST-tests`. `02` §10 says "14 (13 shipped +
  `ZM-TST-tests`)"; `05-skill-alignment.md` "Counts" and the root README say 14.
- **Evidence:** report-00a-conventions.md, item 6 (c); the tables in `02` §1 and §9.
- **Effect:** none on the build (the tables win; names come from the tables). The count in `02` §10 is what phase 12's
  structural check "Project tree: 14 libraries" would compare against: the manager will count 13 unless the user says
  a library is missing from the tables. Not patched (the harness is read-only).
- **Owner:** the user (confirm 13, or name the 14th library).

## F4 (2026-10-10): no tool for class descriptions, `.ctl` class membership, or `Methods`/`TypeDefs` folders (tool gap, decided)

- **What:** labview-mcp 1.9.5 and the skill's kit have no route to set `NI.Lib.Description` on a class, to add a
  `.ctl` to a class (`layout.typedef-placement`), or to place a member in a `Methods`, `Helpers` or `TypeDefs`
  virtual folder (`layout.class-folders`). Only `Accessors` is created, by `lvai_create_accessors`
  (`virtualFolderName`). The 01a agent returned NEEDS CLARIFICATION (report-01a-pc-classes.md, items 3 and 8).
- **Decision:** User decision (2026-10-10 16:00): "option 1 then and log that answer into the documentation to so if someone wants to try to rerun this later, then do not need this clearification" The user does these in the IDE; agents list them; recorded in
  `CLAUDE.md`, `orchestration/plan.md` (commit fcac3e0), `status.md` ("For the user in the IDE") and the product's
  `decisions.md` (D38).
- **Owner:** labview-mcp (tool gap; skill MCP-candidates `add-to-class`, `library-virtual-folder`, and a class
  description setter).

## F5 (2026-10-10): the skill's icon generator does not implement its own icon convention yet (skill gap, decided)

- **What:** `<skill>/kit/make_icons.py` draws a white 3x5 banner and a 10x10 library glyph at the left, while
  `conventions/defaults/icons.md` asks for black Small Fonts banner text and one class glyph at the right
  (`icons.banner`, `icons.class-glyph`); `lib_glyph: null` is refused (stand-in: a transparent glyph);
  `libraries`/`messages` keys are ignored. The skill names this itself (`ops/icons.md`, "Kit TODO", KT-4).
- **Evidence:** report-01d-pc-cleanup-icons-preview.md, item 4; `reports/icon-preview-01d.png`.
- **Decision:** User decision (2026-10-10 17:10): "Approve as is, option 1, continue, but note this down so any clean start also does the same, without this prompt" Recorded in `CLAUDE.md`, `orchestration/plan.md`, `status.md` (deviations)
  and the product's `decisions.md` (D39).
- **Owner:** the skill (kit TODO KT-4).

## F6 (2026-10-10): phase card 03 says the SIM child's init/close call the parent; 02 §3.1 says the SIM does not override them (requirement inconsistency)

- **What:** `orchestration/phases/03-hardware.md`, Notes: "The child's init/close call the parent, because the parent
  does real work there (D16)." `02-specification.md` §3.1: `ZM-HW-init`, `ZM-HW-close` "real: write initialized;
  SIM does not override"; §7.5 lists only `ZM-HW-do.vi` and `ZM-HW-SIM-randomData.vi` for the SIM.
- **Decision:** `02` wins (CLAUDE.md, "Where 01 and 02 disagree, 02 wins"; the card is derived). The SIM gets no
  `init`/`close` override. Briefs 03a and 03b say so. The card is not patched (harness read-only).
- **Owner:** the user (fix the card note for the next run).

## F7 (2026-10-11): usage limits interrupted agents four times; the run spans sessions (harness / environment)

- **What:** three agents were cut off by the user's session limit mid-step (01b ~16:15, 03b ~18:45, 05a ~23:20,
  HTTP 429 "You've hit your session limit") and resumed with `SendMessage` after the reset; 05a was then stopped by the
  model limit ("You've reached your Fable limit. /model to switch models.", request id req_011CfuVsU5PuC3Yi5VPG8Prs).
  The user switched to Opus 5.5 and asked for a hand-over.
- **Effect:** no work was lost: every agent committed before each structural step, and the resumes started from git.
  But the last cut-off left the project OPEN in LabVIEW with unsaved edits (LVAutoSave 2), which the next session
  must recover (brief 05a2, step 1). An agent cut off with the project open cannot close it.
- **Lesson for the harness:** a step should close the project before any long run of tool calls, and briefs should
  keep the "commit, then close" rhythm short, so a cut-off finds the project closed more often. Proposed for
  `orchestration/plan.md` in phase 13 (the harness is read-only during the run).
- **Owner:** the user (harness), the skill's maintainer (`session/brief.md`, "Resume after a cut-off").

## F8 (2026-10-11): MX hooks drop the updated elements on an element error (spec ambiguity)

- **What:** `ZM-CP-MX-initAll`/`closeAll` and the MX `publish` loop over the elements with a shift register and
  `Replace Array Subset`, then `Write protocols`. The generated accessor skips on an incoming error, so after an
  element error the MX keeps its OLD array: never shortened (as `02` §7.9 asks), but the elements already processed
  are not stored (report-05b, item 8c).
- **Effect:** for `init`, an element opened before the failing one (a UDP socket) is not reachable from the stored MX,
  so a later `close` cannot release it. In the root's launch, `createResources` of the CM releases on a failed init;
  the leaked socket would close with LabVIEW. Normal runs are unaffected.
- **Options:** write the array on a fresh error chain and merge the errors after it (a small regeneration of three
  VIs), or keep as is. `02` does not say which. Owner: the user (decide before phase 12); the manager raises it in the
  phase 12 brief if not answered.

## F9 (2026-10-11): the one-call rule broken in four of six steps after the switch to Opus 5.5 (agent behaviour)

- **What:** 05a2 sent two `lvai_check_aixml` calls in one message, 05b two `pylv_extract` calls, 05d two
  `lvai_set_vi_icon` calls, 07 three read-only icon reads (05c and 06 kept the rule), although each brief and launch message stated the rule, the last two in bold. None of the
  15 Fable 5.1 agents of session 1 reported a break. All three breaks were harmless (offline calls or fast calls).
- **Evidence:** report-05a2 item 9b, report-05b item 8a, report-05d item 6a, report-07 item 8b.
- **Why it matters:** the skill (`session/brief.md`) records the same break in four pilot sessions; a parallel call on
  a slow LabVIEW operation can block the service. It is also data for the model comparison the plan asks for.
- **Owner:** the skill's maintainer (MCP-candidate `call-lock`), the user (model choice).
