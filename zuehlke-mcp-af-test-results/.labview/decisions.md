# Decisions

Rules proposed and chosen during planning or development. Each `decided` tag in `conventions/*.md` points here.
Newest last. Never rewrite an entry; a later decision supersedes it and says so.

The numbers are kept from `requirements/04-decisions.md` (and from the original pilot) so results can be
compared; they are not consecutive on purpose. Every entry is dated 2026-10-10, the day setup wrote this file.

## D3 (2026-10-10): Output is JSON Lines, one file per package type
Rule: (design decision; no convention rule)
Chosen: JSON Lines, one file per package type, `output/<type>.jsonl`, opened and closed per write
Instead of: one file for every package type, or a file kept open for the whole run
Why: "graphable, always flushed, maps 1:1 to one MQTT topic per type"
Supersedes: nothing

## D4 (2026-10-10): The JSON keys are typedef element labels in snake_case
Rule: naming.element-labels
Chosen: the five data types and their JSON keys (typedef element labels, snake_case): `temperature_c` DBL,
`sample_index` I32, `duty_percent` U8, `sensor_ok` Boolean, `status` String; header keys `timestamp`, `type`,
`destination`, `data`; error data `sender`, `code`, `source`. Other element labels are camelCase.
Instead of: the default, which does not cover element labels (`naming.field-names` covers private-data fields only)
Why: "the keys are the output format; changing them breaks the viewer and the receiver"
Supersedes: nothing

## D14 (2026-10-10): The error-handling plan
Rule: errors.plan-required
Chosen: HWM and CM log, send an error package (`ZM-PC-EP-error_package`, sender `HWM`/`CM`) to the caller, and
stop with the error cleared after the parent (`stop actor?` stays T) so the Last Ack is clean; ROOT logs and
stops with the error. Written in each actor's class description.
Instead of: the default (no plan: stop on any error, the error passed on to the caller)
Why: "a manager error must not silently kill the application, and must be visible on the root's panel"
Supersedes: nothing

## D15 (2026-10-10): The local log
Rule: errors.log-local
Chosen: the log is `ZM-CU-log.vi` in `ZM-CU-common_utilities.lvlib`, fixed file `output/ZM-error_log.txt`
under the product folder, line `<ISO UTC timestamp>\t<message>`; callers write `<sender>\t<code>\t<source>`
Instead of: the default, which leaves the log mechanism to the project ("ask once and record the answer")
Why: "simple, one file, no configuration"
Supersedes: nothing

## D16 (2026-10-10): A placeholder parent method returns error 5000
Rule: (design decision; no convention rule)
Chosen: a parent method that is only a placeholder returns error 5000; a child override calls its parent where
the parent does real work
Instead of: a placeholder that returns nothing (empty output, no error)
Why: "a missing override shows up as an error, not as empty output"
Supersedes: nothing

## D18 (2026-10-10): Custom error codes 5000–5999, registered and labelled
Rule: errors.custom-error-codes
Chosen: codes 5000–5999, each registered in `docs/error-codes.md` and `src/errors/ZM-errors.txt`, and a free
diagram label `#customerror <code>` where raised; ignored system codes (UDP 66, 56) listed there too
Instead of: the default, which has no rule for custom error codes
Why: "one known place; *Explain Error* shows the text; a search finds every use"
Supersedes: nothing

## D34 (2026-10-10): No configuration files
Rule: configuration.no-config-files (the concern is switched off: `status: off`)
Chosen: no configuration files; output folder, UDP address and port, the 500 ms interval and the placeholder
flag are defaults or launcher inputs passed down in pre-launch settings. The configuration question was asked
and answered on 2026-10-10.
Instead of: the default (INI files per topic, a parent configuration class with one child per file, metadata)
Why: "the pilot has four values; a config class hierarchy would outweigh it"
Supersedes: nothing

## D35 (2026-10-10): Overrides of a parent's or an interface's method go in `Methods`
Rule: layout.class-folders
Chosen: overrides of a parent class's or an interface's method go in the class's `Methods` folder (no
`Overrides` folder)
Instead of: the default folder list, which names no place for them
Why: "the skill's folder list has no place named for them; they are methods of the class"
Supersedes: nothing

## D36 (2026-10-10): Top-level VIs without an owner keep `ZM-<name>.vi`
Rule: naming.prefix
Chosen: top-level VIs with no owner keep `ZM-<name>.vi` (`ZM-launcher.vi`, `ZM-launcher_test.vi`,
`ZM-receiver.vi`)
Instead of: the default `<P>-<ABBR>-` prefix, which needs an owning actor, class or library
Why: "they belong to no actor, class or library"
Supersedes: nothing

