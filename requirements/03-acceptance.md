# Zuehlke MCP — acceptance criteria

The build is accepted when every check below holds, **on a cold LabVIEW start**, with the work
committed.

Test VIs follow the skill's `hygiene.test-convention`: each outputs a Boolean **`Pass`** and
`error out`; the per-mechanism Booleans below are **informational** indicators that make up `Pass`
(Pass = AND of them) and stay off the read-back. The tests live in `ZM-TST-tests.lvlib` and are listed
in `.labview/checks.json`. **JSON is compared after unflattening, never as a string** (the timestamp
changes every run). Timestamp pattern below: `^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d\.\d{3}Z$` (a decimal comma
fails it).

## 1. Test VIs (`src/tests/`)

### T1 `ZM-TST-packages.vi` (round-trip test of the package classes)

| check | proves |
|---|---|
| `dispatch_ok` | a TP object on a `ZM-PC-package` wire: `getDataAsJson` runs the child's override |
| `call_parent_ok` | after `ZM-PC-TP-create` the type is `TestPackage` (child ran) and the JSON timestamp matches the pattern (parent ran) |
| `tp_json_ok` | **round trip**: the TP JSON unflattens into `{timestamp, type, destination, data}` and `data` equals the cluster given to `create` |
| `type_name_ok` | `getTypeName` gives `TestPackage`, `ErrorPackage`, `Undefined` for TP, EP and a bare parent |
| `ep_json_ok` | **round trip**: `ZM-PC-EP-create("HWM", error 5000 "x")` → JSON unflattens to sender `HWM`, code 5000, source `x` |
| `parent_json_ok` | a bare parent after `init`: JSON has `timestamp`, `type`, `destination` and no `data` |
| `timestamp_ok` | `getTimestampString` matches the pattern |
| `destination_default_ok` | a new TP reads `Unknown` |
| `destination_roundtrip_ok` | Write → Read destination, all four values |
| `ep_root_ok` | `EP-create` gives destination `Root` |
| **`Pass`** | AND of all |

### T2 `ZM-TST-log.vi`

Two `ZM-CU-log` calls with unique markers.

| check | proves |
|---|---|
| `file_ok` | `<project folder>\output\ZM-error_log.txt` exists |
| `order_ok` | its last two lines end with the two markers, in order |
| `timestamp_ok` | both lines start with a timestamp matching the pattern |
| **`Pass`** | AND |

Side effect: two marker lines appended to the error log (the launcher runs delete it first).

### T3 `ZM-TST-hardware.vi`

| check | proves |
|---|---|
| `sim_ok` | a SIM object on a `ZM-HW-hardware` wire: `init` → `do` ×3 → `close` without error; each package names `TestPackage` |
| `sim_destination_ok` | every SIM package reads destination `Communication` |
| `ranges_ok` | per package (via JSON): `temperature_c` in [20, 30), `sample_index` in [0, 999], `duty_percent` in [0, 100], `status` in {ok, warm, cold} |
| `varies_ok` | the three `sample_index` values are not all equal |
| `placeholder_ok` | a bare `ZM-HW-hardware`: `do` returns error 5000 (`source` = `ZM-HW-do.vi: must be overridden by a child class`) |
| **`Pass`** | AND |

### T4 `ZM-TST-protocol.vi`

A file logger with `outputFolder` = a fresh temp folder, on a `ZM-CP-communication_protocol` wire.

| check | proves |
|---|---|
| `init_ok` | `init` creates the folder (child ran), no error; the check that proves the folder (a second `Create Folder` answering 10) runs after `init`, on its error chain |
| `files_ok` | publishing 2 TP, 1 bare parent package, 1 EP → `TestPackage.jsonl` 2 lines, `Undefined.jsonl` 1, `ErrorPackage.jsonl` 1 |
| `lines_ok` | every line unflattens and carries the file's type |
| `append_ok` | one more TP publish → `TestPackage.jsonl` 3 lines (append, not overwrite) |
| `placeholder_ok` | a bare `ZM-CP-communication_protocol`: `publish` returns 5000 (contained, not in `error out`) |
| `close_ok` | `close` on the FL without error |
| `mx_placeholder_ok` | an MX holding `[bare ZM-CP-communication_protocol]` returns 5000 from `publish` |
| **`Pass`** | AND |

