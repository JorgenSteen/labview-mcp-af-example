REPORT 12b: structural checks of `03` §3 and the final cold sweep over all of `src\`. **DONE.** 2026-10-11, about 21:32 to 22:20. No NEEDS CLARIFICATION. No CANNOT PROCEED.
- I made 4 LabVIEW calls, each alone in its own message: 2 `lvai_status` and 2 sweep batches.
- Everything else was read offline: XML, `lv_loadability`, pylabview extracts, `vi_nets`, git.
- Evidence: `zuehlke-mcp-af-test-results\proof\runs\12b-checks.txt`. Work files are in `proof\ZMP-12b\`.

**1. `lvai_status`**
- **Start:** PID 26716, port 56779, 1.9.5-local, up 3008 s, dwarn 0. Project closed, 0 dialogs, LVAutoSave 0.
- **End:** same PID and port, up 3846 s, dwarn 0, not degraded. Project closed, 0 dialogs. The 2 unsaved windows are the tool's hidden `LVMCP Validate`.
- No start, restart or kill. No dialog answered. No project opened.

**2. `03` §3, one line per row**
1. **Runnable: PASS.** 137/137 VIs read state 1 cold; the negative control read `0 7` in both batches.
2. **Membership: PASS.** 134 members, 0 missing, 3 plain VIs (the 2 launchers and the receiver). All 15 classes sit in their own library. The 7 tests are in `ZM-TST-tests.lvlib`.
3. **Dependency rule: PASS.** I checked every link, vi.lib included, over 176 files: 0 violations.
   - Only CI, CM, HWM and ROOT (and the launchers) reference AF.
   - HWM uses AF, CI, HW and PC. CM uses AF, CI, CP, CU and PC.
   - Only ROOT and the tests reference SIM, FL, UDP and MX.
   - The receiver uses only UDP and PC.
4. **Naming: PASS.** 177 file names, 0 deviations. Field names rest on the describe_class readings of 01a, 03a, 04a, 05a, 05b, 08a, 09a and 10a.
5. **Scope and accessors: PASS.** There are 45 accessors. Each has at least one caller and exists only in the direction `02` §7 lists. All are static (no dispatch flag on the pane). Every member's scope matches `02` §7.
6. **AF overrides: PASS.**
   - All 9 overrides are protected and call Call Parent.
   - Handle Error (×3) and CM Stop Core feed their hook from Call Parent's outputs, so the parent runs first.
   - `Do.vi` is public because AF's `Message:Do` is public.
7. **Pre Launch Init: PASS.** Each of the 3 calls only `createResources` (and its parent). None of them launches anything.
8. **Actor Core, ROOT and HWM (D41): PASS** (nets).
   - `init` runs in series before Call Parent.
   - The loop runs beside Call Parent and takes init's refnum.
   - `stop` runs after Call Parent on a fresh error chain.
   - Merge(loop, stop) feeds `close`; Merge(Call Parent, close) is `error out`.
9. **No Stop Core on ROOT and HWM: PASS.**
10. **Helper loops: PASS, Helpers folder pending (D38).**
    - The refnum comes in through the pane, goes into the loop and its error case, then to the dynamic terminal; the right side goes to Unregister.
    - Neither loop VI registers or destroys anything.
    - `init` registers on a fresh "no error".
11. **User events: PASS against `02`.** HWM has EVENTS {stop}, ROOT has EVENTS {stop, error}; each has one `events` field and one Read/Write pair. The CM has no user events in `02` §7.10.
12. **Pre-launch settings: PASS.** 3 `PRELAUNCH_SETTINGS.ctl` and 3 public `writePrelaunchSettings`. `launchCm` and `launchHwm` are called inside `ZM-ROOT-init` (D41).
13. **Messages: PASS.** The only message class is `ZM-CI-handlePackage Msg`.
14. **Ignored errors: FAIL, test VI only.** In `ZM-TST-routing.vi`, 6 Search and Replace String nodes have `error out` (and `error in`) unwired. Every other `error out` in all 137 VIs is wired.
15. **Error code 5000: PASS.** It is in `docs\error-codes.md` and `src\errors\ZM-errors.txt`. Both raising VIs (the parent `ZM-HW-do` and the parent `ZM-CP-publish`) carry `#customerror 5000`.
16. **Virtual folders: PENDING (D38).** Only the `Accessors` folders and the library's `Messages` folder exist. None of the 11 `.ctl` is a member of a class.
17. **Descriptions: VIs PASS, classes PENDING (D38), one defect.**
    - All 137 VIs have a description.
    - D40 is stated per actor in Handle Error and evaluateError, and for HWM and ROOT also in Actor Core and init.
    - 0 of 15 class descriptions are set (D38). The prepared CM and HWM texts still state D14 (defect c).
18. **Icons: PASS.**
    - 137/137 stored icons match the `make_icons` composites. I compared pixels with a tolerance of 14 per channel for the palette. As a control, other VIs' icons against the same reference differ in 126 and 381 pixels, so the compare can tell icons apart.
    - All 28 classes and libraries have an icon.
    - The template layers were read back at 0 px in 01e to 12d.
    - The D39 deviation applies (white banner, library glyph at the left).
