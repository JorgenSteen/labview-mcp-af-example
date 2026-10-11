## Report 12h2: D38 items on CM, HWM, ROOT and the two CI classes

All five classes now have their description and folders, and no member is left at a class root. **The TypeDefs step was not done for any class.** Its first call was refused by the Claude Code permission classifier, so the 5 `.ctl` files are still not class members.

1. **LabVIEW state:** `lvai_status` answered at the start (00:10) and at the end (00:15): port 56779, PID 26716, 0 DWarn. There was no kill, start or restart. At the end the project is closed, no dialog is open, LVAutoSave is 0, and the only unsaved VIs are the 2 `LVMCP Validate` scratch VIs.
2. **Per class:** the description was written and read back in each class. Member names matched the brief's table and the `.lvclass` XML.
   - **ZM-CM:** AF Overrides holds Pre Launch Init, Stop Core and Handle Error. Methods holds ZM-CI-handlePackage, createResources, releaseProtocol and evaluateError. `writePrelaunchSettings` went into Accessors (your correction). TypeDefs not done.
   - **ZM-HWM:** AF Overrides holds Pre Launch Init, Actor Core and Handle Error. Helpers holds helperAcquisition. Methods holds ZM-CI-handlePackage, init, createEvents, stop, close, createResources and evaluateError. `writePrelaunchSettings` went into Accessors. TypeDefs not done.
   - **ZM-ROOT:** AF Overrides holds Actor Core, Pre Launch Init and Handle Error. Helpers holds helperPanel. Methods holds ZM-CI-handlePackage, init, close, createEvents, createResources, evaluateError, launchCm, launchHwm, notePackageType, showError and stop. `writePrelaunchSettings` went into Accessors. TypeDefs not done.
   - **ROOT description deviation:** LabVIEW stores the description as an ANSI string and wrote each "→" as a literal "?". I wrote the description again with ASCII "->" in place of "→" and it now reads back as sent. To use other wording, it is one run of the description helper.
   - **ZM-CI-package_handler (interface):** Methods holds ZM-CI-handlePackage. The interface accepted the folder and the description with no error.
   - **ZM-CI-handlePackage Msg:** Methods holds Do and Send ZM-CI-handlePackage.
   - **Your Accessors correction:** I added it as a changed copy of the move helper, `proof\ZMP-12h2\zmp12h2_move_members_to_existing_folder.xml`. It finds the existing folder (Get All Descendents, Type Folder) and moves the item into it, with no AddItem. No `writePrelaunchSettings` was ever placed in Methods, so nothing had to be moved back.
3. **Typedef adds: not run.**
   - **What was refused:** `lvai_run_vi_and_read_values` on `zmp12f_add_files_to_class_folder.vi` (CM, folder TypeDefs, `ZM-CM-PRELAUNCH_SETTINGS.ctl`). The classifier's reason was "Modify Shared Resources". The call never reached LabVIEW and I did not retry it.
   - **Callers found by grep, outside each class:**
     - CM-PRELAUNCH_SETTINGS: ROOT `launchCm`.
     - HWM-PRELAUNCH_SETTINGS: ROOT `launchHwm`.
     - ROOT-PRELAUNCH_SETTINGS: `ZM-launcher.vi` and `ZM-launcher_test.vi`.
     - ROOT-EVENTS and HWM-EVENTS: callers only inside their own class.
   - Because no add ran, no callers were opened and no relinked files were saved. In memory after all the moves: 247 items, none modified.
   - **To finish:** a permission rule allowing `mcp__plugin_labview-mcp_labview__lvai_run_vi_and_read_values`, then a follow-up run of the 5 adds by the 12f/12h1 route. Or the user adds the 5 `.ctl` files in the IDE (D38).
4. **Checks** (project closed):
   - Cold sweep of `src`: 137/137 state 1, negative control 0 7, 24 s.
   - `check_membership`: 134 checked, 0 not a member, 3 plain (the launchers and the receiver), exit 0.
   - T1, T2, T3, T5, T6 and T7 PASS with error 0 and every sub-check T.
   - T4 failed its first run on `init_ok` with every other check T and error 0. That is the known flaky F13; the rerun passed. Report it as flaky.
   - `lv_save_version.py` reads 26 on all 5 changed `.lvclass` files.
   - Evidence is in `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\runs\12h2-checks.txt`.
5. **Commits** (explicit paths, no trailer, not pushed):
   - `ce968be` refactor(cm)
   - `df162a7` refactor(hwm)
   - `edff0ff` refactor(root)
   - `1ffc0b7` refactor(ci): both CI classes in one commit.

   `git status` lists only your run files (brief-12h2 and status.md modified; brief-12i, lessons-mcp-skill.md and notes-for-run-02.md untracked).
6. **Side effects and new traps:**
   - The project close swept nothing. The `.lvproj` changed only in line endings this time (the BOM was kept), and I restored it from git with the project closed.
   - One new helper VI is in `%TEMP%\LabVIEWMCP\helpers\`.
   - Git warns that CRLF will become LF in the `.lvclass` files, as in 12f and 12h1.
   - **New trap:** a class description is stored as ANSI, so a character outside CP1252 (such as "→") is saved as "?" with no error. Check the read-back for "?".
   - **New trap:** in this session the auto-mode classifier allowed the description and move helpers but refused the typedef-add helper. The refused add would have relinked and saved callers in other libraries, which may be why.

NEEDS CLARIFICATION: the typedef adds (5 `.ctl` into TypeDefs of CM, HWM and ROOT) were blocked by the permission classifier. Should the user allow `lvai_run_vi_and_read_values` for a follow-up, or leave these 5 for the IDE under D38? Also confirm "->" in place of "→" in the ROOT description.
