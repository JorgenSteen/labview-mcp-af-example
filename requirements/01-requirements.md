# Zuehlke MCP — requirements

What is to be built and why. The exact inventory (every name, field, method, terminal) is in
`02-specification.md`; how it is proven is in `03-acceptance.md`. Where this file and `02` disagree,
`02` wins.

**Conventions.** The project follows the `labview` skill's convention defaults (naming, layout,
af-shapes, errors, icons, hygiene) everywhere, except the rules listed as **decided** in
`04-decisions.md`. When the remake's skill setup writes `.labview/conventions/`, it takes the defaults
and records those decided rules. Configuration was asked: **no configuration files** (D34).

## 1. Purpose

A small LabVIEW **Actor Framework (AF)** application, prefix **`ZM`**, LabVIEW project
**`Zuehlke MCP.lvproj`**. It moves simulated measurement data from a hardware object, through a tree
of three actors, to one or more output protocols (a JSON Lines file per package type, and a UDP
stream that a separate viewer VI can show live). It must have a clean dependency structure and a
consistent naming, layering and error-handling scheme that can serve as a template.

Environment: **LabVIEW 2026 Q3, 32-bit**, Actor Framework from `vi.lib`. Tests are **plain test VIs**
(no Caraya, LUnit or VI Tester).

## 2. Functional requirements

### R1 Actors

| actor | abbr | role |
|---|---|---|
| root | `ROOT` | Launched by a launcher VI with its pre-launch settings. Launches the two managers from its Actor Core (CM first, then HWM). Receives every data package and **routes it by its destination** (R5). Shows error packages on its panel. Its panel's **Stop** button stops the whole application. |
| hardware manager | `HWM` | Owns a hardware object (from its pre-launch settings). A helper loop calls the hardware every **500 ms** (init before the loop, `do` in the loop, close after the loop) and sends each package to its own actor, which forwards it to its caller. Shows a live chart. |
| communication manager | `CM` | Owns a communication-protocol object (from its pre-launch settings), initialises it in Pre Launch Init, hands every package it receives to it for publishing, and closes it in Stop Core. |

- **Root may depend on anything. HWM and CM must never depend on each other** (nor on the root).
  A child talks up only through the interface (R5).
- **Only the root knows the concrete hardware and protocol child classes.** It injects them through
  each manager's pre-launch settings. HWM knows only the hardware parent class, CM only the protocol
  parent class.
- No base actor: the three actors inherit `Actor` directly.

### R2 The package hierarchy (plain classes)

- Parent `ZM-PC-package`: a **timestamp** and a **type** enum, written by a dynamic-dispatch `init`;
  a **destination** enum set by whoever creates the package; a dynamic-dispatch `getDataAsJson`.
- `ZM-PC-TP-test_package`: data = a cluster of **five data types**: `temperature_c` DBL,
  `sample_index` I32, `duty_percent` U8, `sensor_ok` Boolean, `status` String.
- `ZM-PC-EP-error_package`: data = `{sender: String, code: I32, source: String}`.
- Each child's `init` override **calls the parent, then sets its own type**. The only VI the rest of
  the code uses to name a type is `ZM-PC-getTypeName` (and `getDestinationName` for destinations).
- **The package owns its conversion to JSON.** Nothing outside the package class looks inside a
  package's data to serialise it.

### R3 The hardware hierarchy (plain classes)

- Parent `ZM-HW-hardware`: `init`, `do`, `close` as dynamic dispatch. `init`/`close` do real work
  (an `initialized` flag; `close` is where real hardware is put into a safe state); `do` is a
  **placeholder that returns error 5000**.
- `ZM-HW-SIM-simulated_hardware` (own library, pluggable): `do` returns a test package with random
  values, addressed to `Communication`.

### R4 The protocol hierarchy (plain classes)

- Parent `ZM-CP-communication_protocol`: `init`, `publish`, `close`. `init`/`close` do real work (an
  `opened` flag); `publish` is a **placeholder that returns error 5000**.
