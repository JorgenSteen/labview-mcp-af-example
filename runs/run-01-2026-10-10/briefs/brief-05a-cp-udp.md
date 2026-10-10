# Brief 05a: `ZM-CP-UDP-sender` and `ZM-CP-UDP-receiver` classes, their hooks, overrides and `receive`, in `ZM-CP-UDP-udp_transport.lvlib`
Type: build (LabVIEW calls). Phase 05 step a of 4 (b: the MX class and library; c: T5 and the MX check in T4; d: cleanup, icons, sweep).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-04b-cp-fl-test.md`
  (a CP child with an `init` override + hook after Call Parent, a `publish` override with its own body, the library
  route), `report-04c-cp-cleanup-icons-sweep.md` (the state of the tree), `report-01b-pc-methods-library.md` (trap T1).
  <<MANAGER: traps from reports 04b/04c go here before launch>>
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions, `.ctl` membership and `Methods` placement are the user's (list
  them). D39: icons without a prompt (step d). D37: sender and receiver share ONE library and the abbreviation `UDP`.
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib "C:\Program Files (x86)\National
  Instruments\LabVIEW 2026\vi.lib"`; a class created with a parent in a library leaves a stray top-level class item
  after the library close (`lvproj_drop.py`); `lvai_add_class_method` converts with the project closed, so members
  and constants of OTHER libraries go in as stubs / path stand-ins and are swapped afterwards (`lvai_swap_subvis`);
  a hook after Call Parent in a dynamic override takes and returns the PARENT class type (T1); `Clear Errors.vi`
  terminal names are not derivable: clear a code with Unbundle code → Equal? → Select (that IS the spec's "case on
  the code with a no-error constant"); the typedef spelling for a UDP refnum field is `ref{UDP}` (skill knowledge,
  measured in the pilot; not in `lvai_aixml_reference`).

