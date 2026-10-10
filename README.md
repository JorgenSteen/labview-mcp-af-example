# Claude builds a LabVIEW Actor Framework app

**A full-size test of Claude Code building a LabVIEW Actor Framework application from written
requirements, with no human writing any LabVIEW code.**

This repository is a teaching and testing ground. It has two zones:

- **The harness** (everything at the root): the requirements in pure form, the orchestration that
  makes Claude Code act as a manager running one subagent at a time, and a log of every run.
- **The product** (`zuehlke-mcp-af-test-results/`): the LabVIEW code the run produces. It is laid
  out as a normal LabVIEW repository on its own. It does not exist until a run starts, and deleting
  it resets the test.

> **Status: not yet run.** The harness is in place. The product folder will appear when the first
> run starts. See `runs/README.md` for the run log.

---

## Read this before you start a run

**This is a big test. It is not a demo.**

- **Time.** The original pilot, built with the same tools, took sessions over five calendar days
  (2026-09-26 to 2026-09-30). Expect many hours of wall-clock time across several Claude Code
  sessions. The build has 14 phases; most end with tests run inside LabVIEW.
- **Tokens.** The `labview` skill is deliberately detailed: it reads conventions, verifies, sweeps and
  re-checks at almost every step. Every phase launches a subagent with a full brief. Expect a large
  token spend. The run log in `runs/` records the actual spend per phase so the next person knows.
- **It touches your machine.** The run writes `.vi`, `.lvclass`, `.lvlib` and `.lvproj` files in
  the product folder, opens and closes LabVIEW projects, runs VIs, opens UDP port 61557 on
  localhost, and may ask to copy an error-code file into your LabVIEW installation's
  `user.lib\errors\` folder and to restart LabVIEW. It asks before anything outside this folder.
- **It will stop and ask.** The requirements say "do not invent anything; if something is ambiguous,
  ask". The manager relays every subagent question to you word for word and waits.
- **It can fail.** That is part of the test. Failures are recorded in the run log with evidence, not
  hidden.

If you only want to *look*, read `requirements/` and `orchestration/plan.md`. Nothing happens until
Claude Code is started in this folder and you confirm the first phase.

---

## What gets built

A small LabVIEW Actor Framework application, prefix `ZM`, project `Zuehlke MCP.lvproj`:

- Simulated hardware produces a measurement package every 500 ms.
- A tree of three actors (root, hardware manager, communication manager) moves the package through
  one interface message.
- The root routes each package by its destination.
- Two output protocols: a JSON Lines file per package type, and a UDP stream a separate viewer VI
  can show live.
- One error-handling plan, one custom error code, no configuration files.

Target environment: **LabVIEW 2026 Q3, 32-bit**, Actor Framework from `vi.lib`, plain test VIs
(no test framework). Expected size: 14 libraries, 13 classes, 1 interface, 1 message class,
7 test VIs, roughly 150 VIs.

The full statement is `requirements/01-requirements.md`. The inventory of every name is
`requirements/02-specification.md`. The definition of done is `requirements/03-acceptance.md`.

---

## Repository layout

```
<this repository>/                     THE HARNESS
  README.md                            this file
  CLAUDE.md                            the manager's instructions; Claude Code loads it automatically
  requirements/                        the input, pure and unchanged (read-only during a run)
    README.md                          what each requirements file holds, and the kickoff prompt
    01-requirements.md                 what to build and why
    02-specification.md                the source of truth: every library, class, field, VI, terminal
    03-acceptance.md                   7 test VIs, 8 runs, the structural checks
    04-decisions.md                    the decided rules and the design decisions with reasons
    05-skill-alignment.md              what changed from the original pilot; expected differences
    assets/                            error-code file, error catalogue, JSONL viewer, reference icons
    ZM-requirements-export.zip         the archive these files came from
  orchestration/                       how the build is run
    plan.md                            the two zones, the phase list, the rules, models and effort
    phases/NN-<name>.md                one card per phase: goal, what to read, what to build, done when
    smoke-test.md                      a short run to prove the basics, and how to revert it
    status-template.md                 the per-run status file the manager keeps up to date
  runs/                                one folder per build attempt: status, briefs, reports, cost
    README.md                          the run log and how it is kept

  zuehlke-mcp-af-test-results/         THE PRODUCT (created by phase 00; absent until then)
    README.md                          what the application is and how to open it
    .gitignore                         output/, LabVIEW per-user files, the proof folder
    .labview/                          the labview skill's conventions, decisions, checks
    src/                               Zuehlke MCP.lvproj and every library, class and VI
    docs/error-codes.md                the custom error catalogue the code keeps current
    tools/jsonl_viewer.html            drop an output/<type>.jsonl file on it to graph it
    output/                            run-time output (JSONL files, error log); git-ignored
    proof/                             throwaway measurements; git-ignored
