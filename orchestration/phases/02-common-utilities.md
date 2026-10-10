# Phase 02: common utilities (`ZM-CU-common_utilities.lvlib`)

**Type:** build
**Reads:** `01-requirements.md` R7 (the common error log); `02-specification.md` §5, §7.2;
`03-acceptance.md` T2; `04-decisions.md` D15.
**Scope:** `zuehlke-mcp-af-test-results/src/common/ZM-CU-common_utilities/`, `zuehlke-mcp-af-test-results/src/tests/`, the project file.
**Suggested agent:** a VI agent (there is no class here).

## Goal

`ZM-CU-log.vi`: string in, `<ISO UTC timestamp>\t<message>` appended to the fixed file
`<project folder>\output\ZM-error_log.txt`, folder created if missing. No dependencies on any other
`ZM` library.

## Builds

The library and VI of `02` §7.2, with the terminals given there. The timestamp format is the
same as the package's (`02` §5 says which VI owns it; the log must not depend on `ZM-PC`, so the
brief states how the timestamp is produced here).

Test: `zuehlke-mcp-af-test-results/src/tests/ZM-TST-log.vi` in `ZM-TST-tests.lvlib`, the checks of T2.

## Done when

- `ZM-CU-log.vi` exists, snake_case, in its library, with a description.
- `ZM-TST-log.vi` runs, `Pass` true.
- The library has no dependency on any `ZM` library or on the Actor Framework.
- Ending steps of `plan.md` done; committed: `feat(cu): common error log` + `test(cu): ...`.

## Notes

- `<project folder>` is the product folder, so the log is
  `zuehlke-mcp-af-test-results/output/ZM-error_log.txt`; that `output/` is git-ignored.
- T2 leaves two marker lines in the log. The launcher runs delete it first (phase 11); nothing
  else has to clean it.
