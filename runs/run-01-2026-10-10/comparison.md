# Comparison with the original: run-01-2026-10-10

Drafted by a docs-only agent at HEAD `b63eea2` (2026-10-11 ~21:40) while 12b ran; the manager checked it against the
files and adds the 12b results in phase 13. Method: the 178 tracked files under `zuehlke-mcp-af-test-results/src/`
listed and the `.lvclass`/`.lvlib`/`.lvproj` XML grepped; no LabVIEW call. What lives inside a VI (diagram shape,
dispatch, reentrancy) comes from the agents' reports and is cited; what could not be seen is "not verified". Paths
are relative to `src/`; "report-NN" = `runs/run-01-2026-10-10/reports/report-NN-*.md`.

## 1. Expected differences (`requirements/05-skill-alignment.md`)

| # | expected difference (now) | shown | evidence |
|---|---|---|---|
| N1 | member VIs camelCase | yes | `ZM-PC-getDataAsJson.vi`, `ZM-CP-FL-appendLine.vi`; `launchCm` is `ZM-ROOT-launchCm.vi` |
| N2 | `ZM-CI-handlePackage.vi`, `ZM-CI-handlePackage Msg` | yes | `common/ZM-CI-common_interfaces/ZM-CI-package_handler/ZM-CI-handlePackage.vi`, `.../ZM-CI-handlePackage Msg/ZM-CI-handlePackage Msg.lvclass` |
| N3 | `ZM-ROOT-helperPanel.vi`, `ZM-HWM-helperAcquisition.vi` | yes | both files are in their class folders |
| N4 | typedefs in UPPER_SNAKE | yes | 11 `.ctl`, e.g. `ZM-PC-PACKAGE_TYPE.ctl`, `ZM-PC-TP-DATA.ctl`, `ZM-ROOT-EVENTS.ctl` |
| N5 | fields camelCase | yes | `Read outputFolder.vi`, `Write cmEnqueuer.vi`; `intervalMs` |
| N6 | `createEvents`, `createResources`, `evaluateError`, `notePackageType`, `showError` | yes | `ZM-ROOT-*.vi` and `ZM-HWM-*.vi` with these names |
| N7 | event elements `stop`, `error` | yes | report-12d item 2; report-09c (HWM `stop`) |
| N8 | test VIs `ZM-TST-*` | yes | `tests/ZM-TST-{packages,log,hardware,protocol,udp,pipeline,routing}.vi` |
| N9 | kept: snake_case class and library names, `ZM-CU-log`, JSON keys, top-level names | yes | the `.lvlib` names; `ZM-launcher.vi`; evidence-12a (JSON keys) |
| L1 | 14 libraries, one per pluggable child, plus `ZM-TST-tests` | partly | 13 `.lvlib`: SIM, FL, UDP and MX each have their own, and `ZM-TST-tests` exists. The count is 13, not 14 (F3, §2) |
| L2 | folders `Accessors`, `AF Overrides`, `Helpers`, `Messages`, `Methods`, `TypeDefs` | partly | only `Accessors` (12 classes) and `Messages` (the `ZM-CI` lvlib) exist; the rest are pending for the user (D38) |
| L3 | typedefs are class members in `TypeDefs`; no UDP connection typedef | partly | the `.ctl` files sit flat in their class folders, the UDP library has no `.ctl`; no `.ctl` is an item of any `.lvclass`, `.lvlib` or `.lvproj` (D38) |
| L4 | accessors on demand, static, private unless needed | yes | 45 `Read`/`Write` VIs, exactly the `02` §7 tables; no `Read initialized`, no `Write remoteAddress`. "Static" from the reports; not verified from the files |
| L5 | private by default | yes | `NI.ClassItem.MethodScope` in all 15 `.lvclass` files matches every scope in `02` §7: AF overrides 3, PC `Write type` and `getHeader` protected |
| A1 | one `PRELAUNCH_SETTINGS.ctl` per actor + public `writePrelaunchSettings`, filled by `launch<Child>` | yes | 3 `.ctl` and 3 `writePrelaunchSettings` VIs at scope 1; report-11a item 2 |
| A2 | no init messages; one message class; launches from Actor Core | yes | only `ZM-CI-handlePackage Msg.lvclass`; the launches run from ROOT Actor Core through `ZM-ROOT-init` (D41, a VI, not a message) |
| A3 | user events created in Pre Launch Init by `createResources` → `createEvents`, cleaning up on its own error | yes | `ZM-HWM-`/`ZM-ROOT-createResources.vi`, `createEvents.vi`; R-pli-failure passes (report-12d item 5) |
| A4 | the loop only unregisters; `close` destroys after Merge(loop, stop) | yes | report-12d item 4, report-09d (exports); R-close-order passes on dataflow, not timed |
| A5 | stop hook on a fresh chain; Actor Core returns Merge(Call Parent, close) | yes | report-12d item 4; report-12c |
| A6 | CM Stop Core: Call Parent, then `releaseProtocol` | yes | report-08b |
| A7 | Handle Error: Call Parent first, then `evaluateError`; a manager clears with `stop actor?` T | partly | the order is as expected; nothing is cleared: `evaluateError` is a pass-through (D40), `stop actor?` from Call Parent (report-08b) |
| A8 | an error case in each loop; after the loop `evaluateError` → Send Normal Stop | yes | report-09c, report-10c (D40 tail added) |
| A9 | no Timeout frames (an empty one only where the build tool needs it) | partly | ROOT none (report-10c); the HWM event loop has an empty Timeout frame (report-09c item 8b says the step needs it; not verified) |
| A10 | HWM `stop` hidden, off the pane | yes | report-09c ("stop hidden yes"); off-pane not verified separately |
| A11 | kept: no base actor, no Handle Last Ack Core, one stop mechanism, registration via the dynamic terminal, hook VIs | yes | ROOT parents `Actor` + the interface; no `Handle Last Ack Core.vi`; Register moved into `init` (D41) and still feeds the dynamic terminal |
| E1 | every deliberately unhandled error ends in Clear Errors | yes | reports 08b, 09c, 10c; one addition: the launcher's `error out` (§2) |
| E2 | release errors logged or cleared | yes | report-08b: `releaseProtocol` clears code 1 unlogged, any other is logged then cleared |
| E3 | error plan in each class description and in `decisions.md` | partly | `decisions.md` has D14 and D40; no class has a description (D38); the CM and HWM description texts waiting for the user still state D14 |
| E4 | kept: the plan (D14), the log (D15), 5000 (D16, D18) | partly | D14 suspended by D40; D15 and 5000 kept; `errors/ZM-errors.txt` present but not installed (§2) |
| H1 | tests output `Pass` + `error out` | yes | evidence-01c to -12d |
| H2 | tests in `ZM-TST-tests.lvlib`, listed in `checks.json` | yes | the lvlib holds 7 VIs; `.labview/checks.json` names all 7 |
| H3 | Clean Up Diagram at the end of each VI's work | yes | reports 01d, 05d, 08c, 09d, 10e, 11b, 12c, 12d; regenerated VIs cleaned again (e26200f) |
| H4 | every class and VI has a description | partly | VIs yes (AF overrides via `pa_replace_description`, report-08c item 5); no `NI.Lib.Description` in any `.lvclass` or `.lvlib` (D38) |
| H5 | class template + glyph layers, as the skill's reference draws them | partly | applied and read back at 0 px (reports 01e-12d); the look follows the generator, not the convention (D39) |
| R | R-close-order, R-stop-reset, R-pli-failure added | yes | close-order on dataflow, not timed; stop-reset passes; pli-failure FAILED in 12a (F14), passed after D41 (evidence-12d) |
| C | counts: 14 libraries, 1 message, 9 overrides, 11 typedefs, ~35 accessors | partly | 13 libraries (F3); 1 message; 9 overrides; 11 `.ctl`; 45 accessors (= `02`'s tables; `05`'s "about 35" is an estimate); 137 VIs (the original had 146) |