- Each concrete protocol is **pluggable, in its own library** depending on the parent's library:
  - `ZM-CP-FL-file_logger`: **one JSON Lines file per package type**, `<output folder>/<type>.jsonl`,
    opened, appended and closed per write (always flushed; the file analogue of one MQTT topic per
    type).
  - `ZM-CP-UDP-sender` and `ZM-CP-UDP-receiver` (one library, two ends of one transport): the sender
    sends **one JSON line per UDP datagram**, unicast to `127.0.0.1:61557` (defaults; no configuration
    files). Sending to nobody is silent. The receiver is the reading side used by the receiver VI; it
    does **not** override `publish` (publishing through a receiver returns 5000, and that is correct).
  - `ZM-CP-MX-multi_protocol`: a **composite** holding an array of protocols; `init`, `publish`,
    `close` go to every element in order; an element's error stops the loop and is returned.
- The root gives the CM an MX holding `[file logger, UDP sender]`. The CM does not change when
  protocols are added.

### R5 One interface message carries every package

- One LabVIEW **interface** `ZM-CI-package_handler` (own library) with one method
  `ZM-CI-handlePackage(package: ZM-PC-package)`, and one message class generated from it by Message
  Maker. It is the **only** message class in the application.
- All three actors implement the interface and override that method. An actor sends upward to its
  **caller's enqueuer** with the interface message, so it never knows the actor above it.
- The interface passes the generic package and has **no logic**. What happens to a package is each
  actor's choice, reading the content through the package class.
- **Errors travel the same way, as error packages** — no second interface method or message. (The path
  is built; under D40 no actor sends an error package yet, R7.)
- Path: HWM helper loop → HWM (own queue) → ROOT → CM → protocol object.
- Behaviour per actor:
  - **HWM**: counts and forwards every package to its caller. A failed send to the caller (during
    shutdown) ends in Clear Errors.
  - **CM**: hands every package to its protocol (`publish`), counts it.
  - **ROOT** switches on the **destination**:

    | destination | ROOT does |
    |---|---|
    | `Communication` | note the package type (last type + count), then forward to the CM if the CM is running |
    | `Root` | `ErrorPackage` → show it on the panel (and if the sender is `CM`, mark the CM not running so nothing more is forwarded); any other type → note the type |
    | `Unknown`, `Hardware` | not forwarded; one note in the error log `ROOT\t0\tdropped <type> for <destination>`; not an error |

- The SIM addresses its packages to `Communication`; the error-package constructor addresses error
  packages to `Root`.

### R6 Output format

- JSON, produced only by the package's `getDataAsJson`:
  `{"timestamp":"2026-09-28T12:34:56.789Z","type":"TestPackage","destination":"Communication","data":{"temperature_c":…,"sample_index":…,"duty_percent":…,"sensor_ok":…,"status":"…"}}`.
  The JSON keys are fixed (they are the typedef element labels; decided D3/D4).
- Timestamp: **ISO 8601 UTC with milliseconds**, locale-independent (a decimal comma must never
  appear).
- The file line and the UDP datagram are the **same bytes**. The wire format is the JSON line, **not**
  a flattened class (so the receiver is not tied to the class version).
- About two lines per second in `output/TestPackage.jsonl` during a run.

### R7 Error handling (the user's plan, decided D40; skill `errors.*` and `af-shapes.handle-error-order`)

- **Errors are not handled yet** (D40, which replaces the original plan D14 for now): shutdown and errors are
  controlled by the normal stops.
- Every actor's `Handle Error` override **calls its parent first** (the parent treats 43, Normal Stop, as a
  normal shutdown); then `ZM-<A>-evaluateError` works on the parent's outputs. For now it is a
  **pass-through**: no log, no error package, no clearing.
- So an error stops its actor, its Last Ack carries the error, the caller stops with it (AF default, no Handle
  Last Ack Core override), and the root's Stop Core stops the rest: **an error anywhere stops the whole tree**.
  The only clean stop is the normal shutdown from the root.
- **Helper-loop errors** (`errors.loop-errors`): the loop's error case ends the loop and every loop of the helper
  VI stops the others; after the loops the VI calls `evaluateError` and, on an error, sends Normal Stop to its own
  actor. Its `error out` is the raw error.
