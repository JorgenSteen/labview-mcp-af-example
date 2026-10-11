REPORT 09c: HWM helper loop `ZM-HWM-helperAcquisition.vi`, built per D40 (2026-10-11). DONE. The member reads cold state 1, and a cold sweep of the class folder reads 15/15 state 1.

(The first segment's NEEDS CLARIFICATION is in `report-09c-hwm-helper-loop-clarification.md`.)

**1. Status**
- `lvai_status` at the start: port 59983, PID 14516, dwarn 4. At the end: same port, up 9561 s, dwarn 9 (the latest is "bad to good after compiling" on a throwaway), not degraded.
- LabVIEW starts made: 0. The project is closed. `lv_windows`: 0 dialogs; the 8 "unsaved" windows are the tool's `LVMCP Validate`.
- About 60 LabVIEW calls in both parts, each alone in its message.

**2. Helper-loop report block**
```
loop ZM-HWM-hardware_manager:ZM-HWM-helperAcquisition.vi variant 2  events stop  member private static  folder asked (Helpers, D38)
members: createEvents stop close (09b)  add_class_method 1 call (vi only)  swaps 3 calls + 1 constant helper  error case No Error/"Error .." both loops
build: generate ok (state 0 expected)  left: lvai_wire_dynamic_events cannot reach depth 3, derived helper wire 2 ends  right ends 2 broken F  specs 1:stop:1  data fields n/a
panel on call 1/1 (cold)  Stop action n/a (stop = Switch When Pressed, 0)  stop hidden yes  export ok  locals 5 (3 writes T/F, 1 interval write, 1 read)
hooks: not here (09d)   sweep 15/15, control 0 7, membership ok
run: not run (09d)   unmeasured steps met: (1)(2)(3)(4)(5), the Flat Sequence Frame, the deep constant swap
side effects: see 9   commits see 7   issues: lvai_swap_subvis constantsJson -> 1055 "To More Specific Class" (helper searches top-level constants only)
```

**3. The unmeasured points (throwaways in `proof\ZMP-09c\`)**
- (1) An Event Structure in the No Error frame of a case inside a loop survives `lvai_generate_vi_with_events`. The frames ` Timeout ` and ` <stop>\3A User Event ` are kept. AIXML `Flat Sequence Frame` also generates.
- (2) `lvai_wire_dynamic_events` (`finishUserEvents: false`) answered Error 91, helperDidNotAnswer, and left the file unchanged. Its search goes only two levels deep; this Event Structure is three levels down.
- (3) Derived helper `zmp09c_wire_dyn_deep.xml` (from the kit's `pa_wire_dyn_right` and the plugin's diagram fallback; the kit is not edited):
  - It searches three levels and wires both sides with Connect Wire: Register → dynamic terminal, right terminal → Unregister. Answer: all found, 2/2 ends, not broken, error 0.
  - LabVIEW's new case output tunnel has no value in the Error frame. The VI Server property "Use Default if Unwired" is in `lvserver.rsc` but the AIXML catalogue refuses it.
  - Fix: `zmp09c_set_use_default.py` sets objFlags 0x100801 → 0x300801 in the pylv bundle, the value NI's own `Read data.vi` carries (exported as `cond="true"`).
  - Throwaway: state 1 with the flag; negative control without it: state 0.
- (4) A second plain loop beside the event loop in the same document: generates, and runs on the member.
- (5) Plot names, with spellings from `lvserver.rsc`: chart `Active Plot` → `Plot` → `{LV.Plot} Plot Name`, via derived helper `zmp09c_set_plot_names.xml`. Answer: temperature_c / duty_percent, error 0. The saved file has both `plotName` entries (pylv offline).

**4. Export** (`proof\ZMP-09c\export-ZM-HWM-helperAcquisition.xml`; `vi_nets.py` shows both eventDynDCO wires)
- Register: fresh "no error", before the event loop. Unregister: after it, on the loop's refnum tunnel (case `Out3 cond="true"`), error in = Register's error out. Then Merge with the loop error.
- Case frames: No Error / "Error .." in both loops, plus a nested No Error/Error case for the TP cast.
- Locals:
  - writes: `stop` = F and `interval set (ms)` = intervalMs in one Flat Sequence before the loops; `stop` = T in the `<stop>` frame; `stop` = T after the event loop (D40).
  - read: `stop`, inside a Flat Sequence that is fed by the Wait output.
- Chart path: `ZM-HW-do` → package → To More Specific Class (class constant `ZM-PC-TP-test_package`) → Read data → Unbundle temperature_c, duty_percent → To DBL → Bundle By Name → `live` (graph21717). The cast error goes to Clear Errors on its own wire.
- Interval: `interval measured (ms)` = Wait timer minus a shift register, 0 when i = 0.
- D40 shape:
  - After the producer loop: ZM-HW-close on a fresh chain, merged; then a Flat Sequence with ZM-HWM-stop → Clear Errors.
  - After the event loop: a Flat Sequence with `stop` = T, then ZM-HWM-stop → Clear Errors.
  - After both: Merge → evaluateError (`stop actor?` unwired) → case: Error frame Read Self Enqueuer → Send Normal Stop (fresh chain) → Clear Errors. `error out` = the raw merged error.

**5. Read back cold**
- Show front panel on call 1, close after call 1, state 1.
- `stop`: mechanical action 0 (Switch When Pressed), Visible F.

**6. Sweep, membership, versions, links**
- Cold sweep of the HWM folder: 15/15 state 1, control `0 7`. CM + HWM after the evaluateError change: 27/27.
- `check_membership`: HWM 15/0, CM 13/0.
- Save versions: everything 26 (helperAcquisition 26:3, `.lvclass` 26008000, `.lvproj` 26.0).
- Links: HWM class, TP class, HW class, ZM-CI Msg, own members, vi.lib. Forbidden ZM-HW-SIM/ZM-CM/ZM-ROOT/ZM-CP: 0.
- Scope: MethodScope 2 / LibItem.Scope 2 (`set_scope.py`); static (Flags dispatch none).

**7. Commits and git status**
- Commits: 24736c3 (D40 in `decisions.md`), f8ec2b1, 6b20e23, f2bc93b, 5dd5f78, 26af98f, 6a19814.
- `git status --short`: only `?? notes-for-run-02.md`, which is not mine. Not pushed.

**8. Deviations and items for the user**
- (a) **evaluateError, what changed:** `ZM-HWM-evaluateError.vi` and `ZM-CM-evaluateError.vi` are now pass-throughs (class, error, `stop actor?` in → out; pane 4815; private; static; D40 description). Route:
  - Handle Error was swapped onto a stub.
  - The member was re-added (`add_class_method` re-run).
  - The stub was swapped back.
  - Both are state 1 cold. Their icon and cleanup were lost in the regeneration: redo them in 09d (HWM) and in the CM cleanup.
- (b) The event loop has an empty Timeout frame, which the spec step needs (R8.7 allows it).
- (c) `stop` = T is written twice: in the `<stop>` frame (spec) and after the loop (D40).
- (d) The diagram is wide: 26 stages against a budget of 10. Folding would need names that are not in `02`, so I did not fold.
- (e) Unregister gets a default refnum when the loop exits through the Error frame. Unregister returns an error then; it is merged after the real error.
- (f) The description text is mine; please review it.
- (g) For the user in the IDE (D38): put `ZM-HWM-helperAcquisition.vi` into `Helpers`, and `ZM-HWM-evaluateError.vi` / `ZM-CM-evaluateError.vi` into `Methods` (they are now at the class root).
- Not measured here (09d): runs, the stop reset over two calls, Actor Core hooks.

**9. Side effects**
- The project was opened and closed about 8 times. Each close dropped the `.lvproj` BOM; I restored it from git each time with the project closed. The close sweep removed 3 adopted helper entries.
- The HWM `.lvclass` FlattenedPrivateDataCTL and the CM/HWM ClassItem.State lines were rewritten by LabVIEW.
- New stubs in `user.lib\LV_MCP`: 494e8c7848 (unused), 17e772cb85, 8600a790d2, dbed506375, 91950b9cd6, 9475868c6c, and the hand-made `ZMP09c-readPrelaunchSettings` and `ZMP09c-hwClose`.
- New helpers in `%TEMP%\LabVIEWMCP\helpers\`: `zmp09c_wire_dyn_deep`, `zmp09c_set_plot_names`, `zmp09c_replace_constant_deep`. Their sources are in `proof\ZMP-09c\` (git-ignored), with the throwaways, bundles and exports.
