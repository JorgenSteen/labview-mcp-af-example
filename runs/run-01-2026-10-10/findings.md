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
- **Decided (the user, 2026-10-11, after phase 13):** "13 is right". The 14 is a counting slip in `02` §10, `03` §3,
  `05` and the README; the structural row passes with 13. Logged in `CLAUDE.md` and as D42 in the product's
  `decisions.md`; the requirement texts stay as they are (fix them before the next run).

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
- **Decision (the user, 2026-10-11 ~20:10):** "Keep as is". Recorded as a known limitation (fits D40).

## F9 (2026-10-11): the one-call rule broken in four of six steps after the switch to Opus 5.5 (agent behaviour)

- **What:** 05a2 sent two `lvai_check_aixml` calls in one message, 05b two `pylv_extract` calls, 05d two
  `lvai_set_vi_icon` calls, 07 three read-only icon reads (05c and 06 kept the rule), although each brief and launch message stated the rule, the last two in bold. None of the
  15 Fable 5.1 agents of session 1 reported a break. All three breaks were harmless (offline calls or fast calls).
- **Evidence:** report-05a2 item 9b, report-05b item 8a, report-05d item 6a, report-07 item 8b.
- **Update (session 3, 2026-10-11):** 08a and 08c kept the rule; 08b sent two read-only exports in one message
  (report-08b item 8a). Count now five of nine Opus 5.5 steps.
- **Update (session 3, end of phase 11):** 08c, 09a-09d, 10a, 10c-10e and 11a kept it; 10b (two exports) and 11b (two
  icon calls) did not. Count over the Opus 5.5 steps: seven of 21.
- **Why it matters:** the skill (`session/brief.md`) records the same break in four pilot sessions; a parallel call on
  a slow LabVIEW operation can block the service. It is also data for the model comparison the plan asks for.
- **Owner:** the skill's maintainer (MCP-candidate `call-lock`), the user (model choice).

## F10 (2026-10-11): `kit/lvproj_drop.py` empties a `.lvproj` with LF line endings (skill kit bug)

- **What:** the script splits the file on `\r\n` only (`lvproj_drop.py` line 6). `lvai_create_class` writes the
  `.lvproj` with LF before LabVIEW's next close turns it back to CRLF; one call that reported "removed 1 line" wrote a
  0-byte `Zuehlke MCP.lvproj`. The 09a agent restored it from git (project closed), recreated the memberless class,
  and dropped the stray item with a derived copy that keeps the file's line ending and refuses to write an emptied
  file (`proof/ZMP-09a/lvproj_drop_eol.py`). `lvproj_move.py`, `lvproj_add_toplevel.py` and `remove_members.py` split on
  the file's own line ending (checked by the manager). Nothing was lost; the commit after it shows a one-line diff.
- **Evidence:** report-09a item 7a; `git diff 6c9fdf2 e0337ea` on the `.lvproj` (one added line).
- **Owner:** the skill's maintainer (fix the split; a size guard). Later briefs carry the trap.

## F11 (2026-10-11): a producer-loop error cannot end the HWM's event loop as `02` §7.11 is written (spec gap)

- **What:** built literally, a producer error (e.g. 5000 from a bare `ZM-HW-do`) ends only the producer loop; the
  event loop waits for the `stop` user event, which Actor Core sends only after Call Parent returns, which needs a
  stop the loop VI sends only "after both loops". The HWM would run on with a dead producer until shutdown, and `03`
  R-error ("the HWM stopped with a clean Last Ack, the root kept running" before Normal Stop) could not pass.
- **Evidence:** report-09c-hwm-helper-loop-clarification.md, question 1; `03-acceptance.md` R-error.
- **Decision (the user, 2026-10-11):** every loop stops the others when it ends; every `evaluateError` is a
  pass-through for now (D40; `CLAUDE.md`, "Errors are not handled yet"). Consequence: D14's plan (log, error
  package, clean Last Ack) is suspended; the CM's (08b) and HWM's (09b) built `evaluateError` are rebuilt as
  pass-throughs in 09c; `03` R-error's expected readings (error_lines 1, ui_errors, root keeps running) no longer
  hold and phase 12 judges R-error against D40.