## Goal
Two sibling children of `ZM-CP-communication_protocol`, each in its own flat class folder, both in ONE library
`ZM-CP-UDP-udp_transport.lvlib` under `protocol`, depending on `ZM-CP-communication_protocol.lvlib` and
`ZM-PC-packages.lvlib` only: the sender (one JSON line per datagram, unicast to `127.0.0.1:61557` by default; sending
to nobody is silent) and the receiver (the reading side; does NOT override `publish`). No test here (step c).

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Library folder (create): `...\src\protocol\ZM-CP-UDP-udp_transport\` holding `ZM-CP-UDP-udp_transport.lvlib` and
  the two class folders `ZM-CP-UDP-sender\` and `ZM-CP-UDP-receiver\` (class and VIs flat in each).
- Parent: `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol.lvclass`
  (qualified `ZM-CP-communication_protocol.lvlib:ZM-CP-communication_protocol.lvclass`), its `ZM-CP-init.vi`,
  `ZM-CP-publish.vi`, `ZM-CP-close.vi` beside it. Packages: `...\src\common\ZM-PC-packages\ZM-PC-package\ZM-PC-getDataAsJson.vi`.
- AIXML sources `...\proof\ZMP-05a\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md`, `ops\override.md`
  (sections 1, 3 shapes B and B-after, 4), `ops\sweep.md`, `knowledge\labview-mcp.md` ("Known gaps":
  `lvai_create_class`, `lvai_create_typedef` spellings, `lvai_add_class_method`, "LabVIEW scripting quirks"),
  `kit\README.md`. Conventions: `...\.labview\conventions\naming.md`, `layout.md`, `errors.md`, `hygiene.md`.
- Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.8 (lines 402-430), §3.1, §1;
  `01-requirements.md` R4; `04-decisions.md` D24, D25, D34, D37; `...\docs\error-codes.md` (ignored codes 66, 56:
  both already listed there for the sender's `ZM-CP-publish.vi`; keep the catalogue true, edit it only if a VI name
  differs).

## What to build (names exactly as written; every member a class member, flat in its class folder)
**A. `ZM-CP-UDP-sender.lvclass`** (parent `ZM-CP-communication_protocol`). Fields: `remoteAddress` String default
`127.0.0.1`; `remotePort` U16 default 61557; `connection` (UDP Network Connection refnum, typedef spelling
`ref{UDP}` or the tool's equivalent; a plain refnum field, no `.ctl` of our own). Field defaults: set them in the
class's private data (if `lvai_create_class` cannot set a default, report how you set it, e.g. through the
accessor-free route the tool offers, or `lvpdc_export`/edit/`lvpdc_import` per `ops\class-field.md` route C step 2
adapted to a value change; never by hand). Accessors (static): `Read remoteAddress`, `Read remotePort`,
`Read connection`, `Write connection`, all private; NO `Write remoteAddress`/`Write remotePort` (D34).
| VI | kind, scope | body |
|---|---|---|
| `ZM-CP-UDP-openSender.vi` | HOOK, priv; class terminals typed PARENT, cast inside (see "Hook typing" below) | `UDP Open` (local port 0) → `Write connection` on the cast wire; the parent wire goes straight to the output |
| `ZM-CP-init.vi` | OVR, pub | `lvai_create_override` (Call Parent) → hook `openSender` after Call Parent, shape B-after |
| `ZM-CP-publish.vi` | OVR, pub, own body (parent's pane) | `getDataAsJson(package)` → `String To IP(Read remoteAddress)`, `Read remotePort` → `UDP Write(Read connection, address, port, data)` → clear codes 66 and 56 (Unbundle code → Equal? 66 OR Equal? 56 → Select no-error) → `error out`; any other error passes |
| `ZM-CP-UDP-closeConnection.vi` | HOOK, priv | `Read connection` → `UDP Close` |
| `ZM-CP-close.vi` | OVR, pub | hook `closeConnection` BEFORE Call Parent, shape B (`pa_insert_series2`, class block A on `<C> in`, error block B on `error in`) |
**Hook typing, MEASURED in 04b (`createFolder`):** a hook placed after or before Call Parent keeps the PARENT type
on its pane (`ZM-CP-communication_protocol in`/`out`, the class wire straight through) and casts INSIDE with
`To More Specific Class` (target: a constant of the child class) before the child's private accessors; the cast
result is not returned (the parent wire is). Cold state 1 for the hook, the override and every caller. Do the
same for `openSender`, `closeConnection`, `openReceiver`. `pa_insert_series2` inputs for B-after on a child
override: `panel name A` = `<Child> out`, `hook in A` = `<Parent> out`, `hook out A` = `<Parent> in`, block B
`error out` / `error out` / `error in (no error)`; for shape B (before Call Parent): `panel name A` = `<Child> in`,
`hook in A` = `<Parent> in`, `hook out A` = `<Parent> out`, block B `error in (no error)` / `error in (no error)` /
`error out` (the hook's own terminal names; read them with `lvai_vi_terminals`).
**B. `ZM-CP-UDP-receiver.lvclass`** (parent the same). Fields: `localPort` U16 default 61557; `connection` (as above).
Accessors (static): `Read localPort` priv, `Write localPort` PUBLIC, `Read connection`/`Write connection` priv.
| VI | kind, scope | body |
|---|---|---|
| `ZM-CP-UDP-openReceiver.vi` | HOOK, priv | `Read localPort` → `UDP Open(port)` → `Write connection` (same T1 route as the sender's) |
| `ZM-CP-init.vi` | OVR, pub | Call Parent → hook `openReceiver` after, B-after |
| `ZM-CP-UDP-receive.vi` | ST, pub; in `timeout_ms` (I32); out `json` (String), `timed_out` (Boolean) | `Read connection` → `UDP Read(timeout, max size 65507)` → `data out` → `json`; error 56 cleared (Select) into `timed_out` = T and `json` = ""; other errors pass |
| `ZM-CP-UDP-closeConnection.vi` | HOOK, priv | `Read connection` → `UDP Close` (same name as the sender's, own class folder) |
| `ZM-CP-close.vi` | OVR, pub | hook `closeConnection` before Call Parent, shape B |
The receiver does NOT override `publish` (D25; 5000 through the parent is correct).
Descriptions on every VI; class descriptions for the user (D38): sender: "UDP sender: one JSON line per datagram,
unicast to remoteAddress:remotePort (defaults 127.0.0.1:61557, D34). Sending to nobody is silent (codes 66 and 56
cleared, D25)."; receiver: "UDP receiver: the reading side of the transport; receive returns one JSON line or
timed_out. Does not override publish (5000 through the parent is correct, D25)."

## Route and order
1. `lvai_status`; project closed; `git status --short`; commit point.
2. Sender: class (fields + defaults) → accessors (scopes) → `openSender`, `closeConnection` (hooks; see the T1
   note), `publish` override (own body, parent's pane, `dispatchTerminals`; stubs for `getDataAsJson` and the
   parent accessors, swapped afterwards) → commit after each.
3. Receiver: class → accessors → `openReceiver`, `closeConnection`, `receive` → commit after each.
4. **Library** `ZM-CP-UDP-udp_transport.lvlib` holding BOTH classes (the cached helper with two `AddItem` calls, or
   run it twice: `AddItem` on an existing library is `lvai_add_to_library`), project open and active; then closed:
   `lvproj_drop.py` strays, `lvproj_move.py "ZM-CP-UDP-udp_transport.lvlib" protocol`; reopen/close once. Commit.
5. **Overrides with Call Parent** (after the library): `ZM-CP-init.vi` and `ZM-CP-close.vi` in each class via
   `lvai_create_override` (`vi name in memory` = `ZM-CP-UDP-udp_transport.lvlib:ZM-CP-UDP-sender.lvclass:ZM-CP-init.vi`
   etc.), commit each bare override, hook per the shapes above, `pa_save_member`, export and confirm the order
   (init: Call Parent → open hook; close: close hook → Call Parent). Commit each.
6. **Checks:** project closed; cold sweep of `src\protocol\ZM-CP-UDP-udp_transport\` (every VI state 1, control
   `0 7`, `check_membership.py` clean); `lv_save_version.py` (26); links of the UDP VIs only into `src\protocol\` and
   `src\common\ZM-PC-packages\`, none into `vi.lib\ActorFramework`, `ZM-CU`, `ZM-HW`, `ZM-TST`, `ZM-CP-FL`; a cold
   behaviour probe in the proof folder: sender `init` → `publish` of one TP → `close` with NO receiver: `error out`
   code 0 (codes 66/56 cleared); quote it.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\`, `src\hardware\`, `src\tests\`, `ZM-CP-communication_protocol\`, `ZM-CP-FL-file_logger\`
  may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.8; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 70 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Per class: describe_class (fields, defaults, parent), accessors with
scope, members with scope/dynamic from the XML. 3. The T1 measurement for the hooks: which pane typing worked,
exec states per attempt. 4. The override block of `ops\override.md` per override (shape, helper errors, export
evidence). 5. Library route; the `.lvproj` `protocol` lines. 6. The behaviour probe reading. 7. Sweep, membership,
versions, links. 8. Commits; `git status`. 9. Deviations / unmeasured / NEEDS CLARIFICATION; items for the user in
the IDE. 10. Side effects.
