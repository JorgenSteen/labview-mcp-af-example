REPORT 10e: ROOT cleanup, icons, sweep and the phase-10 closing checks. **DONE** (2026-10-11, 19:42 to 19:53). No NEEDS CLARIFICATION, no CANNOT PROCEED. I made 56 LabVIEW calls, each one alone in its own message.

**1. Status**
- **Start:** `lvai_status` ok. PID 26148, port 52603, 1.9.5-local, up 2949 s, dwarn 4. `lv_windows`: 0 dialogs, LVAutoSave 0, project closed.
- **End:** same PID and port, up 3599 s, dwarn 5, not degraded. The new DWarn is "bad to good after compiling" on my probe copy. 0 dialogs. The 4 "unsaved" windows are the generator's hidden `LVMCP Validate*` windows. Project closed.
- LabVIEW starts made: 0. No restart, no kill.

**2. Cleanup** (the loop-VI probe ran first)
```
probe proof\ZMP-10e\ZMP-10e-clean_probe.vi (copy of ZMP-10c-throwaway): state 1 before/after, cleanup code 0
  spec rows same (0:src1/dyn2, 1:src3 static "Stop" Value Change/dyn0, 2:src1/dyn1); use-default selTun 517 0x300801 same; dyn wires 5 same
  54 wires, same endpoints (only diffs: gRef VI name; payload wire type label "Payload Placeholder" -> "error", same node and terminals)
cleanup 27 VIs (26 ROOT + ZM-TST-routing)  start HEAD 870a9d9  batches 2 (5 + 22)  ~0.5 s per VI  codes 27/27 code 0
member helperPanel: spec rows, use-default, 54 wires identical before/after; panel on call 1/1 before and after; Stop action 1, visible T
versions 26 before/after   sweep before/after 27/27 state 1, control 0 7, same   git: only .vi per batch   commits b68660a f7e4c13
```

**3. Icons**
```
icons 27 VIs  mode new (ROOT) + composite (T7, owner tests, no template)  spec existing  preview approved (D39, not asked)
make_icons --check exit 0, generate exit 0 (160 icons); before read-back 27/27 written (all differ: no icons yet)
own layers 27 (lvai_set_vi_icon, verified; own read-backs 27/27 at 0 px)  templates: ROOT class 1, ROOT library 1 (all errors 0)
applied 26: vi count 26, open/save codes all 0   read-back 27/27 0 px (files 27, pixcmp --tree exit 0)   owners 2/2 at 0 px
versions 26 unchanged  git: the 27 VIs, the .lvclass (icon + FlattenedPrivateDataCTL re-flattened) and the .lvlib (icon)  commits 5e02c05 309d15f
```

**4. Closing checks** (evidence in `proof\runs\10e-checks.txt`)
- **Descriptions:** 27/27 VIs have one. Actor Core now has my D40 text (`pa_replace_description`, 1 replacement, commit 870a9d9). Please review it.
- **Dependencies** (`lv_loadability --links` on all 171 files in `src`): 0 violations.
  - ROOT references CM, HWM, SIM, FL, UDP and MX.
  - HWM and CM reference no other actor and no concrete hardware or protocol class.
  - Only the tests reference ROOT.
  - SIM, FL, UDP and MX are referenced only by ROOT and the tests.
- **`.lvproj` actors folder:** lists CM, HWM and ROOT once each (lines 16–18). BOM and 42 CRLF line endings kept. Unchanged against HEAD.
- **Versions:** 75 of 75 files read 26 (actors, tests, and the `.lvproj` at 26.0).
- **Cold sweep** of `src\actors` and `src\tests`: 62/62 state 1, control `0 7`, 19.6 s.
- **Membership:** CM 13/0, HWM 16/0, ROOT 26/0, tests 7/0. Every exit code 0.
- **T1–T7, run cold:**
  - T1 packages: PASS. Pass T, error 0.
  - T2 log: PASS. Pass T, error 0.
  - T3 hardware: PASS. Pass T, error 0.
  - **T4 protocol:** run 1 **FAIL** (Pass F, error 0, `init_ok` F, the other 6 checks T). One diagnostic rerun: **PASS**, all T.
  - T5 udp: PASS. Pass T, error 0.
  - T6 pipeline: PASS. Pass T, error 0.
  - T7 routing: PASS. Pass T, error 0, all 4 checks T.

**5. Commits** (explicit paths, no trailer, not pushed)
- 870a9d9: Actor Core description.
- b68660a, f7e4c13: cleanup.
- 5e02c05, 309d15f: icons.
- a4c0df6 `feat(root): root actor with routing and panel loop`: an **empty marker**, because everything was already committed.
- `git status --short`: only the two untracked `runs\` notes, which are not mine.

**6. Deviations and items for the user**
- (a) **T4 is intermittent.** The first run failed on `init_ok` alone. That check is "init no error AND a second Create Folder answers 10", and the test does not show the code it got. The rerun passed. I changed nothing in FL or T4. Cause unknown; T4 needs watching in phase 12.
- (b) The Actor Core description is my wording.
- (c) Icons: the generator's known differences (D39): a white 3x5 banner and the library glyph at the left.
- **For the user in the IDE (D38), the full ROOT list:**
  - Set the class description to the 10a text in `report-10a-root-class.md`, item 7.
  - Put `Actor Core.vi`, `Pre Launch Init.vi` and `Handle Error.vi` into `AF Overrides`.
  - Put `ZM-ROOT-helperPanel.vi` into `Helpers`.
  - Put `ZM-CI-handlePackage.vi`, the 9 hooks/ST members (close, createEvents, createResources, evaluateError, launchCm, launchHwm, notePackageType, showError, stop) and `ZM-ROOT-writePrelaunchSettings.vi` into `Methods`.
  - Put `ZM-ROOT-EVENTS.ctl` and `ZM-ROOT-PRELAUNCH_SETTINGS.ctl` into `TypeDefs`.

**7. Side effects**
- **A stale `.git\index.lock`** (0 bytes, dated 19:40, so before my start) blocked my first commit. No git process was running. I waited about 15 s, then deleted it. Nothing else in `.git` was touched.
- **New output folders** (git-ignored): `output\test_fl_125501706` and `output\test_fl_125517645` (T4), plus the UDP test's `test_mx_a` and `test_mx_b`, which T5 rewrites.
- **Error log:** T2 and T7 appended 4 lines to `output\ZM-error_log.txt`, which now has 11 lines.
- **Re-saves:** only the files committed above. Nothing outside `src\actors\ZM-ROOT-root\` and `ZM-TST-routing.vi` was re-saved. The `.lvproj` is untouched, and the project was never opened.
- **`proof\ZMP-10e\`** (git-ignored) holds the probe copy and its extracts, the nets and probe outputs, the sweep and cleanup lists, `make_icons` logs, `descs`, `dep_check`/`links_all`, `versions`, and the scripts (`desc_inputs`, `rb_lists`, `own_check`, `dep_check`). `proof\icons\` was regenerated.
- **Read-back folders:** `%TEMP%\LabVIEWMCP\rb\10e_before`, `10e`, `10e_own`, `10e_owner`, plus the list files. A mis-quoted shell run created a stray `rb$t` folder and list files; I deleted them at once.
- No new helpers and no stubs.
