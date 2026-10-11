# Phase 11: launchers and the receiver

> **D40 (2026-10-11) overrides this card where they differ:** every `evaluateError` is a pass-through, helper loops
> stop each other, an error stop cascades through the Last Ack (`CLAUDE.md`, "Errors are not handled yet";
> `plan.md`, "Rules that hold in every phase"). The placeholder-hardware readings below are judged against D40.

**Type:** build (top-level VIs)
**Reads:** `01-requirements.md` R9 (receiver), R10; `02-specification.md` §8; `03-acceptance.md`
§2 (what the launcher runs must return); `04-decisions.md` D7, D25, D28, D36.
**Scope:** `zuehlke-mcp-af-test-results/src/ZM-launcher.vi`, `zuehlke-mcp-af-test-results/src/ZM-launcher_test.vi`, `zuehlke-mcp-af-test-results/src/receiver/ZM-receiver.vi`, the
project file.
**Suggested agent:** a VI agent per VI, each with the neighbour style to follow.

## Goal

- `ZM-launcher.vi` (interactive): optional `output_folder` (empty = `<project folder>\output`),
  fills the root's pre-launch settings, launches the root, returns; the tree runs until Stop.
- `ZM-launcher_test.vi` (headless): deletes the two output files, launches the root (optionally with
  the placeholder hardware), waits `run_time_ms`, reads the root panel loop's `errors` indicator
  from the running VI, sends Normal Stop, waits 1 s, counts lines, returns them. Inputs and
  outputs exactly as `02` §8.
- `ZM-receiver.vi`: a plain top-level VI, not an actor, depending only on `ZM-CP-UDP`, `ZM-CP` and
  `ZM-PC`; a `ZM-CP-UDP-receiver` in a loop with a 1000 ms timeout, chart, measured interval, last
  line, packet count, Stop as Switch When Released.

## Builds

The three VIs of `02` §8 under the project's root (launchers) and the `receiver` virtual folder.

## Done when

- `ZM-launcher_test.vi` with `run_time_ms` 5000 and `use_placeholder_hardware` F returns
  `lines_written` 8–11, `error_lines` 0, `ui_errors` empty, `error out` 0 (one run; the ×3 is
  phase 12).
- `ZM-launcher_test.vi` with `use_placeholder_hardware` T returns `lines_written` 0,
  `error_lines` 1 with `HWM`, `5000` and the `ZM-HW-do.vi` source, `ui_errors` holding the error
  package JSON, `error out` 0.
- `ZM-receiver.vi` loads with the dependencies above and nothing else (checked from the files).
- Ending steps of `plan.md` done; committed: `feat: launchers and udp receiver`.

## Notes

- Top-level VIs keep `ZM-<name>.vi` (D36): they belong to no library.
- Reading the `errors` indicator from the running panel loop goes through VI Server; the brief
  names the VI and indicator exactly as `02` does.
- The receiver can start and stop at any time while the tree runs; the tree does not notice.
