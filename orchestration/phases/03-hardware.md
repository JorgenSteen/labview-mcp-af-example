# Phase 03: hardware (`ZM-HW-hardware.lvlib`, `ZM-HW-SIM-simulated_hardware.lvlib`)

**Type:** build
**Reads:** `01-requirements.md` R3, R7 (placeholders and 5000); `02-specification.md` §3.1, §5,
§7.4, §7.5; `03-acceptance.md` T3; `04-decisions.md` D16, D18; `zuehlke-mcp-af-test-results/docs/error-codes.md`.
**Scope:** `zuehlke-mcp-af-test-results/src/hardware/`, `zuehlke-mcp-af-test-results/src/tests/`, the project file.
**Suggested agents:** class-generator for the two classes (two libraries; the SIM library depends
on the parent's); a VI agent for the methods and the test.

## Goal

The hardware parent with `init`, `do`, `close` as dynamic dispatch (`init`/`close` real work on an
`initialized` flag; `do` a placeholder returning 5000), and the pluggable simulated child in its
own library whose `do` returns a test package with random values addressed to `Communication`.

## Builds

Everything in `02` §7.4 and §7.5. The placeholder `do` carries the free label `#customerror 5000`
and `source` = `ZM-HW-do.vi: must be overridden by a child class`. The SIM's random ranges are
those T3 checks: `temperature_c` in [20, 30), `sample_index` in [0, 999], `duty_percent` in
[0, 100], `status` in {ok, warm, cold}.

Test: `zuehlke-mcp-af-test-results/src/tests/ZM-TST-hardware.vi`, the checks of T3.

## Done when

- Both libraries exist; `ZM-HW-SIM-simulated_hardware.lvlib` depends on `ZM-HW-hardware.lvlib`
  and `ZM-PC-packages.lvlib` only; the parent depends on `ZM-PC-packages.lvlib` only.
- `ZM-TST-hardware.vi` runs, `Pass` true, including `placeholder_ok`.
- Ending steps of `plan.md` done; committed: `feat(hw): hardware parent and simulated child`.

## Notes

- Two libraries, not one: each pluggable child is its own load unit
  (`layout.library-per-actor`, see `05-skill-alignment.md`).
- The child's `init`/`close` call the parent, because the parent does real work there (D16).
