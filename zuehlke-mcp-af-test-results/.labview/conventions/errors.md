# Convention: errors
status: in force
written: 2026-10-10 by conventions/setup.md

The rules here are the policy; where Handle Error sits relative to Call Parent is in `af-shapes.handle-error-order`.

## default-policy
Without an error-handling plan from the user, errors are fail-safe:
- An error stops the actor (AF's Handle Error: `stop actor?` = T).
- Every actor shuts down its children, through AF's default propagation.
- Shutdown puts hardware into a safe state, in `close` or Stop Core (e.g. a heater is switched off).
- The error is logged locally (`log-local`).
Why: doing nothing on an error is the dangerous option. If the temperature sensor fails while a heater is on,
shutting down and switching the heater off is the safe behaviour.
source: default

## plan-required
Reporting an error up, recovering (reconnect, retry) or keeping the actor running exists only where the user has
specified an error-handling plan. The plan is recorded in `decisions.md` and in the actor's description. Never add
recovery logic on your own.
The plan of this project: HWM and CM log, send an error package (`ZM-PC-EP-error_package`, sender `HWM`/`CM`) to
the caller, and stop with the error cleared after the parent (`stop actor?` stays T) so the Last Ack is clean; ROOT
logs and stops with the error. The plan is written in each actor's class description.
Why: "a manager error must not silently kill the application, and must be visible on the root's panel"
source: decided 2026-10-10 (decisions.md#D14)

## no-plan-statement
Where there is no plan, the actor says so explicitly. Its class description, and a comment on its Handle Error (if
there is one), carry: `no error-handling plan: stop on any error`.
source: default

## log-local
Errors are logged locally, to the project's own error log. The project names its log mechanism.
The log of this project: `ZM-CU-log.vi` in `ZM-CU-common_utilities.lvlib`, fixed file `output/ZM-error_log.txt`
under the product folder, one line per call: `<ISO UTC timestamp>\t<message>`; callers write the message as
`<sender>\t<code>\t<source>`.
Why: "simple, one file, no configuration"
source: decided 2026-10-10 (decisions.md#D15)

## custom-error-codes
Custom error codes are 5000–5999. Each code is registered in `docs/error-codes.md` and `src/errors/ZM-errors.txt`,
and the diagram where it is raised carries a free label `#customerror <code>`. System codes ignored on purpose
(UDP 66, 56) are listed there too.
Why: "one known place; *Explain Error* shows the text; a search finds every use"
source: decided 2026-10-10 (decisions.md#D18)

## loop-errors
On an error, a helper loop exits, logs the error, and stops its actor (`Send Normal Stop` to itself). The actor's
children stop with it. `close` and Stop Core then put hardware into a safe state. Without a plan, nothing else
happens.
source: default

## ignored-errors
An error output that is deliberately not handled is never left unwired. It ends in `Clear Errors.vi`, which marks
"not handled on purpose". Typical cases: a queue destroyed regardless, or a stop sent to an event nobody
registered. An unwired `error out` in new code is a defect.
source: default

## release-errors
Errors from release work in Stop Core (which has no error out to its caller) go to the local log, or end in Clear
Errors when they are ignored on purpose.
source: default
