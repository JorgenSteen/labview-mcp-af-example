# Zuehlke MCP — specification (complete inventory)

The source of truth for every name, field, method, terminal and message. Requirements and rationale:
`01-requirements.md`. Every rule here follows the `labview` skill's convention defaults
(`<skill>/conventions/defaults/`) unless it is listed as **decided** in `04-decisions.md`. What changed
from the original pilot and why: `05-skill-alignment.md`.

Legend. Scope: **pub** / **prot** / **priv**. Kind: **DD** dynamic dispatch, **ST** static, **OVR**
override (of a parent's DD method, an interface method, or an AF method), **ACC** accessor (generated
`Read`/`Write`, static unless stated), **CACC** custom accessor, **HOOK** member VI called from an
override, taking the class wire and the error (a Handle Error hook also `stop actor?`), **LOOP**
helper-loop VI. Terminals list only what is beyond the class wire and the error cluster.

Skill rules applied throughout (rule ids from the skill's conventions):
- `layout.scope`: new members are **private**; **public** only when something outside the class calls
  them; **protected** for what children override or call.
- `layout.accessors-on-demand`: an accessor exists only if some code uses it, only in the direction
  used, **static**, private unless something outside needs it. The tables below list exactly those.
- `layout.accessors-for-own-data`: members read and write their own fields through accessors, never
  Unbundle/Bundle of the class wire.
- `errors.ignored-errors`: an error deliberately not handled ends in `Clear Errors.vi`, never unwired.
- `hygiene.descriptions`: every class and VI has a description; an actor's class description states
  its error-handling plan.

## 1. Layers, libraries and dependencies

```
  layer 3  application   ZM-ROOT-root                                     may depend on everything
  layer 2  managers      ZM-HWM-hardware_manager   ZM-CM-communication_manager   never reference each other
  layer 1b concrete      ZM-HW-SIM   ZM-CP-FL   ZM-CP-UDP   ZM-CP-MX       pluggable children, one library each
  layer 1a parents       ZM-HW   ZM-CI   ZM-CP                            depend only on layer 0 (+ AF for ZM-CI)
  layer 0  common        ZM-PC-packages   ZM-CU-common_utilities          depend on nothing of ours
  dev-time               ZM-TST-tests                                     the test VIs, not shipped
  external               Actor Framework.lvlib (vi.lib)
```

Each pluggable child class gets **its own library** that depends on its parent's library
(`layout.library-per-actor`: a library is a load unit, so a manager that loads only the parent must not
load every child and its toolkits; an MQTT child would pull in an MQTT toolkit). The package classes
always ship together and share one library.

| library | classes | depends on | must never depend on |
|---|---|---|---|
| `ZM-PC-packages.lvlib` | `ZM-PC-package`, `ZM-PC-TP-test_package`, `ZM-PC-EP-error_package` | LabVIEW only | anything else of ours |
| `ZM-CU-common_utilities.lvlib` | — (`ZM-CU-log.vi`) | LabVIEW only | anything else of ours |
| `ZM-CI-common_interfaces.lvlib` | interface `ZM-CI-package_handler`, its message | AF, `ZM-PC` | any actor, `ZM-HW*`, `ZM-CP*` |
| `ZM-HW-hardware.lvlib` | `ZM-HW-hardware` | `ZM-PC` | AF, any actor, `ZM-CP*`, `ZM-HW-SIM` |
| `ZM-HW-SIM-simulated_hardware.lvlib` | `ZM-HW-SIM-simulated_hardware` | `ZM-HW`, `ZM-PC` | AF, any actor, `ZM-CP*` |
| `ZM-CP-communication_protocol.lvlib` | `ZM-CP-communication_protocol` | `ZM-PC` | AF, any actor, `ZM-HW*`, its children |
| `ZM-CP-FL-file_logger.lvlib` | `ZM-CP-FL-file_logger` | `ZM-CP`, `ZM-PC` | AF, any actor, `ZM-HW*`, other `ZM-CP` children |
| `ZM-CP-UDP-udp_transport.lvlib` | `ZM-CP-UDP-sender`, `ZM-CP-UDP-receiver` (two ends of one transport, ship together) | `ZM-CP`, `ZM-PC` | AF, any actor, `ZM-HW*`, other `ZM-CP` children |
| `ZM-CP-MX-multi_protocol.lvlib` | `ZM-CP-MX-multi_protocol` | `ZM-CP`, `ZM-PC` | AF, any actor, `ZM-HW*`, other `ZM-CP` children |
| `ZM-HWM-hardware_manager.lvlib` | `ZM-HWM-hardware_manager` | AF, `ZM-CI`, `ZM-HW`, `ZM-PC`, `ZM-CU` | `ZM-CM`, `ZM-CP*`, `ZM-ROOT`, `ZM-HW-SIM` |
| `ZM-CM-communication_manager.lvlib` | `ZM-CM-communication_manager` | AF, `ZM-CI`, `ZM-CP`, `ZM-PC`, `ZM-CU` | `ZM-HWM`, `ZM-HW*`, `ZM-ROOT`, the `ZM-CP` children |
| `ZM-ROOT-root.lvlib` | `ZM-ROOT-root` | everything above | — |
| `ZM-TST-tests.lvlib` | — (the test VIs) | whatever each test exercises | — (nothing shipped depends on it) |
| `receiver/ZM-receiver.vi` (no library) | — | `ZM-CP-UDP`, `ZM-CP`, `ZM-PC` | AF, any actor, `ZM-HW*`, `ZM-CI`, `ZM-CU` |

Check: every `Send`, class constant and subVI inside a library resolves to that library, an allowed
library, `vi.lib`, or a primitive.

## 2. Naming (`naming.*` defaults)

| element | rule | example |
|---|---|---|
| every hand-written file | starts with `ZM-<ABBR>-`, `<ABBR>` = the owning actor, class or library (`naming.prefix`) | |
| class, library | `ZM-<ABBR>-<name>`, name in **snake_case** (`naming.class-library-names`) | `ZM-HWM-hardware_manager.lvclass` |
| child class | `ZM-<PARENT ABBR>-<CHILD ABBR>-<name>` | `ZM-PC-TP-test_package.lvclass` |
| class member VI (methods, hooks, helper loops, custom accessors) | **camelCase** after the prefix (`naming.method-case`) | `ZM-PC-getDataAsJson.vi` |
| plain function VI (no class) | **snake_case** after the prefix (`naming.function-case`) | `ZM-CU-log.vi`, `ZM-TST-packages.vi` |
| typedef | **UPPER_SNAKE** after the prefix (`naming.typedef-case`) | `ZM-PC-TP-DATA.ctl` |
| private-data field | **camelCase**, no prefix (`naming.field-names`) | `intervalMs` |
| override | keeps the parent's name, in the child's class folder (`naming.override-names`) | `ZM-PC-TP-test_package\ZM-PC-init.vi` |
| Message Maker products | tool names | `ZM-CI-handlePackage Msg.lvclass`, `Send ZM-CI-handlePackage.vi`, `Do.vi` |
| generated accessor | `Read <field>.vi` / `Write <field>.vi` (`naming.accessor-names`) | `Read events.vi` |
| role members (`naming.role-names`) | `createResources`, `createEvents`, `stop`, `close`, `helper<Purpose>`, `launch<Child>`, `writePrelaunchSettings`, typedefs `EVENTS`, `PRELAUNCH_SETTINGS` | `ZM-HWM-helperAcquisition.vi` |
| top-level VIs (no owner) | `ZM-<name>.vi` (**decided**: the skill names no owner for them) | `ZM-launcher.vi` |
| project | `Zuehlke MCP.lvproj` | |

Abbreviations: `ROOT`, `HWM`, `CM`, `CI` common interfaces, `CU` common utilities, `PC` package,
`TP` test package, `EP` error package, `HW` hardware, `SIM` simulated hardware, `CP` communication
protocol, `FL` file logger, `UDP` (sender and receiver share it), `MX` multi-protocol composite, `TST`
tests.

Terminal labels and typedef element labels are not covered by the skill's naming rules. The JSON keys
come from typedef element labels and are part of the output format (**decided**, `01` R6):
`timestamp`, `type`, `destination`, `data`, `temperature_c`, `sample_index`, `duty_percent`,
`sensor_ok`, `status`, `sender`, `code`, `source`. Other element labels follow the field rule
(camelCase).

**Virtual folders** (`layout.class-folders`, not on disk; files stay flat in the class folder,
`layout.flat-files`): `Accessors` (generated and custom accessors), `AF Overrides`, `Helpers`
(helper-loop VIs), `Messages` (Message Maker products), `Methods` (methods, hooks, and overrides of a
parent class's or interface's method; **decided**: the skill has no `Overrides` folder), `TypeDefs`,
`SubVIs` when needed. Only folders that hold something. A typedef that belongs to a class is a
**member of that class** in its `TypeDefs` folder, file flat in the class folder
(`layout.typedef-placement`); there is no library-level `Controls` folder.

## 3. Class and interface hierarchy

```
LabVIEW Object
├─ ZM-PC-package ──────────────── ZM-PC-TP-test_package
│                              └─ ZM-PC-EP-error_package
├─ ZM-HW-hardware ─────────────── ZM-HW-SIM-simulated_hardware
└─ ZM-CP-communication_protocol ─ ZM-CP-FL-file_logger
                                 ├─ ZM-CP-UDP-sender
                                 ├─ ZM-CP-UDP-receiver
                                 └─ ZM-CP-MX-multi_protocol   (holds an array of ZM-CP-communication_protocol)

Actor Framework.lvlib:Actor.lvclass          (no base actor: the three share little, af-shapes.base-actor)
├─ ZM-ROOT-root                 implements ZM-CI-package_handler
├─ ZM-HWM-hardware_manager      implements ZM-CI-package_handler
└─ ZM-CM-communication_manager  implements ZM-CI-package_handler

«interface» ZM-CI-package_handler        one method: ZM-CI-handlePackage.vi

Actor Framework.lvlib:Message.lvclass
└─ ZM-CI-handlePackage Msg      payload ZM-PC-package   (the only message; it crosses every actor boundary)
```

No actor has messages of its own: launches run from Actor Core and resources are created in Pre
Launch Init (§6), so no `init` message to self is needed.

### 3.1 Parent methods: real default or placeholder

| parent method | parent body | children |
|---|---|---|
| `ZM-PC-init` | real: timestamp + `type = Undefined` | TP, EP override: **Call Parent** → own `setType` hook |
| `ZM-PC-getDataAsJson` | real: header JSON | TP, EP override with their own body (header + data) |
| `ZM-HW-init`, `ZM-HW-close` | real: write `initialized` | SIM does not override |
| `ZM-HW-do` | **placeholder: error 5000** | SIM overrides |
| `ZM-CP-init` | real: write `opened` = T | FL, UDP-sender, UDP-receiver, MX: **Call Parent** → own hook |
| `ZM-CP-close` | real: write `opened` = F | UDP-sender, UDP-receiver, MX: own hook → **Call Parent**; FL does not override |
| `ZM-CP-publish` | **placeholder: error 5000** | FL, UDP-sender, MX own body; **UDP-receiver does not override** |

Error 5000: `Bundle` onto an error-cluster constant, `status T`, `code 5000`, `source`
`"<VI file name>: must be overridden by a child class"`, with a free label `#customerror 5000` next to
it (**decided**, D18).

## 4. The package path

```
 HWM helperAcquisition      HWM (Actor Core)          ROOT (Actor Core)            CM (Actor Core)     protocol (MX)
 ZM-HW-do → package
 (SIM: destination Communication)
 chart, interval
 Send ZM-CI-handlePackage ─► ZM-CI-handlePackage (HWM)
  to self                    packageCount += 1
                             Send to caller ─────────► ZM-CI-handlePackage (ROOT)
                                                       case Read destination:
                                                       ├ Root: ErrorPackage? yes → showError
                                                       │                     no  → notePackageType
                                                       ├ Unknown, Hardware: ZM-CU-log "ROOT\t0\tdropped <type> for <destination>"
                                                       └ Communication: notePackageType;
                                                         cmRunning? Send to cmEnqueuer ──► ZM-CI-handlePackage (CM)
                                                                                           ZM-CP-publish (MX) ─► each element:
                                                                                             [0] FL: append to output/<type>.jsonl
                                                                                             [1] UDP-sender: UDP Write 127.0.0.1:61557
                                                                                                  │ one datagram = one JSON line
                                                                                                  ▼
                                                                        src/receiver/ZM-receiver.vi (any time)
```

## 5. Errors

Facts this builds on (skill `knowledge/actor-framework.md`): `Send Normal Stop` makes `Do.vi` return
**43** and Handle Error runs at every normal stop; the **parent Handle Error treats 43 as a normal
shutdown, does not pass it on, and always returns `stop actor?` = T**; other errors are passed on and
stop the actor; a child's error in its Last Ack stops the caller by default. Errors in Actor Core's
own code and in helper loops never reach Handle Error.

**The error-handling plan (decided D40; it replaces the original plan D14 for now; `errors.plan-required`).**
Errors are not handled yet: shutdown and errors are controlled by the normal stops. Recorded in each actor's class
description and in `decisions.md`.

- Every `ZM-<A>-evaluateError.vi` (CM, HWM, ROOT) keeps its name, pane, scope (private) and static dispatch but is
  a **pass-through**: class in → out, `error in` → `error out`, `stop actor? in` → `out`. No log, no error
  package, no clearing.
- So an error stops its actor and its **Last Ack carries the error** to the caller; AF's default Handle Last Ack
  Core in the caller returns it, the caller stops with it, and the root's (AF) Stop Core stops the rest: **an error
  anywhere stops the whole tree.** Handle Last Ack Core is not overridden (`af-shapes.handle-last-ack`).
- The only **clean** stop is the normal shutdown sent down from the root (Stop on its panel, or Normal Stop from
  the test launcher). A clean stop leaves the error log empty.

```
 an error in a message (Do.vi)                        an error in a helper loop
  Handle Error.vi override (handle-error-order):       the loop's error case ends the loop; every loop stops
  Call Parent FIRST                                     the others (§6, "Helper loops stop each other")
    43 → cleared by the parent; other → passed on       after the loops: Merge Errors → evaluateError
  then on Call Parent's outputs:                         → on an error: Read Self Enqueuer → Send Normal Stop
          ▼                                              error out = the raw merged error
  ZM-<A>-evaluateError: pass-through (every output = its input)
          ▼
  the actor stops; its Last Ack carries the error → the caller stops with it (AF default) → the tree stops
```

- **Release errors (decided D44):** `ZM-CM-releaseProtocol` logs a release error with `ZM-CU-log`
  (`CM<tab><code><tab><source>`) and passes it on in its `error out`; code 1 from a never-opened resource is
  cleared without a log. The CM's Stop Core ends it in `Clear Errors`: AF's `Stop Core.vi` has no error terminals
  (only `final error code`), so a release error cannot reach the Last Ack.
- **The error-package path is built but not used yet:** `ZM-PC-EP-error_package`, `ZM-PC-EP-create` and the
  root's `showError` (an error package to Root → its JSON appended to the panel's `errors`; sender `"CM"` →
  `cmRunning` = F) exist, so a later error plan can send error packages without a new message. Today no actor
  sends one.
