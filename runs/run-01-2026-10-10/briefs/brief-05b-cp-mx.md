# Brief 05b: `ZM-CP-MX-multi_protocol` class with `ZM-CP-MX-PROTOCOLS.ctl`, `initAll`/`closeAll`, overrides, and its library
Type: build (LabVIEW calls). Phase 05 step b of 4 (a: UDP done; c: T5 and the MX check in T4; d: cleanup, icons, sweep).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-05a-cp-udp.md`
  (item 3: the measured pane typing for hooks that call CHILD accessors; the override shapes B and B-after as
  measured; the library route), `report-04b-cp-fl-test.md`, `report-01b-pc-methods-library.md` (trap T1).
  <<MANAGER: traps from report 05a go here before launch>>
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions, `.ctl` membership (`ZM-CP-MX-PROTOCOLS.ctl` into `TypeDefs`) and
  `Methods` placement are the user's (list them). D39: icons without a prompt (step d).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib`; a class created with a parent in a
  library leaves a stray top-level item (`lvproj_drop.py`); members of other libraries inside a method go in as
  stubs and are swapped; T1 and 05a's measured hook typing; **an array-of-class field is NEVER bound inside
  `lvai_create_class` (it crashed LabVIEW in the pilot)**: typedef `array{bool.protocols}` first, then
  `<skill>\kit\pa_array_element_replace.xml` (project open and active; inputs `ctl path`, `element path` = the parent
  `.lvclass`, `is typedef after` true), placeholder field `string.protocols`, commit, then a separate
  `lvai_bind_class_fields` with no `force` (`ops\class-field.md` route A step 3, "Array of class"); a placeholder
  for an array-of-class terminal is a scalar `path`: make that stub by hand with `array{path}`.