### T5 `ZM-TST-udp.vi` (round-trip test of the UDP transport and the MX bundle)

| check | proves |
|---|---|
| `rx_init_ok` | a receiver on 61557: `init`, no error |
| `roundtrip_ok` | **round trip**: a sender (defaults `127.0.0.1:61557`) `init`; one TP (destination Communication) published; receiver `receive(1000)`: `json` equals the same package's `getDataAsJson`, `timed_out` F |
| `timeout_ok` | `receive(200)` again: `timed_out` T, no error |
| `no_listener_ok` | receiver closed, sender publishes twice: no error |
| `mx_ok` | **round trip through the bundle**: MX `[FL(folder A), FL(folder B)]` (`output/test_mx_a`, `output/test_mx_b`, emptied first): `init`, publish one TP, `close` → both `TestPackage.jsonl` exist with 1 line that unflattens to the published data |
| `rx_publish_5000_ok` | `publish` on a receiver returns 5000 |
| **`Pass`** | AND |

### T6 `ZM-TST-pipeline.vi` — the data path without actors

A SIM and an FL (temp folder): `init` both, 10 × (`do` → `publish`), `close` both. Then the same with a
bare `ZM-HW-hardware`.

| check | proves |
|---|---|
| `pipeline_ok` | `TestPackage.jsonl` has 10 lines, each unflattens with five data fields |
| `error_stops_ok` | bare hardware: the first `do` gives 5000 and the loop stops before publishing; no new line in any file |
| **`Pass`** | AND |

### T7 `ZM-TST-routing.vi`

Calls ROOT's public `ZM-CI-handlePackage` override on a ROOT object directly (no running actor; any
member VI of an actor class can be run directly) with packages addressed to each destination.

| check | proves |
|---|---|
| `hardware_dropped_ok` | the error log has a line with `dropped TestPackage for Hardware` |
| `unknown_dropped_ok` | likewise `… for Unknown` |
| `communication_not_dropped_ok` | no `for Communication` line |
| `no_error_ok` | `error out` is clean |
| **`Pass`** | AND |

## 2. Runs