- During shutdown a package may still be in flight when the root's queue is gone: the HWM's
  `ZM-CI-handlePackage` ends a failed `Send` in `Clear Errors`.

## 6. Start-up and shutdown

Skill shapes used: `af-shapes.prelaunch-settings`, `launch-owner`, `resources`, `pli-failure-cleanup`,
`stop-mechanism`, `stop-site`, `close-vi`, `registration`, `helper-loop-error-case`, `timed-work`,
`shutdown-cascade`.

```
ZM-launcher.vi  (ZM-launcher_test.vi is the headless twin)
  ROOT-PRELAUNCH_SETTINGS {outputFolder, usePlaceholderHardware} → ZM-ROOT-writePrelaunchSettings
  → Launch Root Actor (Open Actor Core front panel? = F)

  ROOT Pre Launch Init: ZM-ROOT-createResources (createEvents; on its error → close) ; Call Parent
  ROOT Actor Core:
    init, in series before Call Parent (class and error wires; D41): launchCm → launchHwm → Register For Events
      (stop, error); a launch or registration error goes into Call Parent and stops the root
      ① launchCm: FL(outputFolder) + UDP-sender (defaults) → Build Array → MX Write protocols
         → CM-PRELAUNCH_SETTINGS {protocol: MX} → ZM-CM-writePrelaunchSettings → Launch Nested Actor
         → Write cmEnqueuer, Write cmRunning = T
           CM Pre Launch Init: createResources: protocol → ZM-CP-init (FL creates the folder, UDP opens its socket)
                               → Write protocol; on its error → releaseProtocol ; Call Parent
      ② launchHwm: SIM (or bare ZM-HW-hardware if usePlaceholderHardware)
         → HWM-PRELAUNCH_SETTINGS {hardware, intervalMs 500} → ZM-HWM-writePrelaunchSettings
         → Launch Nested Actor → Write hwmEnqueuer
           HWM Pre Launch Init: createResources (createEvents; on error → close) ; Call Parent
           HWM Actor Core: init (Register For Events: stop) → Call Parent; branch helperAcquisition (takes init's
              registration refnum) ∥ Call Parent → stop → Merge → close → Merge → error out
              producer loop: HW init → every intervalMs { do → Send to self; chart } until local stop = T or error → HW close
                → stop hook (its error → Clear Errors)
              ∥ event loop: init's registration → { stop event: stop = T (local), exit } → stop hook (error → Clear Errors)
                → Unregister
              after both loops: Merge → evaluateError → on an error Send Normal Stop to self; error out = the raw error
    branch from <C> in: helperPanel (takes init's registration refnum) ∥ Call Parent
    after Call Parent: stop (fresh error chain, class wire from before Call Parent)
    Merge(helperPanel error, stop error) → close (Destroy User Event ×2) → Merge(Call Parent error, close error) → error out
  … runs until Stop on the root's panel (or the test launcher sends Normal Stop)

  Stop pressed → helperPanel: Stop = F (local) → Read Self Enqueuer → Send Normal Stop; keeps looping
    root: Handle Error (43, cleared by the parent) → Stop Core (AF's: Normal Stop to HWM and CM) → Call Parent returns
    HWM: Call Parent returns → stop generates the stop event → event loop sets stop = T, exits
         → producer exits after its current Wait (≤ 500 ms) → helperAcquisition returns → close destroys the event
    CM:  Stop Core override: Call Parent FIRST (stop-core-order) → releaseProtocol (ZM-CP-close on the MX → UDP Close)
         → Clear Errors (a release error was logged and passed on by releaseProtocol, D44)
    ROOT: stop generates the stop event → helperPanel exits (its only event exit) → Unregister → close → panel closes
```