- The error-package path (the error package class, its constructor, the root showing an error package on its
  panel) stays built so a later plan can use it; no actor sends one yet.
- The plan is written in each actor's class description and in `decisions.md`
  (`errors.plan-required`).
- **Common error log** `ZM-CU-log.vi` (own library, no dependencies): string in,
  `<ISO UTC timestamp>\t<message>` appended to the fixed file `<project folder>\output\ZM-error_log.txt`
  (folder created if missing). Callers write `<sender>\t<code>\t<source>`. Release errors are logged
  there too: the CM's `releaseProtocol` logs the error and passes it on, and it ends in Stop Core, whose AF pane
  has no error out (D44); code 1 from a never-opened resource is cleared without a log.
- A clean stop leaves the error log **empty**.
- Errors deliberately not handled end in `Clear Errors.vi`, never unwired (`errors.ignored-errors`).
- **Parent placeholders return error 5000** (`source` = `"<VI file name>: must be overridden by a
  child class"`), so a missing override shows up as an error in tests, not as empty output.
- **Custom error codes are registered** (decided D18): range 5000–5999; each code has a row in
  `error-codes.md` (message, cause, fix, where raised) and an entry in the LabVIEW error-code file
  `src/errors/ZM-errors.txt` (both in `assets/`); every place that raises one carries a free diagram
  label `#customerror <code>`. Ignored system codes (UDP 66, 56) are listed there too.

### R8 Launch, resources, stop and the helper loops (skill `af-shapes.*`)

- **Pre-launch settings**: every actor has ONE typedef `ZM-<A>-PRELAUNCH_SETTINGS.ctl` with everything
  it needs at launch, and a public custom accessor `ZM-<A>-writePrelaunchSettings.vi`. The caller
  launches a child in its own `launch<Child>` method: fill the settings → `writePrelaunchSettings` →
  Launch Nested Actor. The launchers do the same for the root.
- **Launches** run from the root's **Actor Core**, inside its `init` method (CM first, then HWM: the CM
  enqueuer must be stored before the first package arrives), never from Pre Launch Init.