19. **Clean Up Diagram: PASS with notes.**
    - 135 of 137 VIs have a cleanup commit. Every later commit is icons or descriptions only, except one.
    - CM `Handle Error.vi` had its hook swapped (f8ec2b1, D40) after its cleanup (3a71740) and was never cleaned again.
    - `Do.vi` and `Send` (Message Maker products) were never cleaned.
20. **Project tree: PASS except the count (F3, not decided).**
    - The tree has 13 libraries (12 shipped + ZM-TST). Both `03` and `02` §10 say 14.
    - Present as specified: the 6 virtual folders, 2 launchers, the receiver, 7 tests, 13+1+1 classes, 11 typedefs, 9 AF overrides.
21. **A clean stop leaves the error log empty: PASS.** `error_lines` read 0 in 12a's R-normal (×3) and in 12d's R-normal.

**3. Cold sweep and membership**
```
cold sweep src  labview-mcp 1.9.5-local  LabVIEW up 3008 s  baseline none (built code: every VI must read 1)
not loadable: none (42/42 targets, 169 files)
batch 0  30 VIs  30/30 state 1  control 0 7  7.1 s
batch 1  107 VIs  107/107 state 1  control 0 7  16.1 s
not state 1: none   membership: checked 134  not a member 0  plain 3   exit 0
git: unchanged   side effects: none   LabVIEW calls 4   sweep 23.2 s
```
- Save versions: 177 of 177 files read 26.
- No `LVMCP Stub` link in `src`.
- `ZM-CP-MX-initAll` and `ZM-CP-MX-closeAll` are saved as shared-clone reentrant. This settles the check 05b left for the IDE.

**4. Defects**
- **(a)** `ZM-TST-routing.vi`: 6 unwired Search and Replace String error terminals. Owner: phase 10d. Fix: wire them into the test's error chain or end each in Clear Errors, then clean up, icon and sweep.
- **(b)** CM `Handle Error.vi` was not cleaned after the D40 swap. Owner: 09c (f8ec2b1). Fix: Clean Up Diagram on that one VI with the project closed, then a cold read.
- **(c)** The CM description text (report-08a, item 7) and the HWM text (brief-09a) state D14. Owner: 08a/09a texts and the status list. Fix: replace the "Error plan (D14)" sentence with the D40 wording of ROOT's 10a text before the user sets them.
- **Notes (no fix asked):**
  - In Handle Error (×3), Call Parent's `stop actor?` goes straight to the indicator; evaluateError's `stop actor?` in/out is unwired. `02` §5 routes it through evaluateError. Under D40 the result is the same.
  - `ZM-CM-releaseProtocol` drops the close error with Unbundle and a constant, not `Clear Errors.vi` as `02` §7.10 says.

**5. D38 pending (the user, in the IDE)**
- **Class descriptions:** all 15 classes (13 classes, the interface and the message class).
- **TypeDefs** (the `.ctl` as class members):
  - PC: PACKAGE_TYPE, DESTINATION, HEADER
  - TP: TP-DATA; EP: EP-DATA
  - MX: PROTOCOLS
  - CM: PRELAUNCH_SETTINGS
  - HWM and ROOT: EVENTS and PRELAUNCH_SETTINGS each
- **AF Overrides:**
  - CM: Pre Launch Init, Stop Core, Handle Error
  - HWM and ROOT: Actor Core, Pre Launch Init, Handle Error
- **Helpers:** HWM `helperAcquisition`; ROOT `helperPanel`.
- **Methods:**
  - CM: handlePackage, createResources, releaseProtocol, evaluateError
  - HWM: handlePackage, close, createEvents, createResources, evaluateError, init, stop
  - ROOT: handlePackage, close, createEvents, createResources, evaluateError, init, launchCm, launchHwm, notePackageType, showError, stop
  - PC: init, getDataAsJson, getTypeName, getDestinationName, getTimestampString, getHeader
  - TP and EP: init, getDataAsJson, create, setType
  - HW: init, do, close; SIM: do, randomData
  - CP: init, publish, close
  - FL: init, publish, createFolder, buildPath, appendLine
  - UDP sender: init, publish, close, openSender, closeConnection
  - UDP receiver: init, close, openReceiver, receive, closeConnection
  - MX: init, publish, close, initAll, closeAll
  - Interface `ZM-CI-handlePackage`: the user's call
- **`writePrelaunchSettings` (CM, HWM, ROOT):** `02` §2 says custom accessors go in `Accessors`; `status.md` says `Methods`, the user's call. The full list is in `proof\ZMP-12b\d38_pending.txt`.

**6. Side effects and `git status`**
- Nothing in `src\` changed; nothing was re-saved and nothing committed.
- New git-ignored files: `proof\ZMP-12b\` (lists, extracts, nets, scripts, results) and `proof\runs\12b-checks.txt`.
- Offline pylabview extracts read the source files only.
- `git status --short`: only the two untracked `runs\run-01-2026-10-10\*.md` files, which are not mine.
