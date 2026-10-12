# The plan

How the manager (`CLAUDE.md`) turns `requirements/` into `zuehlke-mcp-af-test-results/src/`. One phase at a time, one subagent
per step, each phase proven before the next. The order is a requirement
(`requirements/01-requirements.md` §4): plain classes first, proven by tests, then the data path
without actors, then the interface, then the actors one at a time, then launchers and runs.

## Two zones

- **The harness**: `README.md`, `CLAUDE.md`, `requirements/`, `orchestration/`, `runs/`. Read by
  the manager; never written by an agent except `runs/<run>/`.
- **The product**: `zuehlke-mcp-af-test-results/`. Created in phase 00, written by the agents,
  deleted to start over. It is a complete LabVIEW repo on its own: `README.md`, `.gitignore`,
  `.labview/`, `src/`, `docs/`, `tools/`, `output/`, `proof/`. Where the requirements say
  `<project folder>`, they mean this folder. Where the skill says `<repo>`, it means this folder
  too: its `.labview/` lives here, and the run-folder paths in `project.json` point up into
  `runs/<run>/`.

## Phases

| # | card | what | proof |
|---|---|---|---|
| 00 | `phases/00-setup.md` | LabVIEW answers, git, the product folder, its `.labview/` by the skill's setup, empty project, error-code file, checks.json | product folder exists, project opens, `.labview/` complete |
| 01 | `phases/01-packages.md` | `ZM-PC-packages.lvlib`: package parent, test package, error package | T1 |
| 02 | `phases/02-common-utilities.md` | `ZM-CU-common_utilities.lvlib`: the log | T2 |
| 03 | `phases/03-hardware.md` | `ZM-HW-hardware.lvlib` + `ZM-HW-SIM-simulated_hardware.lvlib` | T3 |
| 04 | `phases/04-protocol-file-logger.md` | `ZM-CP-communication_protocol.lvlib` + `ZM-CP-FL-file_logger.lvlib` | T4 |
| 05 | `phases/05-udp-multi.md` | `ZM-CP-UDP-udp_transport.lvlib` + `ZM-CP-MX-multi_protocol.lvlib` | T5 |
| 06 | `phases/06-pipeline.md` | the data path without actors | T6 |
| 07 | `phases/07-interface.md` | `ZM-CI-common_interfaces.lvlib`: the interface and its one message | loads; dependency rule |
| 08 | `phases/08-actor-cm.md` | `ZM-CM-communication_manager.lvlib` | launches, publishes, stops clean |
| 09 | `phases/09-actor-hwm.md` | `ZM-HWM-hardware_manager.lvlib` with its helper loop | loop runs and stops clean |
| 10 | `phases/10-actor-root.md` | `ZM-ROOT-root.lvlib` with its panel loop | T7; tree starts and stops |
| 11 | `phases/11-launchers-receiver.md` | `ZM-launcher.vi`, `ZM-launcher_test.vi`, `ZM-receiver.vi` | headless launcher returns counts |
| 12 | `phases/12-runs-and-checks.md` | the 8 runs, the structural checks, the cold sweep | every row of `03` |
| 13 | `phases/13-close.md` | compare with `05`, report, hand-over, final commit | run log row filled |

A phase may be split into steps (`NN-a`, `NN-b`, ...) when one brief would exceed the skill's
40–80 lines. Each step has its own brief, agent and commit. Steps run one after the other, never
side by side. The phase's **done when** applies to the whole phase.

## Every build phase (01–11) ends with

1. The phase's VIs added to `zuehlke-mcp-af-test-results/src/Zuehlke MCP.lvproj` under the right virtual folder (`common`,
   `hardware`, `protocol`, `actors`, `tests`, `receiver`), and every class with its virtual
   folders (`Accessors`, `AF Overrides`, `Helpers`, `Messages`, `Methods`, `TypeDefs`), only when
   non-empty, each member filed as it is made and each `.ctl` made a class member right after it is created
   (`orchestration/vi-server-helpers/`; `CLAUDE.md`, D38). Files stay flat in the class folder on disk.
2. A short description on every VI (`hygiene.descriptions`; `CLAUDE.md`, "Descriptions are short"), written in the AIXML. A **class** description is set
   when the class is made, by the VI Server helper (`orchestration/vi-server-helpers/`; ASCII only). Each actor's
   description states
   its error plan.
3. The phase's test VI in `ZM-TST-tests.lvlib` with `Pass` and `error out`, listed in
   `zuehlke-mcp-af-test-results/.labview/checks.json`, and run: `Pass` true.
4. Clean Up Diagram on every VI the phase generated, as the last thing done to that VI
   (`hygiene.cleanup-diagram`; a later regeneration discards it).
5. Icons for the phase's classes, VIs and library (`icons.*`; the skill's `ops/icons.md`). The look
   follows the skill's reference, not `requirements/assets/icons/preview.png`. The preview approval the
   op asks for is given in advance (`CLAUDE.md`, "The icon preview is approved in advance"); no prompt.