- **Resources** (user events, the protocol's file and socket) are created in **Pre Launch Init** by ONE
  member `createResources`, which cleans up whatever it created if it fails (Stop Core does not run
  after a failed Pre Launch Init).
- **Two ways to stop, both must work**: the **Stop** button on the root's panel, and the headless
  test launcher sending `Normal Stop` to the root. Shutdown cascades from the root downward.
- The root's Stop button is **Switch When Released** (not latched), reset to F by a local variable in
  its event frame, so it can also be pressed headlessly (a latch cannot be written by VI Server; a
  plain value write fires no event).
- **Helper loops** (every actor that has one):
  1. A private class member `ZM-<ABBR>-helper<Purpose>.vi`, in the class's `Helpers` folder:
     `ZM-ROOT-helperPanel.vi`, `ZM-HWM-helperAcquisition.vi`. Actor Core starts it beside Call Parent.
     It talks to its actor only through `Read Self Enqueuer` and `Send` VIs.
  2. All user events of one actor live in **one cluster typedef `ZM-<ABBR>-EVENTS.ctl`**, held in one
     private field `events` with one accessor pair. `createEvents` creates them all and does one
     `Write events`; every user does `Read events` → Unbundle By Name.
  3. **Registration in `init`** (D41): each actor with a helper loop has a private `ZM-<ABBR>-init.vi`,
     run in Actor Core in series **before Call Parent**, that does everything Actor Core sets up (ROOT:
     the launches, then the registration; HWM: the registration). It registers on a **fresh "no
     error"** and hands the refnum to the loop VI, which wires it into the event structure's **dynamic
     event terminal**; its **right-side** output goes out of the loop to `Unregister For Events`. No
     separate refnum tunnel, no wire around the event structure. So a stop sent right after Call
     Parent is never lost.
  4. **Error case inside the loop**: the loop carries its error in a shift register; Error frame →
     the loop stops; No Error frame → the loop's work. **Every loop stops the others when it ends**,
     for any reason (D40): it calls the `stop` hook, its error into Clear Errors; the event loop also
     writes the local `stop` where the VI has another loop.
  5. **The stop**: Actor Core sends the helper loop's stop user event **right after Call Parent**, on a
     fresh error chain, taking the class wire from before Call Parent. So the loop stops whenever Call
     Parent returns, for any reason.
  6. **Release**: the loop VI only unregisters. A `close` member destroys the user events, in Actor
     Core after Merge Errors(loop, stop). Actor Core returns Merge Errors(Call Parent, close).
     **ROOT and HWM therefore have no Stop Core override**; the CM's Stop Core calls its parent first,
     then releases its protocol.
  7. No Timeout frames (an empty one only where the build tool needs it).
- ROOT `helperPanel`: own panel (opens when called, closes after), `Stop` button and a multi-line
  `errors` string. Events: Stop value change → send Normal Stop to the root, keep looping; `error`
  user event (string) → append to `errors`; `stop` user event → exit.
- HWM `helperAcquisition`: **two loops in the one VI** (a local works only inside the VI that owns the
  control):
  - an **event loop** on the `stop` user event; on it, writes a local Boolean `stop` = T and exits;
  - a **producer loop** (timed work): hardware `init` before; each iteration `do` → send the package to
    itself, update the chart, `Wait (ms)` fed from an `interval set (ms)` control; exits when the local
    `stop` (read after the Wait) is T, or on error; hardware `close` after. `stop` is a hidden,
    off-pane Switch, written F before both loops start (an off-pane control keeps its last value).

### R9 Live views

- **HWM live panel**: `ZM-HWM-helperAcquisition.vi` opens its front panel when called (and closes
  after): waveform chart `live` with two plots `temperature_c`, `duty_percent`; `interval set (ms)`
  (500); `interval measured (ms)` = the difference between successive `Wait (ms)` timer outputs (first
  iteration 0). A non-test package skips the plot without disturbing the loop. The headless test run
  shows this panel too; accepted.
- **Receiver**: a plain top-level VI `src/receiver/ZM-receiver.vi`, **not an actor**, depends only on
  `ZM-CP-UDP`, `ZM-CP` and `ZM-PC`. Uses `ZM-CP-UDP-receiver` in a loop (1000 ms timeout); unflattens
  the header, and for `TestPackage` the data; shows the chart (temperature, duty), the measured interval
  between packets, the last line and a packet count. Stop is Switch When Released. It can start and
  stop at any time while the tree runs; the tree does not notice. The root's panel carries a short note
  pointing to it (the `receiver` virtual folder).
- `assets/jsonl_viewer.html` (provided, browser-only) graphs a `.jsonl` file.

### R10 Launchers

- `ZM-launcher.vi` (interactive): optional `output_folder` (empty = `<project folder>\output`); fills
  the root's pre-launch settings, launches the root, returns. The tree runs until Stop on the root's
  panel. It has an `error out` indicator, so a failed launch stays visible (D43).
- `ZM-launcher_test.vi` (headless, in the project's `tests` virtual folder, D45): deletes the two output files, launches the root (optionally with
  the placeholder hardware = the error run), waits `run_time_ms`, reads the root helper loop's
  `errors` indicator from the running VI, sends Normal Stop, waits 1 s, counts lines and returns them.
  Inputs and outputs in `02` §8.

### R11 User documentation (D47)

- `README.md` in the product folder: what the application is, how to open and run it, the folder layout.
- `docs/user-guide.html`: a user guide for a LabVIEW user who has never seen the project, one self-contained HTML
  page (inline CSS and SVG, opens offline): what the application is, the actor tree as a diagram, a **Flows**
  section with four tabbed diagrams (the launch tree; the class hierarchy; the message paths between the parts,
  the receiver included: data, stop and error; the library dependencies), how to run the launchers and the receiver, what the panels show, the output files, errors, the tests, troubleshooting, the
  folder layout. Written at the end of the build, from this pack and the built code; every name matches `02`.

## 3. Structural and convention requirements (skill defaults)

- **Naming** (`02` §2): `ZM-<ABBR>-` prefix on every hand-written file; classes and libraries
  snake_case; class member VIs camelCase; plain function VIs snake_case; typedefs UPPER_SNAKE; fields
  camelCase; overrides and Message Maker products keep their names; role members (`createResources`,
  `createEvents`, `stop`, `close`, `helper<Purpose>`, `launch<Child>`, `writePrelaunchSettings`) by the
  skill's role names.
- **Libraries**: one per actor, one for the interface, one per plain hierarchy parent, **one per
  pluggable child** (load units), one for the tests (`02` §1).
- **Dependency rule** (`02` §1): checked on the files after the build.
- **Scope**: new members private; public only when called from outside the class; protected for what
  children override or call; AF overrides protected.
- **Accessors on demand**: only those some code uses, only in the direction used, static, private
  unless needed outside; members use accessors for their own fields (no Unbundle/Bundle of the class
  wire).
- **Hook VIs**: an override's work beyond Call Parent goes into its own member VI that takes the class
  wire and the error, one job per hook.
- **Virtual folders** in every class (not on disk): `Accessors`, `AF Overrides`, `Helpers`, `Messages`,
  `Methods`, `TypeDefs` (+ `SubVIs` when needed), only when non-empty. A class's typedefs are members
  of the class. Files stay flat in the class folder.
- **Descriptions** (D46): every class and VI has one, and it is **short**: what it does and, for an actor and
  its overrides, hooks and helper loops, its error plan, in 2-4 sentences, about 400 characters at most, ASCII
  only; no decision numbers, rule IDs or spec section references, no step-by-step walk through the diagram.
- **Icons** (skill `icons.*`): each class has a template icon (a banner with its abbreviation in its
  own colour + ONE class glyph) set once on the class and applied by LabVIEW as every member's template
  layer; each VI adds its own glyph layer; each library has a banner icon. Made at the end of the step
  that adds the VIs. The look follows the skill's reference (the user's RT core actor icons), not the
  original pilot's preview.