## D37 (2026-10-10): The UDP sender and receiver share one library
Rule: layout.library-per-actor
Chosen: the UDP sender and receiver share one library `ZM-CP-UDP-udp_transport.lvlib` and the abbreviation `UDP`
Instead of: the default (each pluggable child in its own library)
Why: "two ends of one transport, always shipped together"
Supersedes: nothing

## D38 (2026-10-10): What no tool does, the user does in the IDE
Rule: layout.class-folders, layout.typedef-placement, hygiene.descriptions (class part)
Chosen: class descriptions, `.ctl` class membership and `Methods`/`Helpers`/`TypeDefs` placement are done by the
user in the Project Explorer at the end of a phase; agents build the rest and list these items in their reports
Instead of: a byte-exact script outside the kit, or accepting them as deviations
Why: the user's words: "option 1 then and log that answer into the documentation to so if someone wants to try to
rerun this later, then do not need this clearification"
Supersedes: nothing

## D39 (2026-10-10): Icons as the skill's generator draws them today
Rule: icons.banner, icons.class-glyph
Chosen: the icons are generated by `make_icons.py` as it is (white 3x5 banner text, the 10x10 library glyph at
the left standing in for the class glyph; `lib_glyph` `none` for a banner-only library) and applied without a
preview prompt
Instead of: black Small Fonts banner text and a class glyph at the right (the convention's wording), or skipping
icons
Why: the user's words: "Approve as is, option 1, continue, but note this down so any clean start also does the
same, without this prompt"
Supersedes: nothing

## D40 (2026-10-11): Errors are not handled yet: evaluateError is a pass-through, helper loops stop each other
Rule: errors.plan-required, errors.loop-errors, af-shapes.stop-mechanism
Chosen: every `ZM-<A>-evaluateError.vi` (CM, HWM, ROOT) keeps its name, pane, scope and static dispatch but only
forwards class in -> out, `error in` -> `error out` and `stop actor? in` -> `out` (no log, no error package, no
clearing). In a helper-loop VI every loop stops the others when it ends, for any reason: a non-event loop calls the
`stop` hook (stop user event) with its error into `Clear Errors.vi`; the event loop writes the local `stop` = T
(only where the VI has another loop) and also calls the `stop` hook, error into `Clear Errors.vi`. After the loops:
Merge Errors -> `evaluateError` -> on an error `Read Self Enqueuer` -> `Send Normal Stop`; `error out` = the raw
merged error, so the Last Ack carries it and the caller stops by the AF default
Instead of: D14's plan (log, error package to the caller, clear after the parent so the Last Ack is clean) and a
producer loop that ends alone while the event loop keeps waiting
Why: the user's words: "have all loops close the others on error, add a send stop event after the user event loop
to, just add ignore error. and then if any other helper loop than the user event stops it sends the stop event";
"the local stop is only needed in cases where you have an additional loop"; "after the error handler run it should,
but just let it forward everything, so the stop and the error without doing anything with it. I just want the
shutdown or error to be contrpolled by the normals stops. So the evaluateError is just basicallyt empty"; "all
evaluate error should be similar for now, can add stuff later"
Cascade (the user, 2026-10-11, session 3): "if any actor stops it should cascade and stop all"; then "if the child
stops cleany then its fine that it does not cascade, but for now the ponly clean stop case should be stop from actor
core". So an error stop of the CM or HWM carries its error in the Last Ack, AF's default Handle Last Ack Core in the
caller returns it, the caller stops with it and its Stop Core stops the rest. No Handle Last Ack Core override is
built. The only clean stop is the normal shutdown sent down from the root's Actor Core/Stop Core
Supersedes: D14 (for now)

## D41 (2026-10-11): Each actor with a helper loop has an `init` method in Actor Core
Rule: af-shapes.registration, af-shapes.helper-loop-vi, af-shapes.stop-site
Chosen: `ZM-<A>-init.vi` (private, static) runs in series before Call Parent in Actor Core (class and error) and
does everything Actor Core sets up: for the HWM `Read events` -> Unbundle `stop` -> Register For Events on a fresh
"no error", the registration refnum out on its pane; for the ROOT `launchCm` -> `launchHwm` (as subVIs) and the
same registration. The loop VI takes the registration refnum as an input, wires it into its event structure's
dynamic terminal and keeps Unregister For Events after the loop. So the registration exists before Call Parent can
return, and a stop generated by the stop hook after Call Parent always reaches the loop
Instead of: Register For Events inside the loop VI right before the loop, where a stop generated before the loop VI
had registered was lost and the ROOT tree hung (finding F14, report 12a, R-pli-failure); or a registration in Pre
Launch Init
Why: the user's words: "Make a init method and call it in actor core before the core and add all init things
there. basically what you are suggestion, just collecting it in an init, not pre init method, feel free to use
subvis in it"
Supersedes: the `registration` convention's "Register For Events sits right before the loop" for actors with an
`init` (the HWM and the ROOT); `02` §6/§7.11/§7.12 where they differ