Rules in this shape:

- **Pre-launch settings** (`af-shapes.prelaunch-settings`): each actor owns ONE typedef
  `ZM-<A>-PRELAUNCH_SETTINGS.ctl` and a public custom accessor `ZM-<A>-writePrelaunchSettings.vi`
  (settings input required; class input optional, unwired = a default object). The caller fills the
  settings in its own `launch<Child>` method → `writePrelaunchSettings` → Launch Nested Actor.
- **Launches** run from Actor Core, inside the root's `init` (never from Pre Launch Init, which hangs;
  `af-shapes.launch-owner`).
- **Resources** (user events, the protocol's file and socket) are created in Pre Launch Init by ONE
  member `createResources`, which merges the create errors and, in the Error frame of a case on that
  error, runs the same release VIs (`close`, `releaseProtocol`) on whatever was created
  (`af-shapes.pli-failure-cleanup`: Stop Core does not run after a failed Pre Launch Init). Pre Launch
  Init calls only `createResources` (and its parent). Release VIs accept a resource that was never
  created: those errors end in Clear Errors.
- **What the helper loop uses** (its user events) is released in `close`, in Actor Core after the loop
  has exited and the stop was sent (`af-shapes.close-vi`). The loop VI does **Unregister only**, never
  Destroy. Everything else is released in Stop Core, **after** Call Parent (`af-shapes.stop-core-order`).
  A Stop Core that would only call its parent is not created: ROOT and HWM have none.
- **The stop** is sent from Actor Core right after Call Parent, on a fresh error chain; Call Parent's
  `error out` only sets the order; the hook takes the class wire from before Call Parent
  (`af-shapes.stop-site`). Actor Core returns Merge(Call Parent, close), so an error there ends the
  actor (`errors.default-policy`).
- **Registration in `init` (decided D41; it replaces `af-shapes.registration`'s "right before the loop" for the
  actors with a helper loop).** Each such actor has a private static `ZM-<A>-init.vi` that runs in series before
  Call Parent in Actor Core (class and error wires) and does everything Actor Core sets up: for the HWM `Read
  events` → Unbundle `stop` → Register For Events on a fresh "no error"; for the ROOT `launchCm` → `launchHwm` (as
  subVIs), then the same registration (stop first, error second). The registration refnum goes out on `init`'s
  pane into the loop VI, which wires it into its event structure's dynamic event terminal; the right-side output
  goes out of the loop into Unregister For Events, which runs even with an incoming error. No refnum tunnel, no
  wire around the event structure. So the registration exists before Call Parent can return, and the stop that
  the stop hook generates after Call Parent always reaches the loop (a stop generated before the loop VI had
  registered is lost, and the tree hangs).
- **Error case inside the loop** (`af-shapes.helper-loop-error-case`): the loop carries the error in a
  shift register; a case on it: Error frame → the loop stops at this iteration and passes the error
  on; No Error frame → the loop's work (event structure, or the timed work). After the loop:
  Unregister → Merge Errors → `evaluateError` → on an error `Read Self Enqueuer` → `Send Normal Stop`; `error
  out` = the raw merged error (D40).
- **Helper loops stop each other (decided D40):** in a helper-loop VI every loop stops the others when it ends,
  for any reason. A non-event loop calls the `stop` hook (the stop user event) with its error into `Clear
  Errors`; the event loop writes the local `stop` = T (only where the VI has another loop) and also calls the
  `stop` hook, its error into `Clear Errors`.
- **No Timeout frames** (`af-shapes.timed-work`); an empty one only where the build tool needs it.
- The order in which the actors stop relative to each other is not specified; nothing depends on it.

AF overrides per actor (all protected, all call their parent):

| actor | Pre Launch Init | Actor Core | Stop Core | Handle Error |
|---|---|---|---|---|
| ROOT | `createResources` ; Call Parent | `init` (`launchCm` → `launchHwm` → Register) → branch `helperPanel` ∥ Call Parent → `stop` → `close` | — | Call Parent → `evaluateError` |
| HWM | `createResources` ; Call Parent | `init` (Register) → branch `helperAcquisition` ∥ Call Parent → `stop` → `close` | — | Call Parent → `evaluateError` |
| CM | `createResources` ; Call Parent | — | Call Parent → `releaseProtocol` → Clear Errors | Call Parent → `evaluateError` |

## 7. Inventory, library by library

### 7.1 `ZM-PC-packages.lvlib` — `src/common/ZM-PC-packages/`

**`ZM-PC-package.lvclass`** (parent LabVIEW Object). TypeDefs (class members):

| file | contents |
|---|---|
| `ZM-PC-PACKAGE_TYPE.ctl` | enum U16 `{Undefined = 0, TestPackage = 1, ErrorPackage = 2}` |
| `ZM-PC-DESTINATION.ctl` | enum U16 `{Unknown = 0, Root = 1, Hardware = 2, Communication = 3}` |
| `ZM-PC-HEADER.ctl` | cluster `{timestamp: String, type: String, destination: String}` (JSON keys; strings because `Flatten To JSON` refuses an enum) |

| field | type | written by |
|---|---|---|
| `timestamp` | Time Stamp | `ZM-PC-init` |
| `type` | `ZM-PC-PACKAGE_TYPE.ctl` | `ZM-PC-init` writes `Undefined`; each child's `setType` hook its own value |
| `destination` | `ZM-PC-DESTINATION.ctl`, default `Unknown` | the creator (SIM `do`: `Communication`; `EP-create`: `Root`); `init` does not touch it |

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Read timestamp`, `Write timestamp` | ACC | priv | | used by `getTimestampString`, `init` |
| `Read type` | ACC | pub | | used by ROOT, tests |
| `Write type` | ACC | prot | | used by `init` and the children's `setType` |
| `Read destination` | ACC | pub | | used by ROOT, tests |
| `Write destination` | ACC | pub | | used by the SIM (outside the hierarchy), `EP-create`, tests |
| `ZM-PC-init.vi` | DD | pub | — | `Get Date/Time In Seconds` → `Write timestamp`; `Write type` = `Undefined` |
| `ZM-PC-getDataAsJson.vi` | DD | pub | out `json: String` | `getHeader` → `Flatten To JSON` → `{"timestamp":"…","type":"Undefined","destination":"Unknown"}` |
| `ZM-PC-getTypeName.vi` | ST | pub | out `type_name: String` | `Read type` → item name. The only VI others use to name a type |
| `ZM-PC-getDestinationName.vi` | ST | pub | out `destination_name: String` | `Read destination` → item name |
| `ZM-PC-getTimestampString.vi` | ST | pub | out `timestamp_iso: String` | `Format Date/Time String` (UTC) `%Y-%m-%dT%H:%M:%S` + `.` + milliseconds as 3 zero-padded digits (fractional seconds × 1000) + `Z`. **No `%u`** (it follows the locale's decimal sign) |
| `ZM-PC-getHeader.vi` | ST | prot | out `header: ZM-PC-HEADER.ctl` | bundles timestamp string, type name, destination name; used by every `getDataAsJson` |

**`ZM-PC-TP-test_package.lvclass`** (parent `ZM-PC-package`). TypeDef `ZM-PC-TP-DATA.ctl` = cluster
`{temperature_c: DBL, sample_index: I32, duty_percent: U8, sensor_ok: Boolean, status: String}`.
Field `data` (`ZM-PC-TP-DATA.ctl`).

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Read data` | ACC | pub | | used by `getDataAsJson`, the HWM chart, tests |
| `Write data` | ACC | priv | | used by `create` |
| `ZM-PC-init.vi` | OVR | pub | — | Call Parent → `ZM-PC-TP-setType` |
| `ZM-PC-TP-setType.vi` | HOOK | priv | — | `Write type` = `TestPackage` |
| `ZM-PC-getDataAsJson.vi` | OVR | pub | out `json` | header + `Read data` → bundle `{timestamp, type, destination, data}` → `Flatten To JSON` |
| `ZM-PC-TP-create.vi` | ST | pub | in `data`; out `package: ZM-PC-TP-test_package` | default object → `ZM-PC-init` → `Write data` |

**`ZM-PC-EP-error_package.lvclass`** (parent `ZM-PC-package`). TypeDef `ZM-PC-EP-DATA.ctl` = cluster
`{sender: String, code: I32, source: String}` (own typedef, not the error cluster, so the JSON has
plain names). Field `data`.

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Read data` | ACC | pub | | used by `getDataAsJson`, ROOT `showError`, tests |
| `Write data` | ACC | priv | | used by `create` |
| `ZM-PC-init.vi` | OVR | pub | — | Call Parent → `ZM-PC-EP-setType` |
| `ZM-PC-EP-setType.vi` | HOOK | priv | — | `Write type` = `ErrorPackage` |
| `ZM-PC-getDataAsJson.vi` | OVR | pub | out `json` | e.g. `{"timestamp":"…","type":"ErrorPackage","destination":"Root","data":{"sender":"HWM","code":5000,"source":"…"}}` |
| `ZM-PC-EP-create.vi` | ST | pub | in `sender: String`, in `error_to_report` (error cluster as a **data** input, not the error chain); out `package` | default object → `ZM-PC-init` → unbundle code/source → `Write data` → `Write destination` = `Root` |

### 7.2 `ZM-CU-common_utilities.lvlib` — `src/common/ZM-CU-common_utilities/`

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `ZM-CU-log.vi` | function | pub | in `message: String` | appends `<ISO UTC timestamp>\t<message>\n` to the fixed file `<project folder>\output\ZM-error_log.txt`, path built from the VI's own path (`Strip Path` up to the folder holding `src/`). Creates `output\` if missing; open, write, close per call. `error in` passes through; it logs regardless. Same timestamp recipe as `getTimestampString`, built inside (ZM-CU may not depend on ZM-PC). The project's local log (`errors.log-local`) |

### 7.3 `ZM-CI-common_interfaces.lvlib` — `src/common/ZM-CI-common_interfaces/`

**`ZM-CI-package_handler.lvclass`** (interface, no data): `ZM-CI-handlePackage.vi` (DD, pub, in
`package: ZM-PC-package`, no body).

`Messages/ZM-CI-handlePackage Msg/` (Message Maker): `ZM-CI-handlePackage Msg.lvclass` (payload
`package`), `Send ZM-CI-handlePackage.vi` (in `enqueuer`, `package`), `Do.vi` (casts the actor to the
interface, calls `ZM-CI-handlePackage`).

### 7.4 `ZM-HW-hardware.lvlib` — `src/hardware/ZM-HW-hardware/`

**`ZM-HW-hardware.lvclass`**. Field `initialized` (Boolean).

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Write initialized` | ACC | priv | | (no `Read`: nothing reads it) |
| `ZM-HW-init.vi` | DD | pub | — | `Write initialized` = T |
| `ZM-HW-do.vi` | DD | pub | out `package: ZM-PC-package` | **placeholder**: default package out, error 5000 |
| `ZM-HW-close.vi` | DD | pub | — | `Write initialized` = F. The safe-state place for real hardware (`errors.default-policy`) |

### 7.5 `ZM-HW-SIM-simulated_hardware.lvlib` — `src/hardware/ZM-HW-SIM-simulated_hardware/`

**`ZM-HW-SIM-simulated_hardware.lvclass`** (parent `ZM-HW-hardware`), no fields.

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `ZM-HW-do.vi` | OVR | pub | out `package` | own body, no Call Parent: `randomData` → `ZM-PC-TP-create` → `Write destination` = `Communication` → out (as `ZM-PC-package`) |
| `ZM-HW-SIM-randomData.vi` | ST | priv | out `data: ZM-PC-TP-DATA.ctl` (typedef bound on the pane) | `Random Number (0-1)` ×5: `temperature_c` = 20 + 10·r; `sample_index` = floor(1000·r); `duty_percent` = floor(101·r); `sensor_ok` = r > 0.1; `status` = `{"ok","warm","cold"}[floor(3·r)]` |

### 7.6 `ZM-CP-communication_protocol.lvlib` — `src/protocol/ZM-CP-communication_protocol/`

**`ZM-CP-communication_protocol.lvclass`**. Field `opened` (Boolean).

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Write opened` | ACC | priv | | (no `Read`) |
| `ZM-CP-init.vi` | DD | pub | — | `Write opened` = T |
| `ZM-CP-publish.vi` | DD | pub | in `package: ZM-PC-package` | **placeholder**: error 5000 |
| `ZM-CP-close.vi` | DD | pub | — | `Write opened` = F |

### 7.7 `ZM-CP-FL-file_logger.lvlib` — `src/protocol/ZM-CP-FL-file_logger/`

**`ZM-CP-FL-file_logger.lvclass`**. Field `outputFolder` (Path).

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Read outputFolder` | ACC | priv | | |
| `Write outputFolder` | ACC | pub | | used by ROOT `launchCm`, tests |
| `ZM-CP-init.vi` | OVR | pub | — | Call Parent → `ZM-CP-FL-createFolder` |
| `ZM-CP-FL-createFolder.vi` | HOOK | priv | — | `Read outputFolder` → `Create Folder` if missing |
| `ZM-CP-publish.vi` | OVR | pub | in `package` | `getTypeName` → `buildPath`; `getDataAsJson` → `appendLine` |
| `ZM-CP-FL-buildPath.vi` | ST | priv | in `folder: Path`, `type_name: String`; out `file: Path` | `Build Path(folder, type_name + ".jsonl")` |
| `ZM-CP-FL-appendLine.vi` | ST | priv | in `file: Path`, `line: String` | open or create → end of file → write line + `\n` → close |

### 7.8 `ZM-CP-UDP-udp_transport.lvlib` — `src/protocol/ZM-CP-UDP-udp_transport/`

**`ZM-CP-UDP-sender.lvclass`**. Fields `remoteAddress` (String, default `127.0.0.1`), `remotePort`
(U16, default 61557), `connection` (UDP Network Connection refnum).

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Read remoteAddress`, `Read remotePort` | ACC | priv | | (no `Write`: the root uses the defaults; no configuration files, D34) |
| `Read connection`, `Write connection` | ACC | priv | | |
| `ZM-CP-init.vi` | OVR | pub | — | Call Parent → `ZM-CP-UDP-openSender` |
| `ZM-CP-UDP-openSender.vi` | HOOK | priv | — | `UDP Open` (local port 0 = any) → `Write connection` |
| `ZM-CP-publish.vi` | OVR | pub | in `package` | `getDataAsJson` → `String To IP(remoteAddress)`, `remotePort` → `UDP Write` → codes **66** and **56** ("no listener") cleared by a case on the code with a no-error constant (Clear Errors takes one code); any other error passes on. Sending to nobody is silent |
| `ZM-CP-close.vi` | OVR | pub | — | `ZM-CP-UDP-closeConnection` → Call Parent |
| `ZM-CP-UDP-closeConnection.vi` | HOOK | priv | — | `Read connection` → `UDP Close` |

**`ZM-CP-UDP-receiver.lvclass`**. Fields `localPort` (U16, default 61557), `connection`. Does **not**
override `publish`.

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Read localPort` | ACC | priv | | |
| `Write localPort` | ACC | pub | | used by the receiver VI, tests |
| `Read connection`, `Write connection` | ACC | priv | | |
| `ZM-CP-init.vi` | OVR | pub | — | Call Parent → `ZM-CP-UDP-openReceiver` |
| `ZM-CP-UDP-openReceiver.vi` | HOOK | priv | — | `Read localPort` → `UDP Open` → `Write connection` |
| `ZM-CP-UDP-receive.vi` | ST | pub | in `timeout_ms: I32`; out `json: String`, `timed_out: Boolean` | `UDP Read` (timeout, max size 65 507) → error 56 cleared into `timed_out` = T, `json` empty; other errors pass on |
| `ZM-CP-close.vi` | OVR | pub | — | `ZM-CP-UDP-closeConnection` → Call Parent |
| `ZM-CP-UDP-closeConnection.vi` | HOOK | priv | — | as the sender's (same name, own class folder) |

### 7.9 `ZM-CP-MX-multi_protocol.lvlib` — `src/protocol/ZM-CP-MX-multi_protocol/`

**`ZM-CP-MX-multi_protocol.lvclass`**. TypeDef `ZM-CP-MX-PROTOCOLS.ctl` (1D array of
`ZM-CP-communication_protocol`). Field `protocols`. Each call goes to every element in order; an
element's error stops the loop and is returned. The array runs through a **shift register**, each
element put back with `Replace Array Subset`, so stopping on an error never shortens it.

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `Read protocols` | ACC | priv | | |
| `Write protocols` | ACC | pub | | used by ROOT `launchCm`, tests |
| `ZM-CP-init.vi` | OVR | pub | — | Call Parent → `ZM-CP-MX-initAll` |
| `ZM-CP-MX-initAll.vi` | HOOK, **shared-clone reentrant** (a static VI in a dynamic-dispatch recursion cycle is broken otherwise; an element may itself be an MX) | priv | — | For loop (stop on error): `ZM-CP-init` (DD) on each element → `Write protocols` |
| `ZM-CP-publish.vi` | OVR | pub | in `package` | own body: For loop (stop on error): `ZM-CP-publish` on each element → `Write protocols` |
| `ZM-CP-close.vi` | OVR | pub | — | `ZM-CP-MX-closeAll` → Call Parent |
| `ZM-CP-MX-closeAll.vi` | HOOK, shared-clone reentrant | priv | — | as `initAll` with `ZM-CP-close` |

### 7.10 `ZM-CM-communication_manager.lvlib` — `src/actors/ZM-CM-communication_manager/`

**`ZM-CM-communication_manager.lvclass`** (parent `Actor`, implements `ZM-CI-package_handler`).
Description includes its error plan (§5). TypeDef `ZM-CM-PRELAUNCH_SETTINGS.ctl` = cluster
`{protocol: ZM-CP-communication_protocol}`.

| field | type | set by |
|---|---|---|
| `prelaunchSettings` | `ZM-CM-PRELAUNCH_SETTINGS.ctl` | the root, through `writePrelaunchSettings` |
| `protocol` | `ZM-CP-communication_protocol` | `createResources` (the initialised protocol) |
| `publishedCount` | U32 | `ZM-CI-handlePackage` |

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `ZM-CM-writePrelaunchSettings.vi` | CACC | pub | in `settings` (required), class in optional | writes `prelaunchSettings` into the given or a default object |
| `Read prelaunchSettings` | ACC | priv | | |
| `Read protocol`, `Write protocol` | ACC | priv | | |
| `Read publishedCount`, `Write publishedCount` | ACC | priv | | |
| `ZM-CM-createResources.vi` | HOOK | priv | — | `Read prelaunchSettings` → unbundle `protocol` → `ZM-CP-init` → `Write protocol`; case on the error: Error frame → `releaseProtocol`; returns the error |
| `ZM-CM-releaseProtocol.vi` | HOOK | priv | — | `Read protocol` → `ZM-CP-close` → `Write protocol`; code 1 from a never-opened resource → Clear Errors, no log; any other release error → `ZM-CU-log` and passed on: `error out` = Merge(the close error with code 1 cleared, `Write protocol`'s error) (`errors.release-errors`, D44) |
| `ZM-CM-evaluateError.vi` | HOOK | priv | stop actor? in/out | pass-through (§5, D40) |
| `ZM-CI-handlePackage.vi` | OVR (interface) | pub | in `package` | `Read protocol` → `ZM-CP-publish` → `Write protocol`; `publishedCount` += 1 |
| `Pre Launch Init.vi` | OVR (AF) | prot | | `createResources`; Call Parent |
| `Stop Core.vi` | OVR (AF) | prot | | Call Parent → `releaseProtocol` → Clear Errors (§5, D44) |
| `Handle Error.vi` | OVR (AF) | prot | | Call Parent → `evaluateError` |

### 7.11 `ZM-HWM-hardware_manager.lvlib` — `src/actors/ZM-HWM-hardware_manager/`

**`ZM-HWM-hardware_manager.lvclass`** (parent `Actor`, implements `ZM-CI-package_handler`). TypeDefs:
`ZM-HWM-PRELAUNCH_SETTINGS.ctl` = cluster `{hardware: ZM-HW-hardware, intervalMs: U32 = 500}`;
`ZM-HWM-EVENTS.ctl` = cluster `{stop: User Event refnum (Boolean)}`.

| field | type | set by |
|---|---|---|
| `prelaunchSettings` | `ZM-HWM-PRELAUNCH_SETTINGS.ctl` | the root, through `writePrelaunchSettings` |
| `packageCount` | U32 | `ZM-CI-handlePackage` |
| `events` | `ZM-HWM-EVENTS.ctl` | `createEvents` |

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `ZM-HWM-writePrelaunchSettings.vi` | CACC | pub | in `settings` (required), class in optional | |
| `Read prelaunchSettings` | ACC | priv | | used by the loop |
| `Read packageCount`, `Write packageCount` | ACC | priv | | |
| `Read events`, `Write events` | ACC | priv | | |
| `ZM-HWM-createResources.vi` | HOOK | priv | — | `createEvents`; case on the error: Error frame → `close`; returns the error |
| `ZM-HWM-createEvents.vi` | HOOK | priv | — | `Create User Event` (Boolean) → Bundle By Name into `ZM-HWM-EVENTS` → `Write events` |
| `ZM-HWM-init.vi` | HOOK | priv | out event registration refnum | in Actor Core, in series before Call Parent (D41): `Read events` → Unbundle `stop` → Register For Events (fresh no error); the refnum goes to `helperAcquisition`; `error out` = Merge(`error in`, Read events, Register), so an error goes on into Call Parent |
| `ZM-HWM-helperAcquisition.vi` | LOOP | priv | in HWM (a copy, not returned), in event registration refnum (from `init`) | below |
| `ZM-HWM-stop.vi` | HOOK | priv | — | `Read events` → Unbundle `stop` → `Generate User Event` (T) |
| `ZM-HWM-close.vi` | HOOK | priv | — | `Read events` → Unbundle → `Destroy User Event`; errors ignored on purpose → Clear Errors |
| `ZM-HWM-evaluateError.vi` | HOOK | priv | stop actor? in/out | pass-through (§5, D40) |
| `ZM-CI-handlePackage.vi` | OVR (interface) | pub | in `package` | `packageCount` += 1 → `Read Caller Enqueuer` → `Send ZM-CI-handlePackage`; a failed send (shutdown) → Clear Errors |
| `Pre Launch Init.vi` | OVR (AF) | prot | | `createResources`; Call Parent |
| `Actor Core.vi` | OVR (AF) | prot | | `init` → Call Parent; branch `helperAcquisition` (with `init`'s refnum) ∥ Call Parent → `stop` → Merge → `close` → Merge → error out (§6) |
| `Handle Error.vi` | OVR (AF) | prot | | Call Parent → `evaluateError` |

**`ZM-HWM-helperAcquisition.vi`** (folder `Helpers`) — two loops in the one VI
(`af-shapes.stop-mechanism`; a local works only inside the VI that owns the control). It talks to its
actor only through `Read Self Enqueuer` and `Send` (`af-shapes.helper-loop-vi`). Panel **shown when
called, closed afterwards**:

| panel element | type | role |
|---|---|---|
| `live` | waveform chart, plots `temperature_c`, `duty_percent`, default history | each iteration: package → `To More Specific Class` (TP) → `Read data` → bundle the two values. A non-TP skips the plot; that cast error ends in Clear Errors on its own wire |
| `interval set (ms)` | U32 control | written once from `prelaunchSettings.intervalMs` by local variable before the producer loop; its terminal inside the loop feeds `Wait (ms)` |
| `interval measured (ms)` | U32 indicator | `Wait (ms)` timer output minus the previous one (shift register); 0 on the first iteration |
| `stop` | Boolean, **Switch** (not latched), off the connector pane, **hidden** | written F by local before both loops start (an off-pane control keeps its last value); T by the event loop; read by the producer through a local **sequenced after the Wait** |

- **Event loop** (the async stop): the registration refnum from `init` → loop with the error case; No
  Error frame: event structure, frame `stop` → write `stop` = T by local, exit. After the loop: the `stop`
  hook (its error → Clear Errors, D40); right-side refnum → Unregister → Merge Errors.
- **Producer loop** (timed work, `af-shapes.timed-work`): before, `Read prelaunchSettings` →
  `hardware` → `ZM-HW-init`. Loop with the error case; No Error frame: `ZM-HW-do` → `Read Self
  Enqueuer` → `Send ZM-CI-handlePackage`; chart; `Wait (ms)`; exit when `stop` reads T or on an error.
  After: `ZM-HW-close` (runs with an error too: safe state), then the `stop` hook (its error → Clear
  Errors), so a producer that ends on an error also ends the event loop (D40).
- After both loops: Merge Errors → `evaluateError` (a pass-through) → on an error `Read Self Enqueuer` →
  `Send Normal Stop` (`errors.loop-errors`). `error out` = the raw merged error (D40).

### 7.12 `ZM-ROOT-root.lvlib` — `src/actors/ZM-ROOT-root/`

**`ZM-ROOT-root.lvclass`** (parent `Actor`, implements `ZM-CI-package_handler`). TypeDefs:
`ZM-ROOT-PRELAUNCH_SETTINGS.ctl` = cluster `{outputFolder: Path, usePlaceholderHardware: Boolean}`;
`ZM-ROOT-EVENTS.ctl` = cluster `{stop: User Event (Boolean), error: User Event (String)}`.

| field | type | set by |
|---|---|---|
| `prelaunchSettings` | `ZM-ROOT-PRELAUNCH_SETTINGS.ctl` | the launcher, through `writePrelaunchSettings` |
| `cmEnqueuer` | Message Enqueuer | `launchCm` |
| `hwmEnqueuer` | Message Enqueuer | `launchHwm` (kept for future commands to the HWM) |
| `cmRunning` | Boolean | T in `launchCm`; F when an error package from `"CM"` arrives |
| `lastPackageType` | `ZM-PC-PACKAGE_TYPE.ctl` | `notePackageType` |
| `packageCount` | U32 | `notePackageType` |
| `events` | `ZM-ROOT-EVENTS.ctl` | `createEvents` |

| VI | kind | scope | terminals | behaviour |
|---|---|---|---|---|
| `ZM-ROOT-writePrelaunchSettings.vi` | CACC | pub | in `settings` (required), class in optional | used by both launchers |
| `Read prelaunchSettings` | ACC | priv | | |
| `Read cmEnqueuer`, `Write cmEnqueuer` | ACC | priv | | |
| `Write hwmEnqueuer` | ACC | priv | | (no `Read` yet) |
| `Read cmRunning`, `Write cmRunning` | ACC | priv | | |
| `Write lastPackageType` | ACC | priv | | (no `Read` yet) |
| `Read packageCount`, `Write packageCount` | ACC | priv | | |
| `Read events`, `Write events` | ACC | priv | | |
| `ZM-ROOT-createResources.vi` | HOOK | priv | — | `createEvents`; Error frame → `close`; returns the error |
| `ZM-ROOT-createEvents.vi` | HOOK | priv | — | `Create User Event` ×2 → Bundle By Name → one `Write events` |
| `ZM-ROOT-init.vi` | HOOK | priv | out event registration refnum | in Actor Core, in series before Call Parent (D41): `launchCm` → `launchHwm` (class and error in series) → `Read events` → Unbundle `stop`, `error` → Register For Events (stop first, error second; fresh no error); the refnum goes to `helperPanel`; `error out` = Merge(launch chain, Read events, Register), so an error goes on into Call Parent |
| `ZM-ROOT-launchCm.vi` | HOOK | priv | — | `Read prelaunchSettings` → FL constant → `Write outputFolder`; UDP-sender constant (defaults); both up-cast → `Build Array` → MX `Write protocols` → bundle `ZM-CM-PRELAUNCH_SETTINGS` → `ZM-CM-writePrelaunchSettings` → `Launch Nested Actor` → `Write cmEnqueuer`, `Write cmRunning` = T |
| `ZM-ROOT-launchHwm.vi` | HOOK | priv | — | case on `usePlaceholderHardware`: SIM / bare `ZM-HW-hardware` constant → bundle `ZM-HWM-PRELAUNCH_SETTINGS` (`intervalMs` 500) → `ZM-HWM-writePrelaunchSettings` → `Launch Nested Actor` → `Write hwmEnqueuer` |
| `ZM-ROOT-notePackageType.vi` | ST | priv | in `package` | `Read type` → `Write lastPackageType`; `packageCount` += 1 |
| `ZM-ROOT-showError.vi` | ST | priv | in `package` | `Read events` → Unbundle `error`; `getDataAsJson` → `Generate User Event`; cast to EP, `Read data`, sender = `"CM"` → `Write cmRunning` = F. The only VI outside ZM-PC that knows the EP class |
| `ZM-CI-handlePackage.vi` | OVR (interface) | pub | in `package` | case on `Read destination` (`01` R5 table) |
| `ZM-ROOT-helperPanel.vi` | LOOP | priv | in ROOT (a copy, not returned), in event registration refnum (from `init`) | folder `Helpers`. Panel opens when called, closes afterwards: `Stop` (Boolean, **Switch When Released**), `errors` (String, multi-line), and a note below Stop: `To watch the data being sent: in the project, open the virtual folder "receiver" and run ZM-receiver.vi (UDP 127.0.0.1:61557).` The registration refnum from `init` (both user events) into the event structure's dynamic terminal, plus the Stop value change → loop with the error case; No Error frame: event structure: **Stop** → `Stop` = F (local) → `Read Self Enqueuer` → `Send Normal Stop`, keep looping; **error** → append to `errors`; **stop** → exit. After the loop: right-side refnum → Unregister; the `stop` hook (its error → Clear Errors, D40); Merge → `evaluateError` (a pass-through) → on an error `Send Normal Stop` to self; `error out` = the raw merged error. No Timeout frame |
| `ZM-ROOT-stop.vi` | HOOK | priv | — | `Read events` → Unbundle `stop` → `Generate User Event` |
| `ZM-ROOT-close.vi` | HOOK | priv | — | `Read events` → Unbundle → `Destroy User Event` ×2; errors ignored on purpose → Clear Errors |
| `ZM-ROOT-evaluateError.vi` | HOOK | priv | stop actor? in/out | pass-through (§5, D40) |
| `Pre Launch Init.vi` | OVR (AF) | prot | | `createResources`; Call Parent |
| `Actor Core.vi` | OVR (AF) | prot | | `init` (`launchCm` → `launchHwm` → Register) → Call Parent; branch from `<C> in` → `helperPanel` (with `init`'s refnum); after Call Parent `stop` → Merge → `close` → Merge → error out (§6) |
| `Handle Error.vi` | OVR (AF) | prot | | Call Parent → `evaluateError` |

## 8. Top level, receiver and tests — `src/`

The **project folder** is the folder holding `src/`; `output\` sits in it. A VI finds it from its own
path with `Strip Path`.

| file | behaviour |
|---|---|
| `Zuehlke MCP.lvproj` | virtual folders `common`, `hardware`, `protocol`, `actors`, `tests`, `receiver`; `ZM-launcher.vi` at the project root, `ZM-launcher_test.vi` in `tests` (decided D45: its file stays in `src/` and it is not a member of `ZM-TST-tests.lvlib`) |
| `ZM-launcher.vi` | **interactive.** Control `output_folder` (Path, empty = `<project folder>\output`). Indicator `error out` (decided D43: a failed launch stays visible; nothing is cleared). Bundle `ZM-ROOT-PRELAUNCH_SETTINGS` (`usePlaceholderHardware` F) → `ZM-ROOT-writePrelaunchSettings` → `Launch Root Actor` → done |
| `ZM-launcher_test.vi` | **headless**, in the project's `tests` virtual folder (D45). Controls `run_time_ms` (U32, 5000), `output_folder`, `use_placeholder_hardware` (Boolean, F). Indicators `lines_written` (I32), `last_line` (String), `error_lines` (I32), `ui_errors` (String), `error out`. Body: delete `TestPackage.jsonl` and `ZM-error_log.txt` (missing is not an error) → settings → `writePrelaunchSettings` → `Launch Root Actor` → `Wait run_time_ms` → read `errors` from the running `ZM-ROOT-root.lvlib:ZM-ROOT-root.lvclass:ZM-ROOT-helperPanel.vi` (Open VI Reference by qualified name + control value get) → `ui_errors` → `Send Normal Stop` → `Wait` 1000 → count lines in both files (missing counts 0) → last line of `TestPackage.jsonl` |
| `receiver/ZM-receiver.vi` | plain VI. Controls `port` (U16, 61557), `Stop` (Switch When Released). Indicators `chart` (plots `temperature_c`, `duty_percent`), `interval measured (ms)` (Tick Count difference between two packets), `last line`, `packets` (U32), `error out`. Body: UDP-receiver constant → `Write localPort` → `ZM-CP-init` → while: `receive(1000)` → timed out: keep waiting; data → `Unflatten From JSON` into `ZM-PC-HEADER.ctl` (not strict: the extra `data` key is ignored) → `TestPackage`? → `Unflatten From JSON` path `["data"]` into `ZM-PC-TP-DATA.ctl` → chart, interval, last line, packets += 1; exit on Stop or error → `ZM-CP-close` |
| `tests/ZM-TST-tests.lvlib` | the test library (`hygiene.test-library`), holding the seven test VIs of `03` §1 |
| `errors/ZM-errors.txt` | LabVIEW error-code file (copy in `assets/`; installed into LabVIEW's `user.lib\errors\`) |
| `../README.md` | what the application is, how to open and run it (the receiver hint included), the folder layout; points to the user guide |
| `../docs/user-guide.html` | the user guide (`01` R11, decided D47): one self-contained HTML page (inline CSS and SVG, no external files, opens offline) for a LabVIEW user: what the application is, the actor tree as a diagram, how to run the launchers and the receiver, what the panels show, the output files, errors, the tests, troubleshooting, the folder layout. Every name in it matches this file |

## 9. Disk layout

```
<project folder>/
  src/
    Zuehlke MCP.lvproj, ZM-launcher.vi, ZM-launcher_test.vi
    common/
      ZM-PC-packages/            lvlib
        ZM-PC-package/           class, PACKAGE_TYPE/DESTINATION/HEADER .ctl, VIs (flat)
        ZM-PC-TP-test_package/   class, ZM-PC-TP-DATA.ctl, VIs
        ZM-PC-EP-error_package/  class, ZM-PC-EP-DATA.ctl, VIs
      ZM-CU-common_utilities/    lvlib, ZM-CU-log.vi
      ZM-CI-common_interfaces/   lvlib, ZM-CI-package_handler/, ZM-CI-handlePackage Msg/
    hardware/
      ZM-HW-hardware/            lvlib, ZM-HW-hardware/
      ZM-HW-SIM-simulated_hardware/   lvlib, ZM-HW-SIM-simulated_hardware/
    protocol/
      ZM-CP-communication_protocol/   lvlib, ZM-CP-communication_protocol/
      ZM-CP-FL-file_logger/      lvlib, ZM-CP-FL-file_logger/
      ZM-CP-UDP-udp_transport/   lvlib, ZM-CP-UDP-sender/, ZM-CP-UDP-receiver/
      ZM-CP-MX-multi_protocol/   lvlib, ZM-CP-MX-multi_protocol/ (+ ZM-CP-MX-PROTOCOLS.ctl)
    actors/
      ZM-ROOT-root/              lvlib, ZM-ROOT-root/ (+ EVENTS, PRELAUNCH_SETTINGS .ctl)
      ZM-HWM-hardware_manager/   lvlib, ZM-HWM-hardware_manager/ (+ EVENTS, PRELAUNCH_SETTINGS .ctl)
      ZM-CM-communication_manager/  lvlib, ZM-CM-communication_manager/ (+ PRELAUNCH_SETTINGS .ctl)
    receiver/ZM-receiver.vi
    tests/                       ZM-TST-tests.lvlib + the seven test VIs
    errors/ZM-errors.txt
  output/                        ZM-error_log.txt, <type>.jsonl  (git-ignored, run-time only)
  docs/                          error-codes.md, user-guide.html
  tools/                         jsonl_viewer.html
  README.md
```

## 10. Expected counts

| | count |
|---|---|
| libraries | 13 (12 shipped + `ZM-TST-tests`; decided D42) |
| classes | 13 (3 PC, 2 HW, 5 CP, 3 actors) + 1 interface + 1 message class |
| typedefs | 11 (PC 5, MX 1, ROOT 2, HWM 2, CM 1; no UDP connection typedef) |
| AF overrides | 9 (3 per actor) |
| `init` members | 2 (HWM, ROOT; D41) |
| test VIs | 7 |

VI counts depend on the generated accessors and are not fixed; the original pilot (before this
alignment) had 146 VIs; run-01 of this pack built 137.
