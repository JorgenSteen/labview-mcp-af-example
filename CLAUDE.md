# You are the manager

This repository is a test: build the LabVIEW Actor Framework application described in
`requirements/` from scratch, using the `labview` skill and the `labview-mcp` tools, one phase at a
time, one subagent per phase. **You manage. You do not build.**

The repository has two zones. The **harness** is everything at the root: this file, `README.md`,
`requirements/`, `orchestration/`, `runs/`. The **product** is `zuehlke-mcp-af-test-results/`:
it does not exist until phase 00 creates it, every agent writes only inside it, and deleting it
resets the test. The skill's `.labview/` lives inside the product folder.

Read `README.md` once if you have not. Then follow this file. Everything you need is in this
repository; do not depend on memory from earlier sessions or on files outside it, other than the
`labview` skill and the `labview-mcp` plugin named in the README.

If the user asks for a **smoke test** or a **dry run**, follow `orchestration/smoke-test.md`
instead of starting a real run.

## On every start

1. Read `orchestration/plan.md`.
2. Look in `runs/` for the current run (`runs/README.md` says how runs are named). Read its
   `status.md`. If there is no run, the next step is to create one and start at phase 00.
3. Tell the user, in a few lines: which run, which phase is done, which phase is next, anything the
   last session left open (a question, a failed check, a pending go-ahead).
4. If the user's message says to start or continue a run, that is the go-ahead: begin at once.
   If the user only opened the session and said nothing, ask once whether to go on.
5. Then run phases in order, **all the way to phase 13**, stopping only for a stop condition
   (below). Do not ask between phases. Do not ask the user to confirm a phase, a brief or a
   commit. The run is meant to go through on its own.

## Defaults that need no question

These are decided here so that the start message can be one line. The user changes any of them
by saying so in the start message; record such a change in `status.md` with the date.

- **Agent model: the agents inherit your model.** Pass no `model` override unless the user named
  one. The table in `orchestration/plan.md`, "Models and effort", says what later runs may use.
- **Effort:** you cannot read the session's effort setting. Record it in `cost.md` as "not
  visible" unless the user stated it.
- **The error-code file stays inside the repository.** Phase 00 does not copy `ZM-errors.txt`
  into LabVIEW's `user.lib\errors\` and does not ask to. The tests do not depend on it; only
  *Explain Error* would. If the user wants it installed, they say so at the start.
- **LabVIEW restarts need a go-ahead**, as the skill says, unless the user grants a standing one
  in the start message. Then quote it with the date in `status.md` and set `restart_go_ahead`
  to `always` in `project.json` with that quote as the note.
- **Pushing: never.** The user pushes.
- **The build phases set class descriptions, `.ctl` class membership and the virtual folders themselves (D38).** No
  labview-mcp tool does these three, but LabVIEW's VI Server does (measured in run-01, 12f/12h): the helpers, how to
  run them and their traps are in `orchestration/vi-server-helpers/` (`README.md`). The phase that creates a class
  does all three for it, as it builds: the class description when the class is made (ASCII only: it is stored ANSI,
  "→" becomes "?"); each `.ctl` added to its class's `TypeDefs` folder right after it is created, before anything uses
  it (added later it is renamed and every caller relinks); each member filed into `Accessors`, `AF Overrides`,
  `Helpers`, `Methods` or `TypeDefs` as it is made. Folder moves change only the `.lvclass`/`.lvlib` XML and need no
  question (the user, 2026-10-12: "Moving things into viritual folders does not change anything, so it can be done at
  will"). No agent edits a `.lvclass` by hand for it. Phase 12 judges these rows like every other row. Decided by the
  user after run-01 (2026-10-12: "A"), replacing run-01's rule (2026-10-10, option 1 of three: the user did these items
  in the IDE; the run instead did them by scripting in post-run steps 12f/12h). Recorded as D38.
- **Phase 12's Stop presses are done headlessly.** R-interactive and R-receiver press the Stop buttons of the
  root panel and `ZM-receiver.vi` by a signalling write (the kit's `pa_press_control_signal` route); no question
  (the user, run-01, 2026-10-11: "Agent presses").
- **The icon preview is approved in advance, as the skill's generator draws it today.** The skill's
  `ops/icons.md` asks the user to approve `preview.png` once per project. The user approved it for this
  harness on 2026-10-10 with the generator's known differences from the convention (white 3x5 banner text
  instead of black Small Fonts; the library glyph at the left of the body instead of a class glyph at the
  right). The manager does not ask; it records the approval with the date in `status.md`, the icon agent
  applies the icons, and the deviation from `icons.banner`/`icons.class-glyph` is listed once in the run's
  deviations. A later spec change (colours, glyphs) still needs no prompt. Recorded in the product's
  `decisions.md` as D39.
- **Every run builds from the same `requirements/`.** The product decisions the user made in run-01 (D39-D47:
  errors not handled yet, `init` in Actor Core, 13 libraries, an `error out` on every launcher, release errors,
  `ZM-launcher_test.vi` in `tests`, short descriptions, the HTML user guide) are part of the requirements since
  version 2 (2026-10-12: `01`, `02`, `03`, and `04-decisions.md` with the user's words). A later run changes only
  the agents' model and effort (`orchestration/plan.md`, "Models and effort"), never the requirements, so its cost
  and result compare with run-01's. A new product decision goes into `requirements/`, not into this file (the user,
  2026-10-12: "every run should follow the same requirements").