## 2. Other differences between `src/` and `02-specification.md`

**D40 (the user, 2026-10-11, phase 09c; F11).** Evidence: `decisions.md` D40, f8ec2b1, report-09c, report-10c.
- `ZM-CM-`, `ZM-HWM-`, `ZM-ROOT-evaluateError.vi` are pass-throughs (class, error, `stop actor?`); no `ZM-CU-log`,
  no `ZM-PC-EP-create`, no clearing. `02` §5, §7.10-§7.12 and D14 are suspended. An error stops its actor and,
  through the Last Ack, the tree (`02`: the root keeps running). R-error judged against D40 (evidence-12a). The
  error-package path (`showError`, `cmRunning` = F) is exercised only by T7's routing, not by a run.
- The loops stop each other: in `helperAcquisition` each loop calls `stop` when it ends (error to Clear Errors); the
  event loop also writes the local `stop` = T (written twice, report-09c item 8c); `helperPanel` sends the stop event
  after its loop. `02` §7.11 has the producer end alone.
- After the loops: Merge → `evaluateError` (`stop actor?` unwired) → on an error Send Normal Stop on a fresh chain;
  the loop VI's `error out` is the raw merged error.
- No Handle Last Ack Core override; an error stop cascades by AF's default; the only clean stop is the root's.

