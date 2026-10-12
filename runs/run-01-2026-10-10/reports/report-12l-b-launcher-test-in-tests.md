Report 12l-b: `ZM-launcher_test.vi` is now in the project's `tests` virtual folder, and the change is committed.

1. **Start:** at 13:52 the project was closed in the user's LabVIEW (PID 14692), LVAutoSave was 0, and there were 0 unsaved items and 0 dialogs. I started, restarted, closed and killed no LabVIEW.
2. **Move:** done with the kit's `lvproj_move.py` while the project was closed, after a dry run with `--check`.
   - The diff moves only that one line: out of the root, into `tests`, sorted ahead of `ZM-TST-tests.lvlib`.
   - The file stays at `src\ZM-launcher_test.vi`, it is not a member of `ZM-TST-tests.lvlib`, and `ZM-launcher.vi` stays at the root.
   - The F10 trap did not hit: the result is not empty (46 lines), the BOM is kept and the line endings stay LF.
3. **Open, check, close:**
   - The project opened and became active with no dialog. `lvai_describe_project` read it with no error, but its answer lists VIs flat, without folders, so the folder placement is proven from the `.lvproj` file instead.
   - `lvai_close_active_project` closed it and its sweep removed nothing. The save it does kept the item under `tests` but rewrote the whole file from LF to CRLF, an EOL-only change.
   - I restored the file from git and ran the same move again on the closed project, so the final diff is one line again, with LF and the BOM.
4. **Executable:** `ZM-launcher_test.vi` reads `exec_state` 1 cold.
5. **README**, "Run it", Headless bullet: added "(in the project's `tests` folder)" and rewrapped the bullet to the file's line width. The file path is unchanged and nothing else was edited.
6. **decisions.md:** D45 is appended in the file's own format (Rule, Chosen, Instead of `02` §8/§9, Why with your words quoted, Supersedes). No older entry was changed.
7. **Commit:** `8711cdd refactor(project): ZM-launcher_test.vi in the tests virtual folder (D45)`, holding the three files only, by explicit paths, with no trailer. Not pushed.
8. **Left alone:** `git status` still shows `runs/run-01-2026-10-10/status.md` as modified, plus the two untracked runs notes. I did not touch them.
9. **End state:** project closed, LVAutoSave 0, 0 unsaved, 0 dialogs.

DONE
