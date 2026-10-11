# Brief 12c: the F14 fix by D41 on the HWM: `ZM-HWM-init.vi` registers in Actor Core; the loop VI receives the registration
Type: fix (LabVIEW calls, Actor Framework). Phase 12 step c (owned by phase 09; d: the same on the ROOT, then the reruns).

## UPDATES (read first; they override the rest)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-12a-runs.md` (F14:
  the ROOT tree hung after a nested launch failure, the stop event was lost before the loop registered),
  `report-09c-hwm-helper-loop.md` (how the loop VI was built: derived deep-wiring helper, use-default tunnel, event
  specs, plot names, panel on call, hidden `stop`), `report-09d-hwm-actor-core-proof-close.md` (Actor Core shapes, the
  derived close-join, the HWM proof runs and the stop reset).
- **D41, the user (2026-10-11):** "Make a init method and call it in actor core before the core and add all init things
  there. basically what you are suggestion, just collecting it in an init, not pre init method, feel free to use subvis
  in it". Read `C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`, "Each actor with a helper loop has an `init` method".
- **LabVIEW holds a HUNG ROOT tree** (PID 26148, from 12a). The user's STANDING kill go-ahead for this session (2026-10-11
  ~20:40): "feel free to kill labview at will for this session". So first: `lv_windows.ps1` (record), `Stop-Process -Id
  26148` (never the Nigel processes), `lv_windows.ps1`, then start LabVIEW per `<skill>\session\start.md` steps 3-4
  (`lvai_ensure_labview`; LVAutoSave must be 0, else stop and report), `lvai_status`. Report each kill and start.
- **Broken wire first:** a VI at cold state 0 with a broken-wire text after a generate, swap or bind gets the kit's
  `pa_clean_member` before any rebuild. F10 before any `lvproj_*` script. F12: the derived close-join. One call per
  message. Never run a loop VI by itself. D40 still holds (pass-through `evaluateError`, loops stop each other).

## Goal
1. **`ZM-HWM-init.vi`** (new member, private, static): pane class in/out, `error in`/`error out`, plus an output of the
   event registration refnum. Body: `Read events` → Unbundle `stop` → Register For Events on a FRESH "no error" → the
   refnum out; `error out` = Merge(`error in`, Register's error). Description with D41. Append D41 to
   `zuehlke-mcp-af-test-results\.labview\decisions.md` in the D38-D40 format (the user's words above; Supersedes: the
   `registration` convention's "Register right before the loop" for actors with an `init`). Commit each.
2. **`ZM-HWM-helperAcquisition.vi`**: remove its Register For Events; add an INPUT terminal for the registration refnum
   (pane: the next free input; class in stays); that input goes into the event structure's dynamic terminal (the 09c
   deep-wiring helper, one level as before), and the right side stays wired out to Unregister. Everything else as 09c
   built it, incl. D40's loops-stop-each-other tail, use-default tunnel, event specs, panel on call, hidden `stop`, plot
   names. **Unmeasured:** an event registration refnum control on a pane, and how to author or create it (AIXML, or
   scripting "Create Control" from a Register output): measure on a throwaway copy in `...\proof\ZMP-12c\` first. Avoid
   a full regeneration if an in-place scripted edit works; if you must regenerate, repeat every 09c step and read back.
3. **`Actor Core.vi`** (HWM): `init` as a series hook BEFORE Call Parent on class and error (shape B; its error goes
   into Call Parent); the loop's call takes the class from `<C> in` (unchanged) and the refnum from `init`'s output;
   `stop` after Call Parent and `close` after Merge(loop, stop) as before. Export and quote the shape.
4. **Proofs** (project closed; 09d's proof VIs in `...\proof\ZMP-09d\`, copied to `...\proof\ZMP-12c\`): run 1 (SIM,
   about 6 lines, clean Last Ack), run 2 (bare HW: the tree stops by itself with 5000), the stop reset (6 + 6). Then a
   NEW run: a Normal Stop sent to the HWM right after its launch (no wait), five times: every run returns, no hang.
5. **Cleanup and icons** on the changed/new VIs (init, the loop VI after a copy-probe, Actor Core); sweep of the HWM
   folder (every VI 1, control `0 7`), membership, versions 26, links (HWM links no CM/ROOT/SIM/CP).

## Paths
- Product `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; HWM folder
  `...\src\actors\ZM-HWM-hardware_manager\ZM-HWM-hardware_manager\`; proof `...\proof\ZMP-12c\`; evidence
  `...\proof\runs\12c-checks.txt`. Skill `<skill>` = `C:\Users\jorgen.steen\.claude\skills\labview` (`ops\helper-loop.md`,
  `ops\override.md`, `ops\cleanup.md`, `ops\icons.md`, `session\start.md`, `session\restart.md` "Killing LabVIEW").

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call per message, never two, offline ones included.
- Kills: allowed by the standing go-ahead, each reported with the PID and the window list before it. Never answer a
  dialog. A proof that does not return: stop, `lv_windows.ps1`, report (a kill to clear it is allowed).
- No hand edits of LabVIEW files. In `src\` only the HWM folder, `.labview\decisions.md` and the `.lvproj` may change.
- Commit before every structural step, explicit paths, Conventional Commits (`fix(hwm): ...`), no attribution
  trailer. Never push. Save version 26.0 or stop. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 75 lines), as your final message
1. Kill and start blocks; `lvai_status` start/end. 2. `init`: pane, body, state. 3. The loop VI change: route (what
was measured on the throwaway), the export (refnum input → dynamic terminal, Unregister), read-backs. 4. Actor Core
`ops\override.md` block and export. 5. The proof runs incl. the five early stops. 6. Cleanup, icons, sweep, versions,
links. 7. Commits; `git status`. 8. Deviations / NEEDS CLARIFICATION. 9. Side effects.