- **Owner:** the user (restore the error plan later); the requirements' author (`02` §5/§7.11, `03` R-error).

## F12 (2026-10-11): `kit/pa_close_join.xml` fails on hooks with `error in (no error)` (skill kit bug)

- **What:** the helper hard-codes the hook's error input as `error in`; this project's hooks (made by
  `lvai_add_class_method`) name it `error in (no error)`. And when there is nothing to delete, its Delete step answers
  1055 and every later step is skipped, leaving unsaved partial edits in memory (discarded by the project close). The
  09d agent used a derived copy (`proof/ZMP-09d/zmp09d_close_join.xml`) with the right constant and Remove Bad Wires fed
  from before the Delete; Actor Core then exported as specified.
- **Evidence:** report-09d item 2.
- **Owner:** the skill's maintainer (read the hook's terminal name instead of a constant; do not chain the cleanup on
  the Delete's error). The phase 10 brief carries the derived helper.

## F13 (2026-10-11): T4 `ZM-TST-protocol` failed once on `init_ok` and passed on the rerun (flaky test or code)

- **What:** in the 10e closing rerun of T1-T7, T4 read Pass F with `init_ok` F (every other check T, error 0); the
  next cold run passed. `init_ok` = FL `init` with no error AND a second `Create Folder` on the same folder answers
  10; the test does not expose the code it read. Nothing in FL or T4 changed since 05c (T4 passed in 05c, 06, 09).
- **Evidence:** report-10e item 4 and 6a; reports/evidence-10e-checks.txt; output folders `test_fl_125501706` (fail),
  `test_fl_125517645` (pass).
- **Owner:** phase 12 (run T4 at least three times, read the folder state of a failing run); the user if it recurs.
- **Probable cause (2026-10-12, manager, from the build source `proof\ZMP-05c\ZM-TST-protocol.xml`, built in a1e87f0;
  later commits only cleanup and icons):** the test's second `Create Folder` (uid 5124) takes only the path; its
  `error in` is unwired and nothing orders it after `ZM-CP-init` (uid 5121). When it runs first it creates the folder
  (code 0), the FL `createFolder` hook then finds the folder and does nothing (no error), so `init_ok` = T AND (0 = 10)
  = F while every other check passes. That matches every flake (10e, 12h2, 12g, 12i: `init_ok` alone F, error 0, the
  failed run's folder holds all 3 JSONL files). A test-side race, not a product defect; not measured (the test does not
  show the code). Smallest fix: wire `init`'s `error out` into that `Create Folder`'s `error in` (the user decides).

## F14 (2026-10-11): the ROOT tree hangs when a nested launch fails (design defect, phases 09/10)

- **What:** `03` R-pli-failure, run as a CM Pre Launch Init failure under the ROOT (invalid `outputFolder`): the
  launch error goes into the ROOT's Call Parent, Call Parent returns at once, `ZM-ROOT-stop` generates the stop user
  event - and `helperPanel` never receives it, so it never exits, `close` never runs, Actor Core never returns, no Last
  Ack reaches the caller. Normal Stop answers 0 (the queue still exists) and the panel's Stop button has no effect
  (it sends Normal Stop to a message loop that has already ended). The tree stays in memory until LabVIEW restarts.
- **Probable cause (not proven):** the stop is generated before `helperPanel` has registered (it opens its panel
  first). User events are not latched: a stop generated before Register For Events is lost. The skill lists exactly
  this as unmeasured (`knowledge/actor-framework.md`, "Not yet measured": "A stop that comes before the loop has
  registered ... is lost"). The HWM has the same shape (not seen there).
- **Evidence:** report-12a item 2.8 and 4; reports/evidence-12a-checks.txt.
- **Owner:** the user (the fix is a design choice); then phases 09/10 (rebuild) and the skill's maintainer (the race).
- **Decision (the user, 2026-10-11 ~20:40):** D41, an `init` method per actor in Actor Core before Call Parent that
  registers (and, for the ROOT, launches); the loop VI receives the registration refnum (`CLAUDE.md`).
