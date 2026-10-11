# Brief 12d: the F14 fix by D41 on the ROOT (`ZM-ROOT-init.vi`: launches + Register in Actor Core), then the reruns
Type: fix + test (LabVIEW calls, Actor Framework). Phase 12 step d (owned by phase 10; then 12b: structural checks and the cold sweep).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-12c-hwm-init-d41.md`
  (THE MEASURED ROUTE: `init` with a refnum output by `zmp12c_reg_indicator`; the loop VI edited in place by
  `zmp12c_reg_to_control`; Actor Core rewired by `zmp12c_insert_series_branch3` + `zmp12c_wire_nodes`; all sources in
  `...\zuehlke-mcp-af-test-results\proof\ZMP-12c\`), `report-12a-runs.md` (F14: R-pli-failure hung the ROOT tree),
  `report-10c-root-helper-panel.md` and `report-10d-root-actor-core-t7-proofs.md` (the ROOT loop and Actor Core).
- **D41, the user (2026-10-11):** "Make a init method and call it in actor core before the core and add all init things
  there ... feel free to use subvis in it" (`C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`). D41 is already in
  `decisions.md` (12c). The user's STANDING kill go-ahead for this session: "feel free to kill labview at will for this
  session" (report each kill). LabVIEW PID 26716, port 56779, project closed, at the end of 12c.
- **12c's traps:** derived helpers must look up every node/terminal BEFORE deleting any wire, and delete a node's input
  wires before the node (both races hit in 12c); a tunnel terminal carries its source's name, so match the far end's
  owner class too; `git checkout` of an older override revision is refused by the harness: edit in place instead.
  **Broken wire first** (`pa_clean_member`). F10 before any `lvproj_*` script. One call per message. D40 holds.

## Goal
1. **`ZM-ROOT-init.vi`** (new, private, static): `launchCm` → `launchHwm` (the existing members, as subVIs, class and
   error in series) → `Read events` (fresh chain) → Unbundle `stop`, `error` → Register For Events (both, FRESH "no
   error") → the registration refnum out; `error out` = Merge(launch chain, Read events, Register). Description (D41).
2. **`ZM-ROOT-helperPanel.vi`**: by 12c's in-place route: remove its Register For Events; a registration-refnum control
   on the pane (next free input) → the loop → the event structure's dynamic terminal; Unregister stays after the loop.
   Keep: the static `Stop` frame, the `error` payload field, event specs, use-default tunnel, panel on call, Stop action
   1, the D40 tail. Probe on a throwaway copy first; read every item back after.
3. **`Actor Core.vi`** (ROOT): REPLACE the two series hooks `launchCm`, `launchHwm` by one series hook `init` before
   Call Parent (class and error); the panel loop takes `<C> in` and init's refnum; `stop` and `close` unchanged.
   Export and quote it.
4. **Reruns** (project closed; evidence `...\proof\runs\12d-checks.txt`): **R-pli-failure** (12a's proof
   `...\proof\ZMP-12a\ZMP-12a-pli_failure.vi`): expected now the root tree STOPS by itself, the proof's caller queue gets
   the Last Ack with the CM's error (report the code), no panel left, no hang. **Early stop ×5 on the ROOT** (launch,
   Normal Stop at once): every run returns, no hang. **R-normal ×1** (`src\ZM-launcher_test.vi`: 8-11 lines, clean),
   **R-interactive** (12a's route, Stop by signalling write), **R-error** (D40), **T7** and the 10d launch proof once.
5. **Cleanup and icons** on the changed/new ROOT VIs (loop VI after a copy-probe); sweep of `src\actors` and
   `src\tests` (every VI 1, control `0 7`), membership, versions 26, links (only the ROOT references CM/HWM/SIM/FL/UDP/MX).

## Paths
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; ROOT folder
  `...\src\actors\ZM-ROOT-root\ZM-ROOT-root\`; proof `...\proof\ZMP-12d\`. Skill `<skill>` =
  `C:\Users\jorgen.steen\.claude\skills\labview` (`ops\override.md`, `ops\helper-loop.md`, `ops\cleanup.md`, `ops\icons.md`,
  `ops\run-checks.md`, `session\restart.md` "Killing LabVIEW").

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- Kills allowed (standing go-ahead), each reported with the window list before it. Never answer a dialog. A proof that
  does not return: stop, `lv_windows.ps1`, report, then a kill to clear it is allowed.
- No hand edits of LabVIEW files. In `src\` only the ROOT folder and the `.lvproj` may change.
- Commit before every structural step, explicit paths, Conventional Commits (`fix(root): ...`), no attribution
  trailer. Never push. Save version 26.0 or stop. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 75 lines), as your final message
1. Kills/starts; `lvai_status` start/end. 2. `init`: pane, body, state. 3. The loop VI change and read-backs.
4. Actor Core block and export. 5. Every rerun with its readings and verdict. 6. Cleanup, icons, sweep, versions,
links. 7. Commits; `git status`. 8. Deviations / NEEDS CLARIFICATION; IDE items. 9. Side effects.
