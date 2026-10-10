# Run status: run-NN-<yyyy-mm-dd>

state: open            # open | closed
last updated: <date time> by <session id or "manual">
next phase: NN <name>
open items: none       # or: a question for the user, a pending go-ahead, a failed check

## Machine facts (from lvai_status at the start of each session, never from memory)

- LabVIEW: <version, bitness, path>
- labview-mcp: <version>
- LVAutoSave path: <path>

## Phases

| # | phase | state | started | ended | commit | result in one line |
|---|---|---|---|---|---|---|
| 00 | setup | todo | | | | |
| 01 | packages | todo | | | | |
| 02 | common utilities | todo | | | | |
| 03 | hardware | todo | | | | |
| 04 | protocol + file logger | todo | | | | |
| 05 | UDP + multi protocol | todo | | | | |
| 06 | pipeline test | todo | | | | |
| 07 | interface + message | todo | | | | |
| 08 | CM actor | todo | | | | |
| 09 | HWM actor | todo | | | | |
| 10 | ROOT actor | todo | | | | |
| 11 | launchers + receiver | todo | | | | |
| 12 | runs + structural checks | todo | | | | |
| 13 | close | todo | | | | |

state: todo | running | done | failed | skipped (say why in the result column)

## Checks (from requirements/03-acceptance.md)

| check | state | evidence |
|---|---|---|
| T1 ZM-TST-packages Pass | | |
| T2 ZM-TST-log Pass | | |
| T3 ZM-TST-hardware Pass | | |
| T4 ZM-TST-protocol Pass | | |
| T5 ZM-TST-udp Pass | | |
| T6 ZM-TST-pipeline Pass | | |
| T7 ZM-TST-routing Pass | | |
| R-normal ×3 | | |
| R-error | | |
| R-interactive | | |
| R-receiver | | |
| R-viewer | | |
| R-close-order | | |
| R-stop-reset | | |
| R-pli-failure | | |
| structural checks (03 §3), one line per row that failed | | |

## Traps carried forward

Facts the next brief must repeat, each by its content with its source (report file and section).

- (none yet)

## Deviations and fallbacks

Where the build differs from `02-specification.md`, with why, and whether the user agreed.

- (none yet)

## Side effects outside src/

Files written outside `zuehlke-mcp-af-test-results/src/` and this run's folder (error-code file into user.lib, LabVIEW
restarts, projects closed), one line each with the user's go-ahead quoted and dated.

- (none yet)

## Where the next session starts

<one paragraph: the last commit, what is half done, what to check first (lvai_status, the active
project, git status), and the first thing to do>