- **Clean Up Diagram** on every VI the build generated, as the last step of each VI's work (any later
  regeneration discards the layout).
- **Tests**: a separate test library; each test VI outputs a Boolean `Pass` and `error out`; a class
  that packs or bundles data has a round-trip test (`03` §1).
- Project tree virtual folders: `common`, `hardware`, `protocol`, `actors`, `tests`, `receiver`;
  `ZM-launcher.vi` at the root, `ZM-launcher_test.vi` in `tests` (D45).
- Every VI in `src/` is runnable (not broken) with the project closed.
- Commit messages: Conventional Commits, commit by explicit paths.

## 4. Process requirements (how the user wants it built)

- **Classes first, proven by tests, before any Actor Framework.** Build and test the plain libraries
  (PC, CU, HW + SIM, CP + children), then run the whole data path without actors (pipeline test), then
  the interface, then the actors **one at a time** (CM, HWM, ROOT), each proven before the next, then
  launchers and runs. A failure in the actor phases is then an actor problem, not a class problem.
- A phase is done when its test's `Pass` is true.
- Commit before every structural step (git is the only undo).
- Each session ends with a status/hand-over file and a commit (skill `session/close.md`).

## 5. Not in scope

- Configuration files (D34): the values (output folder, UDP address and port, 500 ms interval,
  placeholder flag) are defaults and launcher inputs, passed down in pre-launch settings.
- Relaunching a stopped manager (`Handle Last Ack Core` stays AF's default).
- Two-way traffic through the CM (the destination prepares it; traffic stays one way).
- An MQTT protocol (it would be another pluggable `ZM-CP` child in its own library).
- Global events (stop, emergency stop) shared by all actors: not needed; the stop cascades by
  `Send Normal Stop`.
- Setting the chart history length (LabVIEW's default is fine).
- Handling errors beyond stopping (logging them, error packages to the caller, recovery): later (D40).
  The error-package path is built for it.
