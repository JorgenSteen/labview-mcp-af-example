# Phase 04: protocol parent and file logger (`ZM-CP-communication_protocol.lvlib`, `ZM-CP-FL-file_logger.lvlib`)

**Type:** build
**Reads:** `01-requirements.md` R4 (parent and FL), R6; `02-specification.md` §3.1, §5, §7.6,
§7.7; `03-acceptance.md` T4; `04-decisions.md` D3, D10, D16, D18.
**Scope:** `zuehlke-mcp-af-test-results/src/protocol/ZM-CP-communication_protocol/`, `zuehlke-mcp-af-test-results/src/protocol/ZM-CP-FL-file_logger/`,
`zuehlke-mcp-af-test-results/src/tests/`, the project file.
**Suggested agents:** class-generator for the two classes; a VI agent for methods and the test.

## Goal

The protocol parent with `init`, `publish`, `close` (`init`/`close` real work on an `opened` flag;
`publish` a placeholder returning 5000), and the file logger child: one JSON Lines file per package
type, `<outputFolder>/<type>.jsonl`, opened, appended and closed per write.

## Builds

Everything in `02` §7.6 and §7.7. `publish` asks the package for its JSON (`getDataAsJson`) and
its type name (`getTypeName`); it never looks into the package's data. The placeholder `publish`
carries `#customerror 5000`.

Test: `zuehlke-mcp-af-test-results/src/tests/ZM-TST-protocol.vi`, the checks of T4, including `mx_placeholder_ok`, which
needs the MX class: **T4 is written in this phase without that check and completed in phase 05**,
or the check is built against a stub the brief names. The brief says which; the status file
records it.

## Done when

- Both libraries exist with the dependency direction of `02` §1.
- `ZM-TST-protocol.vi` runs, `Pass` true for every check that does not need MX.
- Ending steps of `plan.md` done; committed: `feat(cp): protocol parent and file logger`.

## Notes

- The file line and the UDP datagram must be the same bytes later (phase 05): `publish` writes
  exactly the JSON line plus one line feed, nothing else.
- `init` creates the output folder (T4 `init_ok` proves the child ran).
