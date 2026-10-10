# Zuehlke MCP — decisions and why

The project follows the `labview` skill's convention defaults. This file holds what the skill leaves
to the project: the **decided** rules (the user's choices that the defaults do not cover or that the
skill asks for, e.g. the error plan), and the design decisions with their reasons. The numbers
D1–D34 are kept from the original pilot so results can be compared; decisions that were replaced by a
skill default are listed in `05-skill-alignment.md`, not here.

When the remake's skill setup writes `.labview/conventions/` and `.labview/decisions.md`, every row
marked **decided** below goes in as a `decided` rule; everything else is `default`.

## Decided rules (record in `.labview/decisions.md`)

| # | decided rule | skill concern | why |
|---|---|---|---|
| D3 | Output: **JSON Lines, one file per package type**, `output/<type>.jsonl`, opened and closed per write | (design) | graphable, always flushed, maps 1:1 to one MQTT topic per type |
| D4 | The five data types and their **JSON keys** (typedef element labels, snake_case): `temperature_c` DBL, `sample_index` I32, `duty_percent` U8, `sensor_ok` Boolean, `status` String; header keys `timestamp`, `type`, `destination` | naming (not covered: element labels) | the keys are the output format; changing them breaks the viewer and the receiver |
| D14 | **Error-handling plan**: HWM/CM log, send an error package up, stop with a clean Last Ack (error cleared after the parent, `stop actor?` T); ROOT logs and stops with the error. Recorded in each actor's description | errors.plan-required | a manager error must not silently kill the application, and must be visible on the root's panel |
| D15 | The local log is `ZM-CU-log.vi`, fixed file `output/ZM-error_log.txt`, `<ISO UTC timestamp>\t<message>`, callers write `<sender>\t<code>\t<source>` | errors.log-local (asks the project) | simple, one file, no configuration |
| D16 | A parent method that is only a placeholder returns **error 5000**; a child override calls its parent where the parent does real work | (design) | a missing override shows up as an error, not as empty output |
| D18 | Custom codes 5000–5999, each registered (`error-codes.md`, `ZM-errors.txt`) and labelled `#customerror <code>` on the diagram where raised | (not covered) | one known place; *Explain Error* shows the text; a search finds every use |
| D34 | **No configuration files.** Output folder, UDP address/port, 500 ms interval and the placeholder flag are defaults or launcher inputs, passed down in pre-launch settings | configuration (always asked; asked 2026-10-10) | the pilot has four values; a config class hierarchy would outweigh it |
| D35 | Overrides of a parent class's or interface's method go in the class's **`Methods`** folder | layout.class-folders (no `Overrides` folder) | the skill's folder list has no place named for them; they are methods of the class |
| D36 | Top-level VIs without an owner keep `ZM-<name>.vi` (`ZM-launcher.vi`, `ZM-launcher_test.vi`, `ZM-receiver.vi`) | naming.prefix (no owner) | they belong to no actor, class or library |
| D37 | The UDP sender and receiver share one library `ZM-CP-UDP-udp_transport.lvlib` and the abbreviation `UDP` | layout.library-per-actor | two ends of one transport, always shipped together |

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
