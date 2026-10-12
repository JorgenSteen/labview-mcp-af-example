# Phase 11: launchers and the receiver

> Requirements version 2 (2026-10-12) carry run-01's decisions (D40 errors not handled yet, D41 `init`, D44 release
> errors): `01` R7/R8 and `02` §5/§6 are the plan for this card.

**Type:** build (top-level VIs)
**Reads:** `01-requirements.md` R9 (receiver), R10; `02-specification.md` §8; `03-acceptance.md`
§2 (what the launcher runs must return); `04-decisions.md` D7, D25, D28, D36, D40, D43, D45, D47.
**Scope:** `zuehlke-mcp-af-test-results/src/ZM-launcher.vi`, `zuehlke-mcp-af-test-results/src/ZM-launcher_test.vi`, `zuehlke-mcp-af-test-results/src/receiver/ZM-receiver.vi`, the
project file.
**Suggested agent:** a VI agent per VI, each with the neighbour style to follow.

## Goal

- `ZM-launcher.vi` (interactive): optional `output_folder` (empty = `<project folder>\output`),
  fills the root's pre-launch settings, launches the root, returns; the tree runs until Stop. It has an
  `error out` indicator (D43).
- `ZM-launcher_test.vi` (headless, in the project's `tests` virtual folder, D45): deletes the two output files, launches the root (optionally with
  the placeholder hardware), waits `run_time_ms`, reads the root panel loop's `errors` indicator
  from the running VI, sends Normal Stop, waits 1 s, counts lines, returns them. Inputs and
  outputs exactly as `02` §8.
- `ZM-receiver.vi`: a plain top-level VI, not an actor, depending only on `ZM-CP-UDP`, `ZM-CP` and
  `ZM-PC`; a `ZM-CP-UDP-receiver` in a loop with a 1000 ms timeout, chart, measured interval, last
  line, packet count, Stop as Switch When Released.

## Builds

The three VIs of `02` §8: `ZM-launcher.vi` at the project root, `ZM-launcher_test.vi` in the `tests` virtual
folder (D45), `ZM-receiver.vi` in `receiver`. Then the product's user documentation (`01` R11, D47): bring
`README.md` up to date and write `docs/user-guide.html` from the requirements and the built code (a docs-only
step, no LabVIEW call), including its Flows section: four tabbed inline-SVG diagrams (launch tree, class
hierarchy, message paths with the receiver, library dependencies), each edge of the last checked against the
dependencies read from the built files.

## Done when

- `ZM-launcher_test.vi` with `run_time_ms` 5000 and `use_placeholder_hardware` F returns
  `lines_written` 8–11, `error_lines` 0, `ui_errors` empty, `error out` 0 (one run; the ×3 is
  phase 12).
- `ZM-launcher_test.vi` with `use_placeholder_hardware` T returns `lines_written` 0,
  `error_lines` 0, `ui_errors` empty and `error out` 1556: the tree stopped by itself (D40, `03` R-error).
- `README.md` and `docs/user-guide.html` as `01` R11 says, the Flows section with its four diagrams included; the
  guide's names match `02`.
- `ZM-receiver.vi` loads with the dependencies above and nothing else (checked from the files).
- Ending steps of `plan.md` done; committed: `feat: launchers and udp receiver`,
  `docs: readme and user guide`.

## Notes

- Top-level VIs keep `ZM-<name>.vi` (D36): they belong to no library.
- Reading the `errors` indicator from the running panel loop goes through VI Server; the brief
  names the VI and indicator exactly as `02` does.
- The receiver can start and stop at any time while the tree runs; the tree does not notice.