**D41 (the user, 2026-10-11, phase 12; F14).** Evidence: `decisions.md` D41, 206b920..076479e (HWM),
9cb0c60..1cad6ec (ROOT), report-12c, report-12d.
- New members `ZM-HWM-init.vi` and `ZM-ROOT-init.vi` (private, static, refnum on terminal 2), in series before Call
  Parent. ROOT `init`: `launchCm` → `launchHwm` → Read events → Register For Events; HWM `init`: Read events → Register.
- Registration moved out of the loops (`02` §6, §7.11, §7.12: "right before the loop"); each loop VI takes the refnum
  as an input and keeps Unregister after the loop; in `helperPanel`, Unregister's `error in` is now unwired.
- ROOT Actor Core is `init` → Call Parent (`02`: `launchCm` → `launchHwm` → Call Parent); the stop frame's class wire
  comes from `init`.

**Names added beyond `02`:** `ZM-HWM-init.vi`, `ZM-ROOT-init.vi` (D41) - the only extra files; every other name in
`02` §7-§9 is present, and nothing else.

**`ZM-launcher.vi` has an `error out` indicator** (terminal 0) that `02` §8 does not list (deviation 11a,
`errors.ignored-errors`; "listed for the user to confirm", no answer recorded). `ZM-launcher_test.vi`'s `error out`
merges the stop chain first, so a placeholder run reads 1556 and hides any panel-read error (report-11a item 3).

**Derived helpers used instead of kit helpers** (not in `src/`; the routes differ; sources in the git-ignored
`proof/ZMP-*`): library creation (`zm_create_package_library`, `zm_create_test_library` from the kit's
`lvai_create_actor_library.xml`); cluster typedefs (`zm_cluster_element_replace`, `zm_cluster_element_default_u32`);
`.lvproj` drops (`lvproj_drop_eol.py`, F10); event loops (`zmp09c_wire_dyn_deep`, because `lvai_wire_dynamic_events`
reaches only 2 levels; `zmp09c_set_use_default`, `zmp09c_set_plot_names`, `zmp09c_replace_constant_deep`); Actor
Core joins (`zmp09d_close_join`, F12); the D41 rework (`zmp12c_reg_to_control`, `zmp12c_reg_indicator`,
`zmp12c_wire_nodes`, `zmp12c_insert_series_branch`, `zmp12d_remove_series_block`); hand-made stubs in
`user.lib\LV_MCP`; `pa_clean_member` for leftover broken wires (report-10b3).

**Library count (F3):** 13 `.lvlib` (the 12 shipped ones of `02` §1 + `ZM-TST-tests`); `02` §10, `05` "Counts" and the
README say 14. Open for the user.

**Other items:** `errors/ZM-errors.txt` not installed into `user.lib\errors` (CLAUDE.md default; `02` §8 says
installed). `ZM-CM-writePrelaunchSettings` always bundles and passes `error in` through (deviation 08a). MX on an
element error keeps the processed elements' old state (F8, kept by the user). The diagram-width budget of 10 is
exceeded (`releaseProtocol` 11, `helperAcquisition` 26, `ZM-launcher_test` 40); no subVI invented. `ZM-CP-MX-initAll`
/ `closeAll` shared-clone reentrancy: flags read differently after a re-save, not verified (report-05b item 8b).
Phase card 03 contradicts `02` on SIM `init`/`close` (F6); `src` follows `02`.

## 3. D38 items still open for the user in the IDE

The XML confirms them: no class or library has a description, no `.ctl` is a member of anything, and the only virtual
folders are `Accessors` and the CI library's `Messages`. The per-class list is in `status.md`, "For the user in the
IDE". Note: the CM (report-08a item 7) and HWM (brief-09a) description texts still state D14 and need D40 wording; the
ROOT text (report-10a item 7) already states D40. No library has a description either (the D38 list does not name
library descriptions).
