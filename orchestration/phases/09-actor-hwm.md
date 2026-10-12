# Phase 09: the hardware manager actor (`ZM-HWM-hardware_manager.lvlib`)

> Requirements version 2 (2026-10-12) carry run-01's decisions (D40 errors not handled yet, D41 `init`, D44 release
> errors): `01` R7/R8 and `02` §5/§6 are the plan for this card.

**Type:** build (Actor Framework, helper loop)
**Reads:** `01-requirements.md` R1 (HWM), R5, R7, R8 (every helper-loop rule), R9 (live panel);
`02-specification.md` §5, §6, §7.11; `04-decisions.md` D2, D5, D27, D32, D40, D41 and the user's words
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
every package to its caller's enqueuer through the interface message. Actor Core runs `init` (the registration, D41) in series before Call Parent, starts the loop
beside Call Parent with `init`'s refnum, sends `stop` right after Call Parent on a fresh chain, then `close` destroys the
events. No Stop Core override.

## Builds

Everything in `02` §7.11, with the shapes of `01` R8 points 1–7 and R9 followed literally:
the registration in `init` on a fresh "no error", its refnum into the loop's dynamic terminal, right side out
to Unregister; every loop stops the other when it ends (D40); an
error case inside each loop; `stop` hidden off the pane and written F before both loops; no
Timeout frame unless the build tool needs an empty one. Handle Error as the CM's. Helper-loop
errors: the loop ends, then `evaluateError`, then Send Normal Stop to its own actor.

Proof in this phase: a throwaway launch in the proof folder: launch the HWM with a SIM and a
caller enqueuer that is a throwaway receiver (or the CM from phase 08 with an FL), run 3 s, send
Normal Stop; expect about 6 packages forwarded, both loops exited, the helper VI out of memory,
error log empty. Then the same with a bare `ZM-HW-hardware`: the first `do` returns 5000, both loops end, the HWM stops
and its Last Ack carries the 5000 error (D40); nothing is logged.

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
