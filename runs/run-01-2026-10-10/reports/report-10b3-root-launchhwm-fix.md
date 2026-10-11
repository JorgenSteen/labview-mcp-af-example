# Report 10b: launchHwm fixed, phase step done

**DONE.** Removing the bad wires fixed `ZM-ROOT-launchHwm.vi` on its own; Clean Up Diagram was not needed and was not run.

1. **The fix.**
   - I opened the project with `lvai_open_file`, which made it active.
   - Then I ran the kit's cached `pa_clean_member.vi` (`Remove Bad Wires`, then a save of the VI and its class), with vi path = launchHwm and class path = `ZM-ROOT-root.lvclass`.
   - It answered `state before` 0, then `state after` 1. Every error read 0: open, remove bad wires, save VI, save class.
   - I saved again with `pa_save_member` in a separate call (all 0), then closed the project. The close swept nothing.
   - I used the kit helper rather than deriving one from `zmp09d_close_join.xml`, because it does the same Remove Bad Wires step and is already measured.
   - No rebuild. The file was the committed d1794f8 version.
2. **State and checks** (project closed)
   - Cold `lvai_exec_state` of launchHwm: **1** (eIdle).
   - Cold sweep of the ROOT folder plus the CM's `Handle Error.vi`: **25/25 at state 1**, control `0 7`, ok count 25.
   - `check_membership`: 24 checked, 0 not a member, exit 0.
   - Save versions: launchHwm.vi 26:3, `.lvclass` 26008000, `.lvproj` 26.0 with SaveVersion 26.0.
   - The `.lvclass` kept its BOM. The class save only re-flattened `FlattenedPrivateDataCTL` (one line).
3. **Commit:** fe95794 `fix(root): remove the leftover broken wire in launchHwm`. Explicit paths: launchHwm.vi and ZM-ROOT-root.lvclass; no trailer; not pushed.
   - `git status --short`: only `?? runs/.../notes-for-run-02.md`.
4. **New deviation / rule line:** a VI at state 0 with a broken-wire text after generate, swap or bind: remove the broken wires first (`pa_clean_member`, the Ctrl+B equivalent), before any rebuild.
   - Here the cause was a leftover broken wire segment, `output cluster @ NamedBundler | settings @ SubVI`, beside the good wire. My earlier rebuilds were unnecessary.
5. **LabVIEW:** PID 26148, port 52603, project closed, no dialog. This segment made 7 LabVIEW calls, each alone in its message.
6. **Unchanged from my last report:**
   - The earlier breach: two exports sent in one message.
   - The items for the user in the IDE (D38).
   - The descriptions written into the overrides are my texts and need the user's review.
   - The side effects.
