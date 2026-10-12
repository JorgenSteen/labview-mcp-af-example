# Phase 12: runs, structural checks, cold sweep

> Requirements version 2 (2026-10-12) carry run-01's decisions (D40 errors not handled yet, D41 `init`, D44 release
> errors): `01` R7/R8 and `02` §5/§6 are the plan for this card.

**Type:** sweep / verify
**Reads:** `03-acceptance.md` in full; `02-specification.md` §1, §2, §9, §10; the skill's
`ops/sweep.md`, `ops/run-checks.md`, `ops/review.md`, `ops/helper-loop.md` (its checks).
**Scope:** read-only on `zuehlke-mcp-af-test-results/src/`, apart from the side effects of opening a project (listed in the
report) and files under `zuehlke-mcp-af-test-results/output/` and the proof folder.
**Suggested agents:** a general-purpose agent for the runs (`ops/run-checks.md`); a second,
afterwards, for the structural review (`ops/review.md`, mostly from the files); the cold sweep
(`ops/sweep.md`) last. One at a time.

## Goal

Every row of `03-acceptance.md` holds on a cold LabVIEW start. Nothing is built here; defects
found go back to the phase that owns them (a fix through the vi-editor agent or the skill's ops,
then that phase's ending steps again), and the affected checks are rerun.

## Steps

1. **Runs** (`03` §2): R-normal three times, R-error, R-interactive (the user presses Stop, or a
   signalling write does), R-receiver, R-viewer (open `zuehlke-mcp-af-test-results/output/TestPackage.jsonl` in
   `zuehlke-mcp-af-test-results/tools/jsonl_viewer.html`; the user looks, or the agent reports the file is well formed),
   R-close-order, R-stop-reset, R-pli-failure. Each with its expected values, each recorded with
   evidence (the returned numbers, the log lines).
2. **Tests** T1–T7 once more, after everything, from `zuehlke-mcp-af-test-results/.labview/checks.json`.
3. **Structural checks** (`03` §3), one line of evidence per row: every VI runnable with the
   project closed, membership, the dependency rule from the files, naming, scope and accessors,
   overrides protected and calling the parent in the right order, no Stop Core on ROOT and HWM,
   the helper-loop shapes, one EVENTS typedef and one PRELAUNCH_SETTINGS typedef per actor,
   exactly one message class, no unwired `error out`, `#customerror 5000` at every raise,
   virtual folders, descriptions, icons, Clean Up Diagram, the project tree with its counts
   (`02` §10), an empty error log after a clean stop.
4. **Cold sweep** (`ops/sweep.md`) over all of `zuehlke-mcp-af-test-results/src/`.

## Done when

- Every row of `03` §1, §2 and §3 is marked pass in `status.md` with its evidence, or marked fail
  with the defect and the phase it was sent back to, and then pass after the fix.
- The run folder's `cost.md` is up to date.
- Committed: `test: acceptance runs and structural checks pass` (plus any fix commits, each by
  its own phase's message).

## Notes

- R-interactive and R-receiver need the user, or a go-ahead for a signalling write to the panel
  button; ask up front, before the agent launches.
- R-stop-reset tests nothing if done as two separate top-level runs (the VI unloads in between);
  the skill's helper-loop checks say how to call the loop twice from one caller.
- Port 61557 must be free. A busy port is reported as an environment problem, not a code defect.
