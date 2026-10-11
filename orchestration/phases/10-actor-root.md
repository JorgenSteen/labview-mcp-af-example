# Phase 10: the root actor (`ZM-ROOT-root.lvlib`)

> **D40 (2026-10-11) overrides this card where they differ:** every `evaluateError` is a pass-through, helper loops
> stop each other, an error stop cascades through the Last Ack (`CLAUDE.md`, "Errors are not handled yet";
> `plan.md`, "Rules that hold in every phase").

**Type:** build (Actor Framework, panel loop, launches)
**Reads:** `01-requirements.md` R1 (ROOT), R5 (ROOT routing table), R7, R8 (launches, Stop button,
helper loop), R9; `02-specification.md` §5, §6, §7.12; `03-acceptance.md` T7;
`04-decisions.md` D2, D6, D7, D12, D23, D26; the skill's `ops/override.md`, `ops/helper-loop.md`,
`knowledge/actor-framework.md`.
**Scope:** `zuehlke-mcp-af-test-results/src/actors/ZM-ROOT-root/`, `zuehlke-mcp-af-test-results/src/tests/`, the project file.
**Suggested agents:** class-generator for the class, fields and typedefs (`ZM-ROOT-EVENTS.ctl`,
`ZM-ROOT-PRELAUNCH_SETTINGS.ctl`); a general-purpose agent following the skill's ops for the
overrides, hooks, launch methods and the panel loop; a VI agent for T7.

## Goal

The root launches the CM then the HWM from its Actor Core (never from Pre Launch Init), injecting
the concrete classes through each manager's pre-launch settings in `launchCm` / `launchHwm`. It
routes every package by destination (`01` R5 table): `Communication` → note type, forward to the CM
if running; `Root` → an error package is shown on the panel (and a CM sender marks the CM not
running), other types noted; `Unknown` and `Hardware` → dropped with one log line. Its panel loop
`ZM-ROOT-helperPanel.vi` has the Stop button (Switch When Released, reset by a local in its event
frame), the `errors` string, the `error` and `stop` user events. Handle Error logs and stops with
the error.

## Builds

Everything in `02` §7.12. The root gives the CM an MX holding `[file logger, UDP sender]`
(D26). Only the root references `ZM-HW-SIM`, `ZM-CP-FL`, `ZM-CP-UDP`, `ZM-CP-MX`.

Test: `zuehlke-mcp-af-test-results/src/tests/ZM-TST-routing.vi`, the checks of T7 (calls the public `ZM-CI-handlePackage`
override on a ROOT object directly, no running actor).

Proof in this phase: a throwaway launcher in the proof folder launches the root with the real
settings, waits 5 s, sends Normal Stop; expect 8–11 lines in `zuehlke-mcp-af-test-results/output/TestPackage.jsonl`, an empty
error log, every Actor Core idle, both panels closed.

## Done when

- Every item of `02` §7.12 exists; the dependency rule of `02` §1 holds on the files.
- `ZM-TST-routing.vi` runs, `Pass` true.
- The throwaway launch behaves as above, twice in a row.
- The Stop button on the root's panel stops the tree (pressed by hand, or headlessly by a
  signalling write).
- Ending steps of `plan.md` done; committed: `feat(root): root actor with routing and panel loop`.

## Notes

- Launch order CM first, then HWM: the CM enqueuer must be stored before the first package (D6).
- ROOT has no Stop Core override; Actor Core returns Merge Errors(Call Parent, close).
- Errors raised before the panel loop has registered are logged but not shown; accepted (`01` §5).
