# Zuehlke MCP — requirements pack

The requirements of a small LabVIEW Actor Framework application, extracted from a finished pilot
(built and verified 2026-09-26 to 2026-09-30) and **aligned with the `labview` skill's convention
defaults** (2026-10-10). Hand this folder to a fresh session so it can **recreate the application
from scratch** with the `labview` skill, and compare the result with the original.

**Version 2 (2026-10-12)** folds in the product decisions the user made during and after run-01 (D39-D47 in
`04-decisions.md`: errors not handled yet, `init` in Actor Core, 13 libraries, launcher `error out`, release errors,
`ZM-launcher_test.vi` in `tests`, short descriptions, the HTML user guide). **Every run builds from this same pack**;
runs after run-01 only change the model the agents use, so they can be compared.

| file | what it holds |
|---|---|
| `01-requirements.md` | what to build: purpose, actors, class hierarchies, interface message, routing, output format, error plan, launch/resources/stop and helper-loop rules, live views, launchers, conventions, process, out of scope |
| `02-specification.md` | **the source of truth**: libraries and dependency rule, naming, hierarchy, package/error/start-up/shutdown flows, every library, class, field, VI (kind, scope, terminals, behaviour), launchers, receiver, disk layout, expected counts |
| `03-acceptance.md` | when it is done: 7 test VIs (`Pass` + informational checks), the runs with expected values, structural checks |
| `04-decisions.md` | the **decided** rules to record in `.labview/decisions.md` (where the project deviates from or fills a gap in the skill defaults), the design decisions with reasons, the user's own words |
| `05-skill-alignment.md` | every change from the original pilot to the skill defaults, with the skill rule id — the expected differences when comparing |
| `assets/ZM-errors.txt` | the LabVIEW error-code file for code 5000 (goes to `src/errors/`, installed into LabVIEW's `user.lib\errors\`) |
| `assets/error-codes.md` | the original error-code catalogue (code 5000, ignored UDP codes 66 and 56); goes to `docs/`. Its VI names are the original's (snake_case); rename to the `02` names |
| `assets/jsonl_viewer.html` | a browser page that graphs an `output/<type>.jsonl` file (not LabVIEW; copy to `tools/`) |
| `assets/icons/preview.png`, `icon-spec.json` | the original pilot's icons, **for reference only**: the remake follows the skill's icon convention (`01` §3) |

## Conventions

The remake follows the skill's defaults for naming, layout, af-shapes, errors, icons and hygiene. When
the skill's setup asks per concern, the answer is "accept the defaults", plus the decided rules in
`04-decisions.md`. Configuration was asked already: **no configuration files** (D34).

## What is deliberately not included

The **how**: the original's toolchain rules, measured routes, helper VIs, briefs and session logs.
The skill supplies those.

## Suggested kickoff prompt

> Build the LabVIEW Actor Framework application described in this folder from scratch, in a new git
> repository. Start with `README.md`, then `01-requirements.md`, `02-specification.md` (the source of
> truth for every name), `03-acceptance.md` (definition of done) and `04-decisions.md`. Use the
> `labview` skill for every LabVIEW step. In its conventions setup, accept the defaults for every
> concern and record the decided rules of `04-decisions.md`; configuration is already answered (no
> configuration files). Do not rename or invent anything; if something is ambiguous, ask. Follow the
> build order in `01` §4: plain classes with their test VIs first, then the pipeline test, the
> interface, the actors one at a time (CM, HWM, ROOT), the launchers and the runs. Commit before every
> structural step. End each session with a status file saying what is built, which checks passed and
> where the next session starts, and report any skill gap or tool issue you hit with its evidence.