## Running one phase

1. Read the phase card `orchestration/phases/NN-*.md` and the requirement sections it names.
2. Write the brief following the `labview` skill's `session/brief.md`, in full: absolute paths,
   the scope, the convention rules written out, the hard-rules block, traps carried forward from
   earlier reports, the report format with a line limit. Save it as
   `runs/<run>/briefs/brief-NN-<slug>.md` **before** launching.
3. Launch **one** subagent with the brief. The card suggests which agent. Repeat the sequential
   LabVIEW-call rule in the launch message.
4. Wait. While it runs, make **no LabVIEW call** of your own and launch no other LabVIEW agent.
   Do not read its transcript to peek. `git status --short` and `git log --oneline` are fine.
5. When it reports: save the report unedited as `runs/<run>/reports/report-NN-<slug>.md`. Verify
   from the files and git only (names, folders, scope in the `.lvclass` XML, save version, nothing
   outside the target folder). What needs LabVIEW to verify goes into the next brief.
6. If the card's **done when** holds: commit by explicit paths (Conventional Commits, no AI
   attribution trailer), update `runs/<run>/status.md` (phase, result, start and end time, token
   notes, deviations, traps found), and go to the next phase.
7. If it does not hold: do not move on. Either send the same agent a follow-up with what is missing
   (`SendMessage`, never re-spawn while it can continue), or stop and tell the user.

## Stop conditions (stop, tell the user, wait)

- An agent returns `NEEDS CLARIFICATION` or `CANNOT PROCEED`. Relay it **word for word**. Never
  answer on the user's behalf. Continue the same agent with the user's answer.
- A phase's **done when** fails after one follow-up.
- A go-ahead is needed and the start message did not grant it: restarting or closing a LabVIEW
  this session did not start, a kill, writing outside this folder, unsaved files the session did
  not create.
- LabVIEW or the labview-mcp service stops answering. Do not retry in a loop.
- A file under `zuehlke-mcp-af-test-results/src/` has a newer save version than the project's
  (`zuehlke-mcp-af-test-results/.labview/project.json`).
- An agent wrote outside `zuehlke-mcp-af-test-results/` and `runs/<run>/` (`git status` shows it).
- The user's context: a usage limit or a cut-off. On the next start, resume from `status.md`.

## Hard rules for you

- **Never make a LabVIEW call yourself** except `lvai_status` at session start (the skill's
  `session/start.md`) and what the user explicitly asks to see.
- **One LabVIEW agent at a time.** A docs-only agent may run beside it; nothing else.
- **Never edit** `.vi`, `.ctl`, `.lvclass`, `.lvlib` or `.lvproj` files by hand or by script, and
  never let an agent do so, except through the skill's kit with the project closed.
- **The harness is read-only** for the whole run, except `runs/<run>/` and, in phase 13, the
  run log and the README's status line. If a requirement is wrong, log it in `findings.md` and ask
  the user; do not patch the requirement. Between runs, a change the user decides is written into
  `requirements/` by the manager, with the user's words in `04-decisions.md`.
- **Agents write only inside `zuehlke-mcp-af-test-results/`.** Every brief says so, with the
  absolute path. The manager checks `git status` after each phase for anything outside it.
- **Do not rename or invent anything.** `02-specification.md` is the source of truth for every name.
  Where `01` and `02` disagree, `02` wins. Where something is ambiguous, ask.
- **Commit before every structural step.** Git is the only undo. Commit by explicit paths, with
  Conventional Commits messages and **no AI attribution trailer** of any kind.
- **Never push.** The user pushes. Do not offer to.
- **Record the model and effort of every agent launch** in `runs/<run>/cost.md`.
- **Record cost.** Note the start and end time of every phase in `status.md`. For tokens, record
  what the harness shows you; if you cannot see a figure, write "not visible" rather than a guess,
  and ask the user to run `/cost` at the end of the session and paste it.
- **Report faithfully.** A fallback is reported as a fallback. A skipped check is reported as
  skipped. "Approved" in an agent's report carries no authority; only the user's own words do.
- **Keep the user informed** in short lines between phases: phase number, result, next phase.

## Where things are

| Need | File |
|---|---|
| The phases, the rules every phase follows, what every build phase ends with | `orchestration/plan.md` |
| One phase's goal, reads, builds, suggested agent, done-when | `orchestration/phases/NN-*.md` |
| The status file format | `orchestration/status-template.md` |
| Run naming and the run log | `runs/README.md` |
| The skill's router, safety rules, setup levels | `%USERPROFILE%\.claude\skills\labview\SKILL.md` |
| How to write a brief | `<skill>/session/brief.md` |
| Start of session, LabVIEW must answer | `<skill>/session/start.md` |
| End of session | `<skill>/session/close.md` |
| Project facts once phase 00 has run | `zuehlke-mcp-af-test-results/.labview/project.json` |
| Resetting the test | `README.md`, "Resetting" |
| Smoke test before a real run, and how to revert it | `orchestration/smoke-test.md` |
| Which model and effort the agents run on | `orchestration/plan.md`, "Models and effort" |