6. A cold check: every VI of the phase runnable with the project closed (`ops/sweep.md`, scoped to
   the phase's files).
7. The save version of every written file equals `zuehlke-mcp-af-test-results/.labview/project.json` `save_version`.
8. A commit by explicit paths, Conventional Commits (`feat(pc): ...`, `test(pc): ...`), no AI
   attribution trailer.

If any of these cannot be done, the report says so and the manager decides: follow up, or record a
deviation in `status.md` and ask the user.

## Rules that hold in every phase

- **Names come from `02-specification.md`**, nothing else. `02` wins over `01`. A name that is not
  in `02` is not invented; the agent asks.
- **Conventions** are the skill's defaults plus the decided rules in `04-decisions.md`, as written
  into `zuehlke-mcp-af-test-results/.labview/conventions/` in phase 00. Every brief writes out the rules that apply; an agent
  never gets "read the conventions file" as its only instruction.
- **Dependency rule** (`02` §1): PC, CU, HW*, CP* never reference the Actor Framework; HWM and CM
  never reference each other, the root, or a concrete hardware or protocol child.
- **Scope**: members private unless called from outside; protected for what children override or
  call; AF overrides protected. **Accessors on demand**: only the ones code uses, in the direction
  used, static.
- **Errors are not handled yet (D40, the user, 2026-10-11; `CLAUDE.md`, "Errors are not handled yet")**: every
  `ZM-<A>-evaluateError.vi` is a pass-through (no log, no error package, no clearing); in a helper-loop VI every loop
  stops the others when it ends, and the loop VI's `error out` is the raw error; an error stop cascades to the whole
  tree through the Last Ack (AF default, no Handle Last Ack Core override); the only clean stop is the normal shutdown
  from the root. Where a phase card, `02` §5/§7.10-§7.12, D14 or `03` R-error says otherwise, D40 wins.
- **`init` in Actor Core (D41, the user, 2026-10-11; `CLAUDE.md`):** each actor with a helper loop runs
  `ZM-<A>-init.vi` in series before Call Parent (ROOT: launchCm, launchHwm, Register For Events; HWM: Register For
  Events); the registration refnum goes into the loop VI, which no longer registers itself.
- **A broken VI after a generate, swap or bind: remove broken wires first** (the user, 2026-10-11, run-01 10b: "the
  issue was just a wire that was not cleaned up. i would just click ctrl b to remove it, or clean up diagram. Try that
  yourself and log it"): run the skill kit's `pa_clean_member` (Remove Bad Wires, save) or Clean Up Diagram and read
  it cold again before any rebuild. Every brief carries this line.
- **Errors**: parent placeholders return 5000 with `source` = `<VI file name>: must be overridden
  by a child class` and a free label `#customerror 5000` beside the node; ignored errors end in
  `Clear Errors.vi`, never unwired.
- **Tests are plain VIs.** No Caraya, LUnit or VI Tester. Tell the class-generator agent "no test
  hand-off" or it will try to hand off to Caraya.
- **One LabVIEW caller.** One `lvai_*`/`pylv_*` call at a time, one LabVIEW agent at a time. The
  manager makes no LabVIEW call while an agent runs.
- **No hand edits** of `.vi`, `.ctl`, `.lvclass`, `.lvlib`, `.lvproj`.
- **Agents write only inside `zuehlke-mcp-af-test-results/`** and, for their report, the run
  folder. The harness is read-only to them.
- **Commit before every structural step.** The agent commits inside its phase where the skill's ops
  say so; the manager commits the phase result.
- **Time and cost** go into `runs/<run>/cost.md` after every phase.

## Suggested agents

The manager chooses. These are the fits:

| work | agent | note |
|---|---|---|
| a class, hierarchy or interface with its fields and accessors | `labview-mcp:labview-class-generator` | say "no test hand-off"; give the accessor list from `02` (it makes all accessors by default; the convention wants only the used ones) |
| a plain VI, a test VI, a launcher | `labview-mcp:labview-vi-generator` or a general-purpose agent following the skill | give the neighbour VIs whose style to follow |
| an actor: overrides, hook VIs, helper loop, user events | a general-purpose agent following the skill's `ops/override.md`, `ops/helper-loop.md`, `knowledge/actor-framework.md` | the AF shapes in `02` §6 are exact; the agent follows them literally |
| a change to an existing VI | `labview-mcp:labview-vi-editor` | it regenerates the VI: icon and layout are lost; redo step 4 and 5 after it |
| icons, cleanup, sweep, run checks | a general-purpose agent following `ops/icons.md`, `ops/cleanup.md`, `ops/sweep.md`, `ops/run-checks.md` | |
| the session's end | a general-purpose agent following `session/close.md`, or the manager itself (no LabVIEW call needed for most of it) | |

## Models and effort

The manager and the agents need not run on the same model. Each agent launch takes a `model`
override, and that is the knob for the cost of a run. The default is set in `CLAUDE.md`
("Defaults that need no question"): agents inherit the manager's model. The user changes it in
the start message, for example `Start run-02. Agents on opus.`

| role | first run (prove the route) | later runs (measure a cheaper model) |
|---|---|---|
| manager (this session) | the strongest model available (Fable 5.1 at the time of writing) | the same; the manager is a small share of the tokens |
| agents, phases 00–07 and 11–13 (classes, plain VIs, tests, sweeps) | inherit the manager's model | `opus` |
| agents, phases 08–10 (actors, helper loops) | inherit the manager's model | `opus` first; if a phase fails twice, rerun it on the manager's model and record both |
| effort | high | high; xhigh only for a phase that failed twice, noted in `cost.md` |

Rules:
- The model and effort of **every** agent launch go into `runs/<run>/cost.md` next to its tokens,
  so runs can be compared. "Inherited" is written out as the model's name.
- A run uses one model per role throughout unless a phase is rerun; a rerun on another model is
  its own row in `cost.md`.
- labview-mcp's own agents (class-generator, vi-generator, vi-editor, doc-generator) have a model
  in their definition; a `model` override on the launch still wins. Say which was used.
- Fast mode is not used for a run.

## Stop conditions

See `CLAUDE.md`. In short: a question from an agent, a failed done-when after one follow-up, a
go-ahead needed, LabVIEW not answering, a save-version violation.
