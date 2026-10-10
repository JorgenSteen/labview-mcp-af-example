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
