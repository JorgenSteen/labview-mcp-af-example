# Brief 07: `ZM-CI-common_interfaces.lvlib`: the interface `ZM-CI-package_handler`, its method, and the one message class
Type: build (LabVIEW calls). Phase 07, one step (no test VI; structural proof).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-06-pipeline-test.md`
  (the state of the tree, every test green), `report-01b-pc-methods-library.md` (item 4: the library helper derived
  from the kit's actor-library XML), `report-03a-hw-parent.md` (a dynamic method with a class-typed input of another
  library, stub + constant swap).
- Phase 06 closed 2026-10-11 10:39: T1-T6 all PASS, every plain class proven; from here a failure is an actor-side
  problem (`01` §4). Session 2 runs on Opus 5.5; the standing LabVIEW go-ahead of 2026-10-10 is kept in force
  (status.md, "Session 2 started"): you may start or restart LabVIEW yourself when it crashes or stops answering,
  per `<skill>\session\start.md`, at most twice, each reported.
- Traps from 05a2-06 that apply here: a project close may drop the `.lvproj` BOM or change only its line endings, or
  add a loose entry: READ the diff (`git diff`) before `git checkout` of the `.lvproj` with the project closed, and
  quote it; `lvai_convert_vi_to_aixml` needs its target folder to exist; a VI already in a LOADED library cannot be
  regenerated over its path (1357: remove the member with the project closed, regenerate, re-add); the library
  helper `zm_create_class_library.vi` is cached, but THIS step needs the `Messages` folder, so use the kit's
  `lvai_create_actor_library.xml` as written (it creates the folder); every `lvai_*`/`pylv_*` call ALONE in its
  message, offline ones included.
- The interface method's pane: copy the parent-method layout used throughout (class in 11, error in 8, class out 3,
  error out 0, `package` on input slot 10 typed `ZM-PC-package`, as `ZM-CP-publish.vi` in 04a): the actors' overrides
  in phases 08-10 copy it.
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions and `Methods` placement are the user's (list them). D39: icons
  without a prompt (done at the end of this step for the few VIs). D35: an interface override goes in the actor's
  `Methods` folder (phases 08-10, not here).
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; `lv_loadability.py` needs `--vilib`; `lvai_add_to_library` refuses a virtual
  folder that does not exist, and a new library has none, BUT the kit's `lvai_create_actor_library.xml` creates one
  (`AddItem` Type `Folder`) when it creates the library: use it with `messages folder` = `Messages`; messages added
  with `lvai_add_to_library` go into that folder (check `placedIn`); `lvai_create_message_class` REFUSES an interface
  method: run the kit's `lvai_create_message_class.xml` helper directly, then `repair_r1.py` (project closed)
  (skill `knowledge\labview-mcp.md`, "lvai_create_message_class"; measured in the pilot).

## Goal
`ZM-CI-common_interfaces.lvlib` under the project's `common` folder holding: the LabVIEW interface
`ZM-CI-package_handler.lvclass` with its one dynamic method `ZM-CI-handlePackage.vi` (public; in `package` typed
`ZM-PC-package`; no body: the class wire and the error pass through), and the message class `ZM-CI-handlePackage
Msg.lvclass` generated from that method the way NI's Message Maker makes it (inherits `Message.lvclass`; payload
`package`; `Send ZM-CI-handlePackage.vi` with inputs `enqueuer`, `package`; `Do.vi` casts the actor to the interface
and calls `ZM-CI-handlePackage`), in the library's `Messages` virtual folder. It is the only message class of the
application. The library depends on `ZM-PC-packages.lvlib` and the Actor Framework only. Then icons and cleanup for
the VIs made here, and the closing checks.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Library folder (create): `...\src\common\ZM-CI-common_interfaces\` holding `ZM-CI-common_interfaces.lvlib`, the
  interface folder `ZM-CI-package_handler\` (`ZM-CI-package_handler.lvclass`, `ZM-CI-handlePackage.vi`) and the message
  folder `ZM-CI-handlePackage Msg\` (`ZM-CI-handlePackage Msg.lvclass`, `Send ZM-CI-handlePackage.vi`, `Do.vi`).
- Actor Framework: `C:\Program Files (x86)\National Instruments\LabVIEW 2026\vi.lib\ActorFramework\` (`Message\Message.lvclass`
  is the message parent). Message Template (found by the manager on this station): `C:\Program Files (x86)\National
  Instruments\LabVIEW 2026\resource\Framework\Providers\MessageMakerProvider\_Message Maker\_templates\Message Template\Message Template.lvclass`. Packages: `...\src\common\ZM-PC-packages\ZM-PC-package\ZM-PC-package.lvclass`.
- AIXML sources `...\proof\ZMP-07\`; icons `...\proof\icons\`; read-back `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\rb\07\`;
  helpers `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `knowledge\labview-mcp.md` ("Known gaps":
  `lvai_create_class, lvai_create_interface`, `lvai_add_to_library`, `lvai_create_message_class`, "Evidence, git,
  build order"), `knowledge\actor-framework.md` ("Messages"), `kit\README.md`, `kit\lvai_create_actor_library.xml`,
  `kit\lvai_create_message_class.xml` (inputs: `destination directory`, `class name`, `template path`, `parent class
  path`, `actor class path`, `actor method path`, `actor method name`; project open and ACTIVE; every error indicator
  must read 0), `kit\repair_r1.py` (`python repair_r1.py "<Msg.lvclass>" ZM-CI-handlePackage --check` then without),
  `ops\sweep.md`, `ops\cleanup.md`, `ops\icons.md`.
- Conventions: `...\.labview\conventions\naming.md` (`override-names`: Message Maker products keep the tool's names),
  `layout.md`, `af-shapes.md` (`messages`, `dependency-direction`), `hygiene.md`, `icons.md` (`messages: keep` is not
  implemented by the kit; generate the message VIs' icons like any VI, D39). Spec:
  `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.3 (lines 348-356), §3, §4, §1;
  `01-requirements.md` R5; `04-decisions.md` D17.

## Route and order (interface → method → library with the Messages folder → message class → repair → add to folder)
1. `lvai_status`; project closed; `git status --short`; commit point.
2. **Interface** `ZM-CI-package_handler.lvclass` with `lvai_create_interface` (read its description; it mirrors
   `lvai_create_class`; `projectPath` = the project). `lvai_describe_class`/the XML: an interface, no private data.
   `lvproj_drop.py` strays. Commit `feat(ci): interface ZM-CI-package_handler`.
3. **Method** `ZM-CI-handlePackage.vi` (`lvai_add_class_method`, dynamic dispatch, public): pane = the interface in/out
   (dynamic), `error in`/`error out`, and `package` typed `ZM-PC-package` on an input slot (03a's object form for the
   retype; the class constant seed swapped if needed). Body: nothing but the pass-through of the interface wire and
   the error (the `package` control unwired is fine). Description: "Interface method: delivers one package to the
   actor that implements ZM-CI-package_handler. No logic here; each actor's override decides." Cold state 1. Commit.
4. **Library** `ZM-CI-common_interfaces.lvlib` with a `Messages` virtual folder, holding the interface: the kit's
   `lvai_create_actor_library.xml` as is (`library path`, `messages folder` = `Messages`, `class path` = the
   interface, `class item name` = `ZM-CI-package_handler.lvclass`), project open and active, errors 0; then closed:
   `lvproj_drop.py`, `lvproj_move.py "ZM-CI-common_interfaces.lvlib" common`; reopen/close once. The `.lvlib` XML lists
   the `Messages` folder and the interface. Commit.
5. **Message class** by the kit helper (project open and active): `destination directory` = the library folder (the
   helper makes the class folder `ZM-CI-handlePackage Msg\` inside it, or report where it put it and move nothing by
   hand: if it lands elsewhere, stop and report), `class name` = `ZM-CI-handlePackage Msg`, `template path` = the
   Message Template class found under the AF tree, `parent class path` = `Message.lvclass`, `actor class path` = the
   interface `.lvclass`, `actor method path` = `ZM-CI-handlePackage.vi`, `actor method name` = `ZM-CI-handlePackage`.
   Every error indicator 0; `payload control count` 1; `new send method` = `Send ZM-CI-handlePackage.vi`. Close the
   project (it saves). Then `python <skill>\kit\repair_r1.py "<Msg.lvclass>" ZM-CI-handlePackage --check`, then without
   `--check` (project closed): exit 0. Commit `feat(ci): message class ZM-CI-handlePackage Msg (Message Maker route)`.
6. **Membership:** `lvai_add_to_library` the message class into `ZM-CI-common_interfaces.lvlib`, virtual folder
   `Messages` (check `placedIn`; one add re-saves every member of the library, report it). Project closed afterwards;
   `lvproj_drop.py` strays. Commit.
7. **Proof:** project closed; cold sweep of `src\common\ZM-CI-common_interfaces\` (every VI state 1, control `0 7`,
   `check_membership.py` clean); export `Do.vi` and `Send ZM-CI-handlePackage.vi` (`lvai_convert_vi_to_aixml`): `Do.vi`
   casts the actor to `ZM-CI-package_handler` (To More Specific Class) and calls `ZM-CI-handlePackage` with the
   payload; `Send` has `enqueuer` and `package` inputs; quote the Call lines. The message `.lvclass` XML: parent
   `Actor Framework.lvlib:Message.lvclass` (Parent Libraries block), members `Do.vi`, `Send ZM-CI-handlePackage.vi`,
   `Send ZM-CI-handlePackage.vi` not `Send Template.vi`. `lv_loadability.py --links` on every VI: links only into
   this library, `src\common\ZM-PC-packages\` and `vi.lib\ActorFramework`; none into `ZM-HW*`, `ZM-CP*`, `ZM-CU`,
   `ZM-TST`. `lv_save_version.py` all 26. The `.lvproj` `common` folder lists three libraries once each.
8. Cleanup (`ops\cleanup.md`) on `ZM-CI-handlePackage.vi` only (the Message Maker VIs are NI-generated: leave their
   diagrams; say so); icons (`make_icons.py`, `ops\icons.md` steps 3-8) for the interface, the message class, the
   library and their VIs per the spec's owners (`ZM-CI-package_handler`, `ZM-CI-handlePackage Msg`, lib
   `ZM-CI-common_interfaces`), read back 0 px. Commit per owner.
9. Final sweep as in 7; `lvai_status`; `git status --short` clean.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed; `repair_r1.py`
  is a kit script). **Never author `Do.vi` or `Send` yourself**: only the Message Maker helper. AIXML with the Write
  tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache. Nothing
  under `src\common\ZM-PC-packages\`, `ZM-CU`, `src\hardware\`, `src\protocol\`, `src\tests\` may change.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.3; nothing extra (one method, one message). Ambiguity →
  `NEEDS CLARIFICATION`.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. The interface (describe/XML), the method (pane, dynamic, state).
3. The library route (folder created?), the `.lvlib` items, the `.lvproj` `common` lines. 4. The message helper's
indicators, the repair script's output, the message `.lvclass` parent and members, the `Do.vi`/`Send` export lines.
5. Sweep, membership, versions, links. 6. Cleanup and icons blocks (short). 7. Commits; `git status`.
8. Deviations / unmeasured / NEEDS CLARIFICATION; items for the user in the IDE (interface description, `Methods`
folder for the method). 9. Side effects.
