REPORT 09d: HWM Actor Core, the two throwaway runs, stop reset, cleanup, icons and closing checks. DONE (2026-10-11, 13:46 to 14:12). No NEEDS CLARIFICATION. About 100 LabVIEW calls, each sent alone in its own message.

(Manager's note: the harness flagged the report for an "instruction-shaped pattern" and escaped its `<` characters; the only match was the path placeholder `output\test_hwm_<tick>`, restored here. Nothing else was changed.)

**1. Status**
- Start: `lvai_status` ok, port 59983, PID 14516, up 9732 s, dwarn 9.
- End: same port, up 11312 s, dwarn 22, not degraded. The newest dwarn is "Nonfatal insanity" in my derived helper `zmp09d_close_join.vi`.
- LabVIEW starts: 0. The project is closed. `lv_windows`: 0 dialogs; the 12 "unsaved" windows are the tool's hidden `LVMCP Validate*` windows.

**2. Actor Core**
```
override HWM:Actor Core created yes (7 errors 0)  protected  dynamic  member  folder asked (AF Overrides, D38)
hooks: helperAcquisition shape A (af_add_hook_call, errors 0) | ZM-HWM-stop shape D (pa_insert_seq_hook, frame 1, all 0, hook order = "error in (no error)")
       close shape D-close (derived zmp09d_close_join: call parent/loop/stop/indicator hits 1/1/1/1, merge class Bundler, all wires 0); each saved by pa_save_member (0)
unmeasured shapes used: none   sweep 29/29 (HWM 16 + CM 13), control 0 7, membership 16/0 and 13/0   export ok   commits c0cc90a c6711e0 83067aa 3d97e1c
```
- Export (`proof\ZMP-09d\export-Actor Core.xml`):
  - Call Parent and helperAcquisition both take the class input.
  - A Flat Sequence Frame holds ZM-HWM-stop. Its class comes in by a tunnel from the class input; Call Parent's error out goes in on an order tunnel with no inner consumer; stop's error in is unwired.
  - Merge Errors(loop error out, stop error out) feeds ZM-HWM-close (class from the class input). Merge Errors(Call Parent error out, close error out) goes to `error out`.
- **Kit defect in `pa_close_join` (2 issues).** The helper hard-codes the hook error input as "error in", but our hooks use "error in (no error)". Also, when nothing is to be removed, its Delete step answers 1055 and every later step is skipped.
  - The first run left unsaved partial edits in memory. The project close discarded them with no prompt; the VI on disk was unchanged.
  - I fixed it in a derived copy, `proof\ZMP-09d\zmp09d_close_join.xml`: the constant is now "error in (no error)", and Remove Bad Wires takes its error from before the Delete. The kit itself is not edited.

**3. Caller route: the lighter one, no throwaway class** (`ZMP-09d-run_hwm.vi`, `ZMP-09d-stop_reset.vi`, proof folder only)
- The proof VI launches a ZM-CM (an MX of one FL on `output\test_hwm_<tick>`) with AF's public `Launch Actor.vi`, using a proof-owned message queue as the CM's caller.
- It then launches the HWM with `Launch Actor.vi` and the CM's enqueuer as the HWM's caller. So the CM is the real caller: it publishes forwarded packages, and it receives the HWM's Last Ack.
- The proof queue receives the CM's own Last Ack, which gives the cascade code.
- Built with the project open; class seeds swapped, both settings seeds bound; cold state 1. The adopted `.lvproj` entries were removed by `git checkout` with the project closed.

**4. Runs** (evidence in `proof\runs\09d-checks.txt`)
- **Run 1 (SIM), three times; the third after cleanup and icons.** Every run gave the same result:
  - 6 / 6 / 6 TestPackage lines.
  - Launch codes 0.
  - Dequeue timed out at 3046 / 3039 / 3035 ms (nothing stopped by itself).
  - Normal Stop to the HWM 0, then to the CM 0. The CM's Last Ack error was 0. Total 4046 / 4040 / 4036 ms.
  - Error log byte-identical. No helper or Actor Core panel left open.
- **Run 2 (bare ZM-HW-hardware), twice:**
  - The CM's Last Ack arrived by itself 559 / 642 ms after launch, with error **5000 "ZM-HW-do.vi: must be overridden by a child class"**.
  - The proof's Normal Stop to the HWM and to the CM both gave 1556 (both queues already gone): the whole tree stopped before the proof's stop.
  - 0 lines: the folder was created but holds no TestPackage and no ErrorPackage file.
  - Error log unchanged. The run returned in 6.6 s. This matches D40.

**5. Helper-loop checks**
- **Stop reset: PASS.** One VI, with the CM as caller: HWM#1 ran 3 s, then Normal Stop; 1 s later HWM#2 started with the same settings, ran 3 s, then Normal Stop.
  - Lines: 6 after HWM#1, 12 in total. All codes 0.
  - helperAcquisition is non-reentrant (IsReentrant 0), so the same instance ran twice, and its `stop` was reset to F.
- **Close order: not measured with timestamped lines.** That would need log writes added in `src\`, so I stopped there as the brief says.
  - What it rests on instead: the Actor Core export shows `close` is fed only by Merge(loop error out, stop error out). Every run returned with the CM's Last Ack at 0 (run 1), and no panel and no hang remained.

**6. Cleanup and icons**
```
cleanup 17 VIs (HWM 16 + ZM-CM-evaluateError)  start HEAD d038199  batches 2 (5 + 12)  ~0.33 s per VI  codes 17/17 code 0
loop VI: first a copy of the 09c throwaway (proof\ZMP-09d\ZMP-09d-clean_probe.vi): spec rows, use-default 0x300801, 4 dyn wires same before/after, state 1 -> then the member
member after cleanup and after icons: same spec rows / use-default / dyn wires (probe_member_*.txt); panel on call 1/1, stop action 0, visible F
versions 26 before/after   sweep before/after 29/29 same, control 0 7   git: only .vi per batch   commits c44366d e26200f
icons 17 VIs  mode new (HWM) + template re-apply (CM evaluateError)  spec existing  preview approved (D39, not asked)
make_icons --check exit 0, generate exit 0 (133 icons); before read-back 18/18 (17 differed; CM Handle Error 0 px, intact)
own layers 17 (lvai_set_vi_icon, each 0 px)  templates: HWM class 1, library 1 (all 0)  apply HWM 16 + CM 1: open/save codes 0
read-back 18/18 at 0 px (pixcmp --tree exit 0)   owners 2/2 at 0 px   commits 9342d58 cf7e646
```

**7. Closing checks**
- Descriptions: 17/17 VIs have one. I replaced the Actor Core text (it was NI's help) and the HWM Handle Error text (it still described D14) with D40 texts: commit d038199. Both texts are mine; please review them.
- Links of all 16 HWM VIs: only the HWM folder, ZM-CI, ZM-PC, ZM-HW-hardware and vi.lib. ZM-HW-SIM, ZM-CM, ZM-ROOT, ZM-CP: **0**.
- `.lvproj`: the `actors` folder (lines 15-17) lists `ZM-HWM-hardware_manager.lvlib` once.
- Versions: 22/22 files are 26 (VIs, `.ctl`, `.lvclass`, `.lvlib`, CM evaluateError, `.lvproj` 26.0).
- Final cold sweep: HWM + CM 29/29 state 1, control `0 7`. Membership: HWM 16/0, CM 13/0.

**8. Commits** (explicit paths, no attribution trailer, not pushed)
- 7f4c4de: D40 cascade clause in `decisions.md`.
- c0cc90a, c6711e0, 83067aa, 3d97e1c: Actor Core.
- d038199: descriptions.
- c44366d, e26200f: cleanup.
- 9342d58, cf7e646: icons.
- eda6452 `feat(hwm): hardware manager actor with acquisition loop`: an **empty marker commit**, because all the work was already committed.
- `git status --short`: only `?? runs/.../notes-for-run-02.md`, which is not mine.

**9. Deviations and items for the user**
- (a) Caller route as in item 3, with no throwaway class.
- (b) The close order was not measured with timestamps (item 5).
- (c) The kit defect in `pa_close_join` and my derived fix (item 2).
- (d) The icon apply re-saved the CM `.lvclass` (BOM and FlattenedPrivateDataCTL only). The CM `.lvclass` was outside what the brief lets change, so I restored it from git with the project closed.
- (e) **CM `Handle Error.vi` still has its D14 description** ("logged ... cleared"). CM files other than evaluateError were out of scope, so I did not touch it.
- (f) For the user in the IDE (D38): put `Actor Core.vi` into `AF Overrides`. The 09b/09c items still stand (Helpers, Methods, TypeDefs, the class description).

**10. Side effects**
- New output folders `output\test_hwm_104469078`, `test_hwm_104489905`, `test_hwm_104497787`, `test_hwm_104514107`, `test_hwm_105101749` and `test_hwm_reset_104524601` (git-ignored).
- The project was opened and closed 3 times. Each close dropped the BOM or adopted the 2 proof VIs; I restored the `.lvproj` from git each time, with the project closed.
- New helper `%TEMP%\LabVIEWMCP\helpers\zmp09d_close_join.vi`. Read-back folders `%TEMP%\LabVIEWMCP\rb\09d*`.
- `proof\ZMP-09d\` (git-ignored) holds: the AIXML, the proof VIs, the probe copy, the exports, the scripts (descs, desc_inputs, probe_loop_vi, patch/fix helper) and the sweep lists. `proof\icons\` was regenerated.