```

Where the requirements say `<project folder>`, they mean the product folder. Where the `labview`
skill says `<repo>`, it also means the product folder: the skill's `.labview/` lives there, and
the paths in it for briefs, status and reports point up into `runs/<run>/`.

---

## Prerequisites

| Need | Where it comes from |
|---|---|
| LabVIEW 2026 Q3, 32-bit, with the Actor Framework | NI |
| Claude Code | https://claude.com/claude-code |
| The `labview-mcp` plugin (the `lvai_*` and `pylv_*` tools and its LabVIEW agents) | Claude Code plugin marketplace `zuehlke-labview`, plugin `labview-mcp` (the pilot used 1.8.5) |
| The `labview` skill | https://github.com/JorgenSteen/labview-mcp-skills, linked as `%USERPROFILE%\.claude\skills\labview` (see its README) |
| git | needed from phase 00: the skill treats git as the only undo |

**Models.** The manager and the agents can run on different models. Run the manager on the
strongest model available (the setup was made with Fable 5.1); it must keep briefs, reports and
traps straight across sessions. The agents inherit the manager's model unless you say otherwise
when the manager asks at the start. The first run should use the strongest model everywhere, so a
failure points at the toolchain and not at the model. Later runs can put the agents on a cheaper
model such as Opus and compare the cost log. Details: `orchestration/plan.md`, "Models and effort".

**Before a real run**, do the smoke test in `orchestration/smoke-test.md`: it proves the manager,
the brief, one agent launch and the revert, in minutes, and leaves nothing behind.

---

## How to run it

1. Tag the clean state first, so a failed start can be put back with one command:
   `git tag pre-run-01`.
2. Open a terminal in this folder and start `claude` on the strongest model, effort high.
3. Paste this as the first message:

   ```
   Start run-01.
   ```

   That is the whole go-ahead. The manager runs every phase through to the end without asking
   between them. Everything else is a default in `CLAUDE.md` ("Defaults that need no question"):
   agents inherit the manager's model, the error-code file stays in the repository, LabVIEW is
   not restarted without asking, nothing is pushed. Change a default by adding it to the message,
   for example `Start run-01. Agents on opus. You may restart LabVIEW when needed.`

   To only prove the basics first:

   ```
   Smoke test, level 2. I tagged pre-smoke.
   ```

4. The manager reads `CLAUDE.md`, `orchestration/plan.md` and `runs/`. It tells you which run is
   current and which phase is next, then writes a brief for the phase, saves it under
   `runs/<run>/briefs/`, launches one subagent, and waits. You can watch, or leave it.
5. When the agent reports, the manager verifies the result from the files (no LabVIEW call),
   commits, updates `runs/<run>/status.md`, and starts the next phase.
6. It stops for: a question from an agent, a failed phase, a go-ahead it needs from you (restarting
   LabVIEW, writing outside this folder), or the end of the plan.
7. To pause, stop the session. To resume, start `claude` again and say `Continue run-01.` The
   status file says where to pick up.

The phases, in order (details in `orchestration/plan.md`):

| # | phase | proves |
|---|---|---|
| 00 | session start, git, the product folder, skill setup, empty project | LabVIEW answers; `.labview/` exists; `Zuehlke MCP.lvproj` opens |
| 01 | packages `ZM-PC` | T1 Pass |
| 02 | common utilities `ZM-CU` | T2 Pass |
| 03 | hardware `ZM-HW` + simulated `ZM-HW-SIM` | T3 Pass |
| 04 | protocol parent `ZM-CP` + file logger `ZM-CP-FL` | T4 Pass |
| 05 | UDP transport `ZM-CP-UDP` + multi protocol `ZM-CP-MX` | T5 Pass |
| 06 | pipeline test, no actors | T6 Pass |
| 07 | interface `ZM-CI` + its one message | message class loads, dependency rule holds |
| 08 | communication manager actor `CM` | launches, publishes, stops clean |
| 09 | hardware manager actor `HWM` | helper loop runs, chart moves, stops clean |
| 10 | root actor `ROOT` | T7 Pass; tree launches and stops from the panel |
| 11 | launchers + receiver | headless launcher returns the counts |
| 12 | runs, structural checks, cold sweep | every row of `03-acceptance.md` |
| 13 | close: compare with the original, report, hand-over, tag | status file, run log, final commit |

Classes come first and are proven by tests before any Actor Framework code exists, so a failure in
the actor phases is an actor problem, not a class problem. That order is a requirement
(`01-requirements.md` §4), not a preference.

---

## Reading the result

- `zuehlke-mcp-af-test-results/src/` is the code. Open `Zuehlke MCP.lvproj` there in LabVIEW
  2026 Q3 32-bit. The folder's own README says how to run the launchers.
- `runs/<run>/status.md` is the story of the run: what was built, what passed, what failed, how long
  each phase took and what it cost.
- `runs/<run>/briefs/` are the exact instructions each subagent received. They are the best place to
  see how the manager thinks.
- `runs/<run>/reports/` are the agents' own reports, unedited.
- `runs/<run>/comparison.md` says where the result differs from the original pilot.
  `requirements/05-skill-alignment.md` lists the differences that are *expected*; any other
  difference is a finding.

---

## Resetting

Every run starts from no product at all, so a reset is a delete:

1. Make sure the last run is closed (phase 13 tags its final commit `run-NN-result`). If it is not
   closed, tag the current commit yourself so the code stays reachable.
2. Delete `zuehlke-mcp-af-test-results/` and commit the deletion.
3. Start `claude`. The manager sees no product folder and no open run, and offers phase 00 of a
   new run.

The run folder under `runs/` is never deleted; it is the record. The finished code of every run is
reachable through its tag.

**Want the product as a repository of its own?** The product folder is self-contained, so
`git subtree split --prefix=zuehlke-mcp-af-test-results` yields a standalone repository whose
history holds only the code commits. That is a normal LabVIEW repo with no harness in it.

---

## Why it is organised this way

A single Claude session that makes its own LabVIEW calls fills its context in about one library.
A session that only manages, briefing one agent per step and reading reports, finished four
libraries, a measurement and the icons in the pilot. So the manager never touches LabVIEW; the
agents do, one at a time, because LabVIEW is a single global instance and two callers break it.

The requirements are kept pure, with no toolchain notes, routes or helper VIs, so that the test
measures what the skill and the tools can do from a specification alone. The product is kept in
one folder, with nothing of the harness inside it, so that it can be thrown away and rebuilt, or
lifted out as a repository of its own.