## Goal
The composite protocol in its own library under `protocol`: `ZM-CP-MX-multi_protocol.lvclass` (parent
`ZM-CP-communication_protocol`) with the typedef `ZM-CP-MX-PROTOCOLS.ctl` (1D array of `ZM-CP-communication_protocol`),
the field `protocols` bound to it, accessors `Read protocols` (private) and `Write protocols` (public), the
shared-clone reentrant hooks `ZM-CP-MX-initAll.vi` and `ZM-CP-MX-closeAll.vi`, the `init`/`close` overrides with Call
Parent and the `publish` override with its own body, in `ZM-CP-MX-multi_protocol.lvlib`, depending on
`ZM-CP-communication_protocol.lvlib` and `ZM-PC-packages.lvlib` only. Each call goes to every element in order; an
element's error stops the loop and is returned; the array runs through a shift register and each element is put
back with `Replace Array Subset`, so stopping on an error never shortens it. No test here (step c).

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\protocol\ZM-CP-MX-multi_protocol\ZM-CP-MX-multi_protocol\` (class, `.ctl`, VIs
  flat); library file `...\src\protocol\ZM-CP-MX-multi_protocol\ZM-CP-MX-multi_protocol.lvlib`.
- Parent: `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol.lvclass`
  and its `ZM-CP-init.vi`, `ZM-CP-publish.vi`, `ZM-CP-close.vi`.
- AIXML sources `...\proof\ZMP-05b\`; helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md` (route A, "Array of
  class"), `ops\override.md` (sections 1, 3 shapes B and B-after, 4), `ops\sweep.md`, `knowledge\labview-mcp.md`
  ("Known gaps": `lvai_create_class`, `lvai_create_typedef`, `lvai_bind_class_fields`, `lvai_placeholder_subvi`,
  "LabVIEW scripting quirks": reentrancy via `set_reentrant_flags.py` on a `pylv_extract` bundle, project closed),
  `kit\README.md` (`pa_array_element_replace.xml`, `set_reentrant_flags.py`, `pylv_extract`/`pylv_rebuild`).
- Conventions: `...\.labview\conventions\naming.md`, `layout.md`, `errors.md`, `hygiene.md`. Spec:
  `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.9 (lines 431-447), §3.1, §1;
  `01-requirements.md` R4; `04-decisions.md` D26.

## What to build, in this order
1. **Typedef** `ZM-CP-MX-PROTOCOLS.ctl` flat in the class folder: `lvai_create_typedef` `array{bool.protocols}`, no
   `projectPath`; commit; then with the project OPEN AND ACTIVE run `pa_array_element_replace.xml` (element = the
   parent `.lvclass`, `is typedef after` true); close; `lvai_describe_ctl` shows an array of the parent class;
   commit `feat(cp): typedef ZM-CP-MX-PROTOCOLS (array of ZM-CP-communication_protocol)`.
2. **Class** `ZM-CP-MX-multi_protocol.lvclass`, `parentClassPath` = the parent, placeholder field
   `string.protocols` (NOT the typedef); `lvproj_drop.py` a stray item; commit. Then project open and active:
   `lvai_bind_class_fields` `protocols` ← the `.ctl` (no `force`); `ok` gated on `boundInFile`; close; commit
   `feat(cp): class ZM-CP-MX-multi_protocol with field protocols bound to ZM-CP-MX-PROTOCOLS`.
3. **Accessors** (static): `Read protocols` private, `Write protocols` PUBLIC (`set_scope.py`, project closed);
   the value terminal is named after the `.ctl` (`ZM-CP-MX-PROTOCOLS`). Commit.
4. **Hooks** (static, private, class terminals typed per 05a's measurement for hooks that use CHILD accessors):
   | VI | body |
   |---|---|
   | `ZM-CP-MX-initAll.vi` | `Read protocols` → For loop over the array with a shift register on the array and one on the error: at index i, `Index Array` → `ZM-CP-init` (dynamic call on the element's `ZM-CP-communication_protocol` wire) → `Replace Array Subset` back at i; the loop stops on error (conditional terminal from the error status); after the loop `Write protocols` (the array from the shift register, never shortened) → `error out` |
   | `ZM-CP-MX-closeAll.vi` | the same with `ZM-CP-close` |
   Then make BOTH **shared-clone reentrant** (a static VI in a dynamic-dispatch recursion cycle is broken otherwise;
   an element may itself be an MX): `pylv_extract` → `python <skill>\kit\set_reentrant_flags.py <bundle>` →
   `pylv_rebuild`, project closed (the VI Server write of the reentrancy type changed nothing in the pilot); prove it
   from the rebuilt file (`pylv_extract` again: `IsReentrant` + `PooledReentrancy` set) and cold state 1. Commit.
5. **Library** `ZM-CP-MX-multi_protocol.lvlib` holding the class (cached helper, project open and active; then
   closed: `lvproj_drop.py`, `lvproj_move.py "ZM-CP-MX-multi_protocol.lvlib" protocol`; reopen/close once). The
   `.lvproj` `protocol` folder lists four CP libraries once each. Commit.
6. **Overrides** (after the library): `ZM-CP-init.vi` = Call Parent → hook `initAll` after (B-after);
   `ZM-CP-close.vi` = hook `closeAll` BEFORE Call Parent (shape B); `pa_save_member` each; export and confirm the
   order. `ZM-CP-publish.vi` (own body, parent's pane, `dispatchTerminals`): `Read protocols` → the same For loop
   with `ZM-CP-publish` (dynamic, the `package` input fanned to every element) → `Write protocols` → `error out`.
   Commit each.
7. **Checks:** project closed; cold sweep of `src\protocol\ZM-CP-MX-multi_protocol\`; `check_membership.py`;
   `lv_save_version.py` (26); links only into `src\protocol\ZM-CP-communication_protocol\`,
   `src\common\ZM-PC-packages\` and this class; none into `vi.lib\ActorFramework`, `ZM-CU`, `ZM-HW`, `ZM-TST`,
   `ZM-CP-FL`, `ZM-CP-UDP`. A cold behaviour probe in the proof folder: an MX holding `[bare parent]` → `init` (no
   error) → `publish` of a default package returns code 5000 (the element's placeholder) → quote it; and an MX
   holding `[]` → `init`, `publish`, `close` all without error.
Descriptions on every VI. Class description for the user (D38): "Composite protocol: holds an array of
ZM-CP-communication_protocol objects; init, publish and close go to every element in order, stopping at the first
error, which is returned. The root gives the CM an MX holding [file logger, UDP sender] (D26)."

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed; the pylv bundle
  edit by `set_reentrant_flags.py` is a kit script). AIXML with the Write tool. Absolute long-form paths. Nothing
  outside the product folder except helpers and the stub cache. Nothing under `src\common\`, `src\hardware\`,
  `src\tests\` or the other CP folders may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.9; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Typedef (`describe_ctl`), class (`describe_class`: parent, the bound
field), accessors, members with scope/dynamic/reentrancy from the files. 3. The override block of `ops\override.md`
per override. 4. Library route; the `.lvproj` `protocol` lines. 5. The two probe readings. 6. Sweep, membership,
versions, links. 7. Commits; `git status`. 8. Deviations / unmeasured / NEEDS CLARIFICATION; items for the user in
the IDE. 9. Side effects.
