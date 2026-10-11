REPORT 12d: the F14 fix on the ROOT under D41 is **DONE**. `ZM-ROOT-init.vi` now does the launches and the registration before Call Parent. The panel loop takes the registration refnum as an input. R-pli-failure, which failed in 12a, now **PASSES**: the root tree stops by itself, the caller gets the Last Ack with the CM's error, and nothing hangs. All the other reruns pass too. Time: 2026-10-11, 21:15 to 21:30. About 60 LabVIEW calls. No NEEDS CLARIFICATION. No CANNOT PROCEED.
**One rule broken:** I sent two `lvai_exec_state` calls (init and Actor Core) in one message. Both were read-only and both read 1. Every other call went out alone.

**1. Kills and starts; `lvai_status`**
- **Kills and starts:** none. The standing kill go-ahead was not needed.
- **Start:** PID 26716, port 56779, up 1946 s, dwarn 0. Project closed, 0 dialogs, LVAutoSave 0.
- **End:** same PID and port, up 2873 s, dwarn 0, not degraded. Project closed, 0 dialogs. The 2 hidden `LVMCP Validate*` windows belong to the tool.

**2. `ZM-ROOT-init.vi`** (new member, private, static)
- **Pane (4815):** `ZM-ROOT-root in` 11, `error in` 8, `ZM-ROOT-root out` 3, `error out` 0, `event registration refnum` 2 (an output, `ref{EventReg}`).
- **Body** (export `proof\ZMP-12d\export-ZM-ROOT-init.xml`):
  - launchCm → launchHwm, with the class and error wires in series.
  - → Read events (class from launchHwm, on a fresh error chain) → Unbundle `stop`, `error` → Register For Events (stop first, error second, on a fresh "no error").
  - The refnum goes out. `ZM-ROOT-root out` comes from Read events.
  - `error out` = Merge(launch chain, Read events, Register).
- **Route:**
  - `lvai_add_class_method` (AIXML + VI) with three distinct sockets, then one swap onto launchCm, launchHwm and Read events.
  - `zmp12c_reg_indicator` (conIdx 2), then `pa_save_member`, then `set_scope.py` private.
- **State:** 1 cold. D41 description written.

**3. The loop VI (`ZM-ROOT-helperPanel.vi`)**, edited in place by 12c's route
- **Throwaway first:** I measured on `ZMP-12d-panel_throwaway.vi`, a copy of the 10e probe.
  - `zmp12c_reg_to_control2` with term index 10: every error 0, `far end` OuterTerminal, other consumers 0.
  - It left the known loose Read events→Unbundle wire, so the VI read state 0. `pa_clean_member` brought it to 1.
- **Member:** identical readings. `pa_clean_member` took it from state 0 to 1.
- **The `vi_nets` diff shows only:** Register, the Unbundle, the fresh constant and their wires removed; a new control (conIdx 10) wired to the loop tunnel.
  - Unregister stays, and its `error in` is now unwired.
  - Read events stays, because its error seeds the shift register.
- **Read-backs:**
  - Event specs unchanged: `0:error:2`, `2:stop:1`, static row `1:3`.
  - Use-default flag 0x300801.
  - Both inner dynamic wires unchanged.
  - Panel on call 1/1. `Stop` mechanical action 1, visible T.

