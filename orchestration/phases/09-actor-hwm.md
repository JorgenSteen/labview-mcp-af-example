# Phase 09: the hardware manager actor (`ZM-HWM-hardware_manager.lvlib`)

> **D40 (2026-10-11) overrides this card where they differ:** every `evaluateError` is a pass-through, helper loops
> stop each other, an error stop cascades through the Last Ack (`CLAUDE.md`, "Errors are not handled yet";
> `plan.md`, "Rules that hold in every phase").

**Type:** build (Actor Framework, helper loop)
**Reads:** `01-requirements.md` R1 (HWM), R5, R7, R8 (every helper-loop rule), R9 (live panel);
`02-specification.md` §5, §6, §7.11; `04-decisions.md` D2, D5, D14, D27, D32 and the user's words
at the end of `04`; the skill's `ops/override.md`, `ops/helper-loop.md`,
`knowledge/actor-framework.md`, `conventions/defaults/af-shapes.md`.
**Scope:** `zuehlke-mcp-af-test-results/src/actors/ZM-HWM-hardware_manager/`, the project file.
**Suggested agents:** class-generator for the class, fields and the two typedefs
(`ZM-HWM-EVENTS.ctl`, `ZM-HWM-PRELAUNCH_SETTINGS.ctl`); a general-purpose agent following the
skill's ops for overrides, hooks and the helper loop. The helper loop is the hardest VI of the
project: give it its own step and brief.

## Goal

The HWM owns a hardware object from its pre-launch settings. Its helper loop
`ZM-HWM-helperAcquisition.vi` (one VI, two loops) calls `init` before, `do` every 500 ms in a timed
producer loop, sends each package to its own actor, updates a chart, and `close` after; an event
loop on the `stop` user event sets a local `stop` that ends the producer loop. The actor forwards
every package to its caller's enqueuer through the interface message. Actor Core starts the loop
beside Call Parent, sends `stop` right after Call Parent on a fresh chain, then `close` destroys the
events. No Stop Core override.

## Builds

Everything in `02` §7.11, with the shapes of `01` R8 points 1–7 and R9 followed literally:
registration on a fresh "no error" into the dynamic terminal, right side out to Unregister; an
error case inside each loop; `stop` hidden off the pane and written F before both loops; no
Timeout frame unless the build tool needs an empty one. Handle Error as the CM's. Helper-loop
errors: the loop ends, then `evaluateError`, then Send Normal Stop to its own actor.

Proof in this phase: a throwaway launch in the proof folder: launch the HWM with a SIM and a
caller enqueuer that is a throwaway receiver (or the CM from phase 08 with an FL), run 3 s, send
Normal Stop; expect about 6 packages forwarded, both loops exited, the helper VI out of memory,
error log empty. Then the same with a bare `ZM-HW-hardware`: one error package sent up, a clean
Last Ack, the error log holding the 5000 line.

## Done when

- Every item of `02` §7.11 exists; the class loads no concrete hardware child and nothing of the
  CM or the root.
- Both throwaway runs behave as above.
- The helper-loop checks of the skill's `ops/helper-loop.md` pass (stop reset, close order).
- Ending steps of `plan.md` done; committed: `feat(hwm): hardware manager actor with acquisition loop`.

## Notes

- `interval measured (ms)` is the difference between successive `Wait (ms)` timer outputs, first
  iteration 0 (R9).
- The chart `live` has the two plots `temperature_c` and `duty_percent`; a non-test package skips
  the plot without disturbing the loop.
- A failed send to the caller during shutdown ends in Clear Errors (R5).