| run | how | expected |
|---|---|---|
| **R-normal** (×3) | `ZM-launcher_test.vi`, `run_time_ms` 5000, `use_placeholder_hardware` F | `lines_written` **8–11**; `last_line` unflattens to type `TestPackage` with five data fields and `"destination":"Communication"`; `error_lines` **0**; `ui_errors` empty; `error out` 0; afterwards both helper loops and every Actor Core are idle (the tree really stopped) |
| **R-error** | `ZM-launcher_test.vi`, `use_placeholder_hardware` **T** | (D40) the HWM's first `do` returns 5000, the HWM stops, its Last Ack stops the root, and the root's Stop Core stops the CM: the whole tree stops by itself, nothing hangs. `lines_written` 0; `last_line` empty; `error_lines` 0 (errors are not logged yet); `ui_errors` empty; `error out` 1556 (the launcher's Normal Stop finds no root, which shows the tree had already stopped); afterwards both helper loops and every Actor Core are idle |
| **R-interactive** | `ZM-launcher.vi`; the root's panel opens; JSONL lines grow (~2/s); the HWM live panel shows the chart moving and `interval measured (ms)` ≈ 500; **Stop pressed** (by hand, or headlessly by a signalling write to the Switch-When-Released button) | the tree stops, panels close, the line count stays stable afterwards, both helper loops have left memory |
| **R-receiver** | during R-interactive, start `ZM-receiver.vi` (default port), then press its Stop | `last line` is a `TestPackage` with `"destination":"Communication"`, the chart updates about every 500 ms; after its Stop the host tree keeps running with no error |
| **R-viewer** | open `output/TestPackage.jsonl` in `assets/jsonl_viewer.html` | the numeric fields plot |
| **R-close-order** | a run with timestamped lines, one log file per writer (the skill's helper-loop check) | per actor with a helper loop: the stop line, the loop's exit, then `close` after both; no hang |
| **R-stop-reset** | the HWM `stop` reset, tested as the skill's helper-loop checks say (the loop called twice from one caller; two separate top-level runs unload the VI in between and test nothing) | the second call does not stop at once |
| **R-pli-failure** | a failing `createResources` (e.g. an injected error after `createEvents`) | the launch fails with that error, what was created is released, nothing hangs |

## 3. Structural checks

| check | expected |
|---|---|
| Every VI in `src/` runnable (not broken), project closed | all |
| Every class member still a member of its class; every class in its library | all |
| Dependency rule (`02` §1) | no forbidden reference; `ZM-PC`, `ZM-CU`, `ZM-HW*`, `ZM-CP*` do not reference the Actor Framework; HWM and CM load no concrete hardware or protocol child |
| Naming (`02` §2) | camelCase members, snake_case classes/libraries/functions, UPPER_SNAKE typedefs, camelCase fields, role names |
| Scope and accessors | members private unless needed outside; only used accessors exist, in the used direction, static |
| Every AF override | protected, calls its parent; Handle Error and Stop Core call the parent **first** |
| Error plan (D40) | every `evaluateError` is a pass-through (no log, no error package, no clearing); each actor's class description says so |
| Pre Launch Init | calls only `createResources` (and its parent) |
| Actor Core (ROOT, HWM) | `init` in series before Call Parent (ROOT: `launchCm` → `launchHwm` → Register; HWM: Register; D41); helper loop beside Call Parent with `init`'s registration refnum; `stop` after Call Parent on a fresh chain; `close` after Merge(loop, stop); error out = Merge(Call Parent, close) |
| ROOT and HWM | **no** `Stop Core` override |
| Helper loops | in `Helpers`; error case inside the loop; the registration refnum from `init` into the dynamic terminal, right side to Unregister; every loop stops the others when it ends (the `stop` hook, its error into Clear Errors); after the loops Merge → `evaluateError` → on an error Send Normal Stop; `error out` the raw error; the loop VI does not Destroy |
| User events | one `ZM-<ABBR>-EVENTS.ctl` per actor, one `events` field, one Read/Write pair |
| Pre-launch settings | one `ZM-<A>-PRELAUNCH_SETTINGS.ctl` + public `writePrelaunchSettings` per actor; children launched by `launch<Child>` methods |
| Messages | exactly one message class, `ZM-CI-handlePackage Msg` |
| Ignored errors | every deliberately unhandled error ends in Clear Errors; no unwired `error out`; the CM release error is logged and passed on by `releaseProtocol` and ends in Stop Core's Clear Errors (D44) |
| Error code 5000 | registered in `error-codes.md` and `ZM-errors.txt`; each raising VI carries `#customerror 5000` |
| Virtual folders | `Accessors`, `AF Overrides`, `Helpers`, `Messages`, `Methods`, `TypeDefs` where non-empty; typedefs are class members |
| Descriptions | every class and VI, short (D46: 2-4 sentences, about 400 characters at most, ASCII, no decision numbers, rule IDs or spec section references); actor descriptions state the error plan |
| Icons | class templates applied as LabVIEW template layers, a glyph per VI, a banner per library |
| Clean Up Diagram | on every generated VI; nothing regenerated after it |
| Project tree | 13 libraries (D42); `ZM-launcher.vi` at the root and `ZM-launcher_test.vi` in `tests` (D45), both with `error out` (D43); 7 tests; the receiver; under virtual folders `common`, `hardware`, `protocol`, `actors`, `tests`, `receiver` |
| A clean stop | leaves `ZM-error_log.txt` empty |
| User documentation (D47) | `README.md` and `docs/user-guide.html` exist; the guide is one self-contained HTML page covering `01` R11, and its names match `02` |
