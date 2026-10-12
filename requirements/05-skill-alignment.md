# Zuehlke MCP — alignment with the `labview` skill

What changed from the original pilot's design when the requirements were aligned with the `labview`
skill's convention defaults (2026-10-10). Rule: where the original choice and the skill default
differ, or the original was ambiguous, the **skill default wins**; where the skill asks the user,
the user was asked (configuration: no files, D34). Rule ids are the skill's
(`<skill>/conventions/defaults/<concern>.md`).

Use this file to compare a remake with the original: a difference listed here is expected.

## Naming (`naming.*`)

| original | now | rule |
|---|---|---|
| member VIs snake_case: `ZM-PC-get_data_as_json.vi`, `ZM-CP-FL-append_line.vi`, `ZM-ROOT-launch_cm.vi` | camelCase: `ZM-PC-getDataAsJson.vi`, `ZM-CP-FL-appendLine.vi`, `ZM-ROOT-launchCm.vi` | method-case |
| interface method `ZM-CI-handle_package.vi`, message `ZM-CI-handle_package Msg` | `ZM-CI-handlePackage.vi`, `ZM-CI-handlePackage Msg` | method-case, override-names |
| helper loops `ZM-ROOT-helper_loop.vi`, `ZM-HWM-helper_loop.vi` (the user's D30) | `ZM-ROOT-helperPanel.vi`, `ZM-HWM-helperAcquisition.vi` | role-names (`helper<Purpose>`) |
| typedefs `ZM-PC-package_type.ctl`, `ZM-PC-TP-data.ctl`, `ZM-ROOT-events.ctl` | `ZM-PC-PACKAGE_TYPE.ctl`, `ZM-PC-TP-DATA.ctl`, `ZM-ROOT-EVENTS.ctl` | typedef-case |
| fields snake_case: `interval_ms`, `cm_enqueuer`, `output_folder` | camelCase: `intervalMs`, `cmEnqueuer`, `outputFolder` | field-names |
| `create_events`, `pre_launch_init`, `evaluate_error`, `note_package_type`, `show_error` | `createEvents`, `createResources`, `evaluateError`, `notePackageType`, `showError` | role-names, method-case |
| event elements `ui_stop_event`, `ui_error_event`, `stop_event` | `stop`, `error` | (element labels; the skill's own examples) |
| test VIs `ZM-PC-test_packages.vi` … | `ZM-TST-packages.vi` … (owner = the test library) | prefix, function-case |
| Kept: class/library names snake_case, `ZM-CU-log.vi` (function), JSON keys (decided D4), top-level VI names (decided D36) | | |

## Layout (`layout.*`)

| original | now | rule |
|---|---|---|
| 8 libraries; each hierarchy's children in the parent's library | 13 libraries (D42): each pluggable child has its own (`ZM-HW-SIM`, `ZM-CP-FL`, `ZM-CP-UDP`, `ZM-CP-MX`), plus `ZM-TST-tests` | library-per-actor (load units), hygiene.test-library |
| folders `Accessors`, `Methods`, `Overrides`, `AF Overrides`, `Controls`, `Messages for this Actor` | `Accessors`, `AF Overrides`, `Helpers`, `Messages`, `Methods`, `TypeDefs`; overrides in `Methods` (decided D35) | class-folders |
| typedefs in a library-level `Controls` folder (`ZM-PC` types, `ZM-CP` types) | typedefs are members of their class, in `TypeDefs`; the shared UDP connection typedef is gone (plain refnum fields) | typedef-placement |
| Read **and** Write accessors for every field, many public, dynamic where public | only the accessors code uses, in the used direction, static, private unless needed outside (e.g. no `Read initialized`, no `Write remoteAddress`) | accessors-on-demand, scope |
| scopes mostly public | private by default; public only when called from outside; protected for children | scope |

## Actor Framework shapes (`af-shapes.*`)

| original | now | rule |
|---|---|---|
| injected objects as plain fields (`hardware`, `interval_ms`, `protocol`, `output_folder`, `use_placeholder_hardware`) written before launch | one `ZM-<A>-PRELAUNCH_SETTINGS.ctl` per actor + public `writePrelaunchSettings`; the caller's `launch<Child>` fills it | prelaunch-settings |
| deferred start: ROOT/CM Pre Launch Init sends `ZM-ROOT-init` / `ZM-CM-init` to self | launches from ROOT's Actor Core; CM inits its protocol in Pre Launch Init; **both init messages and their classes are gone** (one message class left) | launch-owner, resources, pli-failure-cleanup |
| user events created at the start of Actor Core | created in Pre Launch Init by `createResources` (→ `createEvents`), which cleans up on its own error | resources, pli-failure-cleanup |
| the loop VI destroyed its user events after Unregister | the loop only unregisters; `close` destroys, in Actor Core after Merge(loop, stop) | close-vi |
| stop hook after Call Parent with its error **unwired** (ignored) | stop hook on a fresh chain, its error merged into `close`; Actor Core returns Merge(Call Parent, close) | stop-site, close-vi, errors.ignored-errors |
| CM Stop Core: release beside Call Parent (branch) | Call Parent first, then `releaseProtocol` | stop-core-order |
| Handle Error: `evaluate_error` **before** Call Parent, replacing a real error by code 43 | Call Parent **first**, then `evaluateError` on its outputs; a manager clears the error with `stop actor?` T (no 43 trick) | handle-error-order |
| no error case inside the helper loops | an error case inside each loop (shift register; Error frame ends the loop); after the loop: `evaluateError` → Send Normal Stop | helper-loop-error-case, errors.loop-errors |
| HWM Timeout frame "needed by LabVIEW" (empty) | no Timeout frames; an empty one only where the build tool needs it (LabVIEW needs one only when the Timeout terminal is wired) | timed-work; skill knowledge |
| HWM `stop` Boolean "hidden or shown" | hidden, off the pane | (skill helper-loop op) |
| Kept: interface for talking up, no base actor, no Handle Last Ack Core, shutdown cascade, one stop mechanism (user event + local `stop`), registration through the dynamic terminal, hook VIs | | dependency-direction, base-actor, handle-last-ack, shutdown-cascade, stop-mechanism, registration, hook-vis |

## Errors (`errors.*`)

| original | now | rule |
|---|---|---|
| ignored errors sometimes unwired (stop hook) | every deliberately unhandled error ends in Clear Errors | ignored-errors |
| release errors in Stop Core not addressed | logged via `ZM-CU-log` and passed on by the hook, ended in Stop Core (D44); code 1 of a never-opened resource cleared | release-errors |
| plan only in the design docs | the plan is in each actor's class description and in `decisions.md` | plan-required, hygiene.descriptions |
| Kept at first: the plan itself (decided D14; replaced by D40 for now), the local log (decided D15), 5000 and its registration (decided D16, D18) | | |

## Hygiene and icons (`hygiene.*`, `icons.*`)

| original | now | rule |
|---|---|---|
| test VIs: one Boolean per mechanism + `all_ok` | each test outputs `Pass` + `error out`; the per-mechanism Booleans are informational; round-trip checks named for the classes that pack or bundle data | test-convention |
| tests loose in `src/tests/` | in `ZM-TST-tests.lvlib`, listed in `.labview/checks.json` | test-library, test-convention |
| Clean Up Diagram on every VI as one final pass | on every VI the build generated, at the end of that VI's work | cleanup-diagram |
| descriptions not required | every class and VI has one | descriptions |
| icons: generated full composite per VI from the original preview | class template (banner + ONE class glyph) set once and applied by LabVIEW as each member's template layer; each VI its own glyph layer; library banner; look per the skill's reference, not the original preview | banner, class-glyph, labview-template, vi-glyph, library-icon, reference |

## Acceptance checks added

`R-close-order` (stop, loop exit, then `close`), `R-stop-reset` (the loop called twice from one
caller: two top-level runs test nothing) and `R-pli-failure` (a failing `createResources` cleans up),
from the skill's helper-loop checks and its AF knowledge.

## Counts

| | original | now |
|---|---|---|
| libraries | 8 | 13 (D42) |
| message classes | 3 | 1 |
| AF overrides | 8 | 9 (PLI, Actor Core / Stop Core, Handle Error per actor) |
| typedefs | 9 | 11 |
| accessors | 56 (all fields, both directions) | on demand (about 35) |
