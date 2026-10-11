REPORT 12c: the F14 fix on the HWM under D41 is **DONE**. `ZM-HWM-init.vi` registers before Call Parent, and helperAcquisition takes the registration refnum as an input. All proofs pass, including 5 of 5 early stops with no hang. 2026-10-11, 20:42 to about 21:12. About 80 LabVIEW calls, each sent alone in its own message. No NEEDS CLARIFICATION. No CANNOT PROCEED.

**1. Kill, start and status**
- **Kill:** `lv_windows` beforehand showed one LabVIEW, PID 26148 (started 18:52:53).
  - Windows: the ROOT helperPanel visible, plus 14 hidden unsaved `LVMCP Validate*` windows. 0 dialogs. LVAutoSave 0.
  - `Stop-Process -Id 26148` at 20:42:32, under the user's standing go-ahead (2026-10-11): "feel free to kill labview at will for this session".
  - Afterwards: no LabVIEW process. NigelLocalService 19156 was left untouched.
- **Start:** `lvai_ensure_labview` started PID 26716 (breakaway, 22 s, LVAutoSave already empty). `lvai_status` ok: port 56779, 1.9.5-local, dwarn 0.
- **End:** same PID and port, up 1703 s, dwarn 0, not degraded. Project closed. 0 dialogs. 2 hidden `LVMCP Validate` windows left by the tool.

**2. `ZM-HWM-init.vi`** (new member, private, static)
- **Pane (4815):** `<C> in` 11, `error in` 8, `<C> out` 3, `error out` 0, `event registration refnum` 2 (output, type `ref{EventReg}` in the export).
- **Body:** Read events, on a fresh error chain → Unbundle `stop` → Register For Events on a fresh "no error" constant → refnum out. `error out` = Merge Errors(`error in`, Read events' error, Register's error).
- **State:** 1 cold. D41 description written. Commits 5f378cd and bf204ec.
- **Route:**
  - `lvai_add_class_method` (aixml + vi) with the existing Read events socket `LVMCP Stub 5a8dc87c83`, then a swap onto `Read events.vi`.
  - Derived helper `zmp12c_reg_indicator`: Create Indicator on Register's output, then AssignCtrlToTerm 2. Then `pa_save_member`, and `set_scope.py` private.
- **D41 in `decisions.md`:** commit 206b920.

**3. The loop VI** (`ZM-HWM-helperAcquisition.vi`), edited in place, no regeneration
- **Measured first on a throwaway** (a copy of the 09d probe), with derived helper `zmp12c_reg_to_control` (kit not edited):
  - Create Control on Register's *input* refnum gives a TypedRefNum with the registration's own type.
  - The helper deletes Register's wires and Register, keeps any other consumer of the Unbundle (it reconnects them), and wires control → the loop tunnel.
  - AssignCtrlToTerm puts the control on conIdx 10.
  - Results: state 1. Spec rows unchanged (`1:stop:1`). Use-default flag unchanged (0x300801). The inner dynamic-terminal wires are unchanged.
- **Member result:** the `event registration refnum` control (conIdx 10) → event-loop tunnel → case → the event structure's dynamic terminal.
  - The right side still goes to Unregister. Unregister's `error in` is now unwired (it used to be Register's error).
  - Register, its Unbundle and the fresh constant are gone. Read events stays, because its error feeds the event-loop shift register.
- **Read-backs:**
  - `vi_nets` diff before/after shows only those wires.
  - Spec rows, use-default flag and dynamic wires are the same.
  - Panel on call 1/1. `stop` action 0, Visible F. Both plot names present.
- Commit 86b8c7d.

**4. Actor Core**
- `override HWM:Actor Core` existing; `init` series B (class and error) before Call Parent; loop A beside it; stop D and close D-close unchanged.
- **Export** (`proof\ZMP-12c\export-Actor Core.xml`):
  - init(`<C> in`, `error in`) → Call Parent(`Actor in` = init's `<C> out`, `error in` = init's error).
  - The loop takes `<C> in` from the panel and the refnum from init.
  - The stop frame (class tunnel from `<C> in`) is unchanged.
  - Merge(loop, stop) → close. Merge(Call Parent, close) → `error out`.
- **Helpers:**
  - `zmp12c_insert_series_branch3`: errors 0. Kept branches 3 (frame tunnel, loop, close), far end = CallParentNode. Error block: 0 kept.
  - `zmp12c_wire_nodes`: 2 ends, not broken.
  - Then `pa_save_member`. State 1 cold. Commit 757874d.

