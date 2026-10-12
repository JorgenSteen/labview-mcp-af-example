# Zuehlke MCP — decisions and why

The project follows the `labview` skill's convention defaults. This file holds what the skill leaves
to the project: the **decided** rules (the user's choices that the defaults do not cover or that the
skill asks for, e.g. the error plan), and the design decisions with their reasons. The numbers
D1–D34 are kept from the original pilot so results can be compared; decisions that were replaced by a
skill default are listed in `05-skill-alignment.md`, not here. D39-D47 were decided by the user during and
after run-01 (2026-10-10 to 2026-10-12) and belong to the requirements from version 2 on; D38 (who sets class
descriptions, typedef membership and folders, and how) is about how the build is run and lives in the harness's
`CLAUDE.md`.

When the remake's skill setup writes `.labview/conventions/` and `.labview/decisions.md`, every row
marked **decided** below goes in as a `decided` rule; everything else is `default`.

## Decided rules (record in `.labview/decisions.md`)

| # | decided rule | skill concern | why |
|---|---|---|---|
| D3 | Output: **JSON Lines, one file per package type**, `output/<type>.jsonl`, opened and closed per write | (design) | graphable, always flushed, maps 1:1 to one MQTT topic per type |
| D4 | The five data types and their **JSON keys** (typedef element labels, snake_case): `temperature_c` DBL, `sample_index` I32, `duty_percent` U8, `sensor_ok` Boolean, `status` String; header keys `timestamp`, `type`, `destination` | naming (not covered: element labels) | the keys are the output format; changing them breaks the viewer and the receiver |
| D14 | *(superseded by D40 for now)* **Error-handling plan** (the original): HWM/CM log, send an error package up, stop with a clean Last Ack (error cleared after the parent, `stop actor?` T); ROOT logs and stops with the error. Recorded in each actor's description | errors.plan-required | a manager error must not silently kill the application, and must be visible on the root's panel |
| D15 | The local log is `ZM-CU-log.vi`, fixed file `output/ZM-error_log.txt`, `<ISO UTC timestamp>\t<message>`, callers write `<sender>\t<code>\t<source>` | errors.log-local (asks the project) | simple, one file, no configuration |
| D16 | A parent method that is only a placeholder returns **error 5000**; a child override calls its parent where the parent does real work | (design) | a missing override shows up as an error, not as empty output |
| D18 | Custom codes 5000–5999, each registered (`error-codes.md`, `ZM-errors.txt`) and labelled `#customerror <code>` on the diagram where raised | (not covered) | one known place; *Explain Error* shows the text; a search finds every use |
| D34 | **No configuration files.** Output folder, UDP address/port, 500 ms interval and the placeholder flag are defaults or launcher inputs, passed down in pre-launch settings | configuration (always asked; asked 2026-10-10) | the pilot has four values; a config class hierarchy would outweigh it |
| D35 | Overrides of a parent class's or interface's method go in the class's **`Methods`** folder | layout.class-folders (no `Overrides` folder) | the skill's folder list has no place named for them; they are methods of the class |
| D36 | Top-level VIs without an owner keep `ZM-<name>.vi` (`ZM-launcher.vi`, `ZM-launcher_test.vi`, `ZM-receiver.vi`) | naming.prefix (no owner) | they belong to no actor, class or library |
| D37 | The UDP sender and receiver share one library `ZM-CP-UDP-udp_transport.lvlib` and the abbreviation `UDP` | layout.library-per-actor | two ends of one transport, always shipped together |
| D39 | Icons as the skill's generator draws them today (white 3x5 banner text; the library glyph at the left of the body standing in for the class glyph); applied without a preview prompt | icons.banner, icons.class-glyph | the user, 2026-10-10: "Approve as is ... so any clean start also does the same, without this prompt" |
| D40 | **Errors are not handled yet** (supersedes D14 for now): every `ZM-<A>-evaluateError` is a pass-through (no log, no error package, no clearing); in a helper-loop VI every loop stops the others when it ends (the `stop` hook, its error into Clear Errors; the event loop also writes the local `stop` where the VI has another loop); after the loops Merge → `evaluateError` → on an error Send Normal Stop; the loop VI's `error out` is the raw error. An error stop cascades to the whole tree through the Last Ack (AF default, no Handle Last Ack Core override); the only clean stop is the normal shutdown from the root | errors.plan-required, errors.loop-errors, af-shapes.stop-mechanism | the user, 2026-10-11: "I just want the shutdown or error to be controlled by the normal stops"; "all evaluate error should be similar for now, can add stuff later"; "if any actor stops it should cascade and stop all" |
| D41 | Each actor with a helper loop has a private static `ZM-<A>-init.vi` in Actor Core, in series before Call Parent, doing everything Actor Core sets up (ROOT: `launchCm` → `launchHwm`, then Register For Events; HWM: Register For Events); the loop VI takes the registration refnum and keeps Unregister | af-shapes.registration (replaces "right before the loop" for these actors) | a stop generated before the loop VI had registered was lost and the root's tree hung (run-01). The user, 2026-10-11: "Make a init method and call it in actor core before the core and add all init things there" |
| D42 | The project has **13 libraries** (12 shipped + `ZM-TST-tests`) | (count) | the user, 2026-10-11: "13 is right" (an earlier "14" was a counting slip) |
| D43 | Every launcher has an `error out` indicator, `ZM-launcher.vi` too; a failed launch stays visible, nothing is cleared | errors.ignored-errors | the user, 2026-10-11: "launchers should have error out indicator" |
| D44 | A release error is logged and passed on by `ZM-CM-releaseProtocol` (code 1 from a never-opened resource is cleared without a log); the CM's Stop Core ends it in Clear Errors, because AF's Stop Core has no error out | errors.release-errors | the user, 2026-10-11/12: "log, but let the error pass through"; "no error out of stop core ... if i need the error i need to log it before that" |
| D45 | `ZM-launcher_test.vi` sits in the project's `tests` virtual folder (its file stays in `src/`; it is not a member of `ZM-TST-tests.lvlib`); `ZM-launcher.vi` stays at the root | layout (project tree) | the user, 2026-10-12: "yes, move it into tests virtual folder only" |
| D46 | Descriptions are short: what it does (and an actor's error plan) in 2-4 sentences, about 400 characters at most, ASCII; no decision numbers, rule IDs or spec section references, no walk through the diagram | hygiene.descriptions | the user, 2026-10-12: "The VI desription is too long. your shorter description is good" |
| D47 | The product has a user guide, `docs/user-guide.html`: one self-contained HTML page for a LabVIEW user (`01` R11) | (deliverable) | the user, 2026-10-12: asked for user documentation "like the html one" and chose an HTML guide; "Add the making of it to the requirement" |

## Design decisions (unchanged by the skill)

| # | decision | why |
|---|---|---|
| D1 | The package's `type` enum is written by each child's `init` override after Call Parent; `getTypeName` is the only way the rest of the code names a type | readable on a graph and in a file name; one VI isolates the decision |
| D2 | Only the root knows the concrete hardware and protocol; it injects them through each manager's pre-launch settings. HWM knows only `ZM-HW-hardware`, CM only `ZM-CP-communication_protocol` | keeps the managers free of the concrete classes (now also at load level: the children have their own libraries) |
| D5 | Helper loops stop on their own signal (a user event), never "exit when `Send` fails" | a loop beside Call Parent keeps the actor's queue alive, so a failing `Send` never happens |
| D6 | Launch order CM first, then HWM | the CM enqueuer must be stored before the first package arrives |
| D7 | The tree is stopped by the root's panel Stop button **and** by the headless test launcher; both must work | what was asked; the headless launcher keeps the build verifiable |
| D10 | JSON conversion lives in the package (`getDataAsJson`, DD); the protocol never looks inside | conversion owned by the data |
| D12 | The root's helper loop is a panel loop: an event structure with the Stop button, a stop user event and an error user event | the classic shape; shows errors without polling |
| D13 | Every plain-class library has a test VI, plus a pipeline test without actors, then the actors one at a time, then the tree runs; no test framework | the build-order principle without extra tooling |
| D17 | Errors travel upward as a package (`ZM-PC-EP-error_package`) in the same interface message | the interface stays one method; a new package type never changes it |
| D22 | Every package carries a `destination` enum set by its creator; the JSON header carries it | prepares two-way traffic through the CM |
| D23 | ROOT routes by destination; the type matters only for packages addressed to Root | the address decides the route; a new package type needs no change in the root |
| D24 | On the network: one UDP datagram = one JSON line (the same bytes as the file) | not tied to the class version; well under the 65 507-byte limit |
| D25 | UDP sender and receiver are separate `ZM-CP` children; unicast, default `127.0.0.1:61557`; "no listener" errors cleared; the receiver does not publish (5000) | they open the socket differently and have different methods |
| D26 | More than one protocol through a composite `ZM-CP-MX-multi_protocol`; the root builds `[FL, UDP-sender]`; the CM is unchanged | only the root knows the children |
| D27 | The HWM helper loop shows a live chart and the measured interval | the data can be seen while running, and the timing is measured, not assumed |
| D28 | The receiver is a plain VI, not an actor | a viewer can come and go without touching the tree |
| D32 | The HWM helper loop is one VI with an event loop (stop user event) and a timed producer loop stopped by a local `stop` | one stop mechanism for every actor; matches the skill's `stop-mechanism` default |

## The user's words from the review of the original (for intent)

These shaped the skill's own defaults (`registration`, `events-typedef`, `stop-mechanism`,
`stop-site`); the helper-loop **name** now follows the skill (`helper<Purpose>`, see `05`).

- "userevents for an actor can go into a cluster together and be a typedef. Have a single accessors it
  is put in and out of."
- "have a helper loop vi that contains two VIs one is the producer of the data, it can just use local
  variable, then the other one uses user events. a stop is sent to the userevent one and then the data
  gatherer just has a control into a wait thingi."
- "What i usually do is to have a send stop event after the actor core, so if the actor core quits for
  any reason a send stop event is sent just error is ignored" — the skill keeps the place (after Call
  Parent, a fresh error chain) but merges the stop's error into `close` instead of leaving it unwired
  (`errors.ignored-errors`).