**4. Actor Core** (export `proof\ZMP-12d\export-Actor Core.xml`)
```
override ROOT:Actor Core existing | hooks: launchCm swapped onto init (lvai_swap_subvis, wiringLost []); launchHwm removed by derived
zmp12d_remove_series_block (class block: kept 1 FlatSequenceOuterTunnel, sink CallParentNode; error block: sink CallParentNode; node deleted; all 0)
init refnum -> helperPanel refnum by zmp12c_wire_nodes (hits 1/1, 2 ends, not broken) + pa_save_member | stop D / close D-close unchanged
```
- **The export shows:**
  - init(`<C> in`, `error in`) → Call Parent (`Actor in` = init's out, `error in` = init's error).
  - helperPanel takes `<C> in`, init's refnum, and an unwired `error in`.
  - The stop frame's class tunnel now comes from init's out (before it came from launchCm's out).
  - Merge(loop, stop) → close. Merge(Call Parent, close) → `error out`.
- **New derived helper:** I measured `zmp12d_remove_series_block` on `ZMP-12d-remove_throwaway.vi` first. Its nets were exactly as expected.
- **State:** 1 cold.

**5. Reruns** (project closed; evidence `proof\runs\12d-checks.txt`)
- **R-pli-failure: PASS.**
  - Launch 0. The Last Ack arrived at **70 ms** carrying **error code 1** ("Create Folder" in ZM-CP-FL-createFolder ← MX initAll ← ZM-CM-createResources ← CM Pre Launch Init, `output\test_bad<>|_…`).
  - The Normal Stop 1 s later answered 1556 (the root's queue was gone). 1080 ms in total.
  - No panel left. helperPanel reads cold 1. Error log unchanged.
- **Early stop ×5: PASS, no hang in 5 of 5.**
  - Route: a copy of the 10d launch proof with `run ms` set to 0, so the Normal Stop goes out right after launch.
  - Every run: launch 0, stop 0, the second stop 1556, 3010–3012 ms. helperPanel reads 1 after each run; HWM helperAcquisition reads 1 after run 5.
- **R-normal ×1: PASS.** 10 lines, 0 error lines, `ui_errors` "", error 0, 6492 ms.
- **R-error: pass under D40.** 0 lines, `error out` 1556 (the launcher's stop to a root already gone), 6491 ms, no hang. Same as 12a.
- **R-interactive: PASS.**
  - The launcher returned in 505 ms with error 0. Both panels were visible.
  - Lines grew 10 → 22 in 6 s.
  - Pressing Stop by a signalling write: state 3, matched 1, error 0. Lines stayed at 28 and 28 three seconds later. Both panels closed.
- **T7: PASS** (4/4 checks, 449 ms).
- **10d launch proof: PASS.** 10 lines, stops 0 and 1556, 8012 ms.

**6. Cleanup, icons, sweep, versions, links**
- **Cleanup:** the copy probe read the same before and after (specs, use-default, dyn wires), state 1. Then init, helperPanel and Actor Core all gave code 0. The member probe was unchanged afterwards.
- **Icons:** init got its own layer, then the class template (open and save codes 0). Read-back 3/3 at 0 px against `make_icons`; helperPanel and Actor Core kept their icons.
- **Sweep:** `src\actors` + `src\tests` read 64/64 state 1, control `0 7`. Membership: ROOT 27/0, tests 7/0.
- **Versions:** 40 of 40 files at 26.
- **Links:** among the actors, only ROOT launchCm/launchHwm reference CM/HWM/SIM/FL/UDP/MX; the tests and the receiver use them too, by design. No `LVMCP Stub` link is left in `src`.

**7. Commits** (explicit paths, no trailer, not pushed)
- 9cb0c60, b847365, 07171c6, d991c13 (fix); 57b27ee (docs); 6b5332d, 1cad6ec (style).
- `git status --short`: only the two untracked `runs\…\*.md` files, which are not mine. The `.lvproj` is unchanged (sha1 d472b3a7).

**8. Deviations and IDE items**
- **(a)** The rule break above (two calls in one message).
- **(b)** launchHwm was removed by a new derived helper, `zmp12d_remove_series_block`; the kit was not edited. It was measured on a throwaway first. No `git checkout` was used.
- **(c)** init's `error out` also merges Read events' error (3 inputs), the same as the HWM.
- **(d)** I updated the Actor Core and helperPanel descriptions (`pa_replace_description`). The texts are mine; please review.
- **(e)** I used the 10d launch proof with `run ms` set to 0 as the early-stop route; no Last Ack queue was needed. "No hang" rests on the second stop reading 1556 and on helperPanel reading 1 cold.
- **For the user in the IDE (D38):** put `ZM-ROOT-init.vi` into `Methods`.

**9. Side effects**
- **Project:** opened and closed twice. No item was adopted. The `.lvproj` is byte-unchanged.
- **`.lvclass`:** LabVIEW rewrote the helperPanel Flags/State lines and FlattenedPrivateDataCTL (committed).
- **Output (git-ignored):** 7 new `output\test_root_1310…/1311…` folders and `output\TestPackage.jsonl` (28 lines). `ZM-launcher_test.vi` deletes `output\ZM-error_log.txt` at its start; T7 then wrote 2 lines.
- **New in `%TEMP%\LabVIEWMCP\helpers\`:** `zmp12d_remove_series_block.vi`. Its source, the throwaways, probes, exports, links and the icon read-back are in `proof\ZMP-12d\`. `proof\icons` was regenerated (165 icons). The stub cache did not grow (219 entries).