**5. Proofs** (project closed; evidence in `proof\runs\12c-checks.txt`)
- **Run 1 (SIM):** 6 lines. Launch 0/0. Stops 0/0. CM Last Ack 0. 4001 ms.
- **Run 2 (bare HW):** the CM Last Ack arrived by itself at 641 ms with 5000 "ZM-HW-do.vi: must be overridden by a child class". Stops 1556/1556. 0 lines. 6642 ms.
- **Stop reset:** 6 + 6 = 12 lines. All codes 0. CM Last Ack 0.
- **Early stop ×5** (copy of the run VI with `run ms` = 0, so the Normal Stop goes to the HWM right after launch):
  - Stop sent 42 / 49 / 1 / 51 / 43 ms after launch.
  - Every stop code 0, every CM Last Ack 0, every run returned in 1001–1052 ms.
  - helperAcquisition read state 1 after each run.
  - **No hang in 5 of 5.**
- Error log unchanged. No helper or Actor Core panel left open.

**6. Cleanup, icons, sweep, versions, links**
- **Cleanup:** a copy probe first (probe identical before/after), then 3 member VIs, codes 0. Probe identical after; panel flags unchanged. Commit fd003d7.
- **Icons:**
  - init: own layer, then the class template applied. Commit 076479e.
  - Read-back 3/3 at 0 px against `make_icons` (helperAcquisition and Actor Core kept their icons).
- **Sweep:** before 17/17 state 1, after 17/17, control `0 7`. `check_membership`: 17 checked, 0 missing.
- **Versions:** 22 of 22 files at 26.
- **Links:** only HWM, ZM-CI, ZM-PC and ZM-HW-hardware. ZM-HW-SIM, ZM-CM, ZM-ROOT and ZM-CP: 0.

**7. Commits** (explicit paths, no trailer, not pushed)
- 206b920, 5f378cd, bf204ec, 86b8c7d, 757874d, 49ec6d0 (descriptions of Actor Core and the loop VI), fd003d7, 076479e.
- `git status --short`: only the two `runs/.../*.md` files, which are not mine. The `.lvproj` sha1 is d472b3a7, the same as at the start.

**8. Deviations**
- **(a) Actor Core was not restored to the bare override:** the harness's auto-mode classifier refused the `git checkout c0cc90a -- Actor Core.vi`. I did not work around that. Instead, a derived in-place series helper keeps the other wire branches.
  - Its first throwaway run dropped a flat-sequence tunnel, because a tunnel terminal carries its source's name. Fixed by matching the far end's owner class as well, then re-measured.
- **(b) Derived helpers had two races:**
  - Wire deletes ran before the lookups. This happened on the throwaway, the edit was never saved, and the project close discarded it; fixed.
  - The Unbundle was deleted before its input wire. On the member this gave state 0 with a loose wire; `pa_clean_member` brought it back to 1, and the diff shows nothing else changed.
- **(c)** init's `error out` also merges Read events' error (3-input Merge). The brief named only `error in` and Register.
- **(d) For the user in the IDE (D38):** put `ZM-HWM-init.vi` into `Methods`. The new description texts (init, Actor Core, loop VI) are mine; please review them.

**9. Side effects**
- **Kill and start:** killed PID 26148 (the hung ROOT tree); started PID 26716.
- **Project:** opened and closed about 10 times. The `.lvproj` adopted `ZMP-12c-wire_throwaway.vi` once; I dropped it with `proof\ZMP-09a\lvproj_drop_eol.py` (CRLF and BOM kept, sha restored).
- **`.lvclass`:** LabVIEW rewrote the State, Flags and FlattenedPrivateDataCTL lines for helperAcquisition and init (committed).
- **Output (git-ignored):** 7 `output\test_hwm_1299*` folders and `test_hwm_reset_129914081`.
- **New helpers in `%TEMP%\LabVIEWMCP\helpers\`:** `zmp12c_reg_to_control`(2), `zmp12c_reg_indicator`, `zmp12c_wire_nodes`, `zmp12c_insert_series_branch`(2,3). Their sources, the throwaways, probes, exports and links are in `proof\ZMP-12c\`. `proof\icons` was regenerated (164 icons). Read-backs are in `%TEMP%\LabVIEWMCP\rb\12c*`.
