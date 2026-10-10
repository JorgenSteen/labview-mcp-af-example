# Phase 06: the data path without actors (`ZM-TST-pipeline.vi`)

**Type:** test
**Reads:** `01-requirements.md` §4 (why this test exists); `03-acceptance.md` T6;
`04-decisions.md` D13.
**Scope:** `zuehlke-mcp-af-test-results/src/tests/`, the project file.
**Suggested agent:** a VI agent.

## Goal

Prove that hardware, package and protocol work together with no Actor Framework in the picture:
a SIM and an FL on a temp folder, `init` both, ten times `do` then `publish`, `close` both; then
the same with a bare `ZM-HW-hardware`, where the first `do` returns 5000 and the loop stops before
publishing.

## Builds

`zuehlke-mcp-af-test-results/src/tests/ZM-TST-pipeline.vi` in `ZM-TST-tests.lvlib`, the two checks of T6, `Pass` = AND. No
production code is added in this phase. If the test shows a defect in a class from phases 01–05,
the fix is made in that class through the vi-editor agent or the skill's ops, and that class's
own test is run again.

## Done when

- `ZM-TST-pipeline.vi` runs, `Pass` true.
- Every test of phases 01–05 still passes (run them all; they are quick).
- Committed: `test: pipeline without actors`.

## Notes

- From here on, a failure in the actor phases is an actor problem, not a class problem. That is
  the point of this phase (`01` §4).
- Clean Up Diagram and icon for this one VI as usual.
