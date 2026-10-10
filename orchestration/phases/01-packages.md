# Phase 01: packages (`ZM-PC-packages.lvlib`)

**Type:** build
**Reads:** `01-requirements.md` R2, R6; `02-specification.md` §2, §3, §3.1, §4, §7.1;
`03-acceptance.md` T1; `04-decisions.md` D1, D3, D4, D10, D22.
**Scope:** `zuehlke-mcp-af-test-results/src/common/ZM-PC-packages/`, `zuehlke-mcp-af-test-results/src/tests/`, the project file.
**Suggested agents:** class-generator for the three classes and their typedefs (step a, "no test
hand-off"; accessors only as listed in `02` §7.1); a VI agent for the methods (step b); a VI agent
for the test (step c).

## Goal

The package hierarchy: `ZM-PC-package` (timestamp, type, destination; dynamic-dispatch `init` and
`getDataAsJson`), `ZM-PC-TP-test_package` (the five-field data cluster) and
`ZM-PC-EP-error_package` (sender, code, source), with the typedefs `02` §7.1 lists and the
`getTypeName` / `getDestinationName` / `getTimestampString` / `getHeader` members. The package owns
its JSON; nothing outside looks inside.

## Builds

Every library, class, typedef, field, VI and terminal of `02` §7.1, with the kinds and scopes
given there. Each child's `init` calls the parent, then sets its own type. The JSON shape of
`01` R6 with the fixed keys of D4. Timestamp ISO 8601 UTC with milliseconds, locale-independent.

Test: `zuehlke-mcp-af-test-results/src/tests/ZM-TST-packages.vi` in `ZM-TST-tests.lvlib` (create the test library in this
phase), the checks of T1, `Pass` = AND. JSON compared after unflattening, never as a string.

## Done when

- Every item of `02` §7.1 exists under its name, kind and scope; nothing else exists.
- `ZM-TST-packages.vi` runs, `Pass` true, `error out` clean.
- The library references neither the Actor Framework nor any other `ZM` library.
- The ending steps of `plan.md` (project, descriptions, cleanup, icons, cold check, save version)
  done, and committed: `feat(pc): package hierarchy with JSON output` + `test(pc): ...`.

## Notes

- The type enum is written only by `init`; the rest of the code names a type only through
  `getTypeName` (D1).
- A decimal comma in the timestamp fails T1: the format must not depend on the locale.
- The class-generator makes all accessors by default; the brief lists exactly the ones `02` §7.1
  names and in which direction, and tells it to make no others.
