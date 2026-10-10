# Brief 04b: `ZM-CP-FL-file_logger` class and library, its hooks and overrides, and `ZM-TST-protocol.vi` (T4 without MX)
Type: build + test (LabVIEW calls). Phase 04 step b of 3 (a: the parent, done; c: cleanup, icons, sweep).

## UPDATES (read first)
- Reports to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-04a-cp-parent.md`
  (the parent class, its panes, the library route), `report-03b-hw-sim-test.md` (a child class in its own library,
  a dynamic override with its own body, a test VI calling two libraries), `report-01b-pc-methods-library.md`
  (item 5: an override WITH Call Parent via `lvai_create_override` + `pa_insert_series2` shape B-after, and trap T1:
  the hook after Call Parent takes and returns the PARENT class type).
- Facts from report 04a: the parent's panes are 4815 with class in 11, `error in` 8, class out 3, `error out` 0;
  `ZM-CP-publish.vi` has `package` (required input, typed `ZM-PC-package`) on conIdx 10: copy that pane for the FL's
  `publish` override (`lvai_connector_pane` on the parent's VI). The parent's accessor `Write opened` is PRIVATE: the
  child never calls it (the parent's `init`/`close` do, through Call Parent). The library helper
  `zm_create_class_library.vi` is cached (inputs library path, class path 1, class item name 1); after its close
  always run `lvproj_drop.py` (it may or may not leave a stray class item), then `lvproj_move.py`. `lvai_create_class`
  strips the `.lvproj` BOM (restored by the next close). `lv_loadability.py --links` wants VI paths. A placeholder with
  required class/package inputs runs directly in the runner with defaults (no probe VI needed). The 03b route for a
  pure function member (no class terminal; `buildPath` and `appendLine` here!) is: `lvai_generate_vi` →
  `lvproj_add_toplevel.py` (project closed) → the tool's cached `lvai_add_one_to_library.vi` helper with `library
  path` = the `.lvclass`, item type VI, folder index -1, project open and active → `set_scope.py` private
  (report-03b, item 3). `createFolder` has class terminals (it reads `outputFolder`) and goes through
  `lvai_add_class_method` like a hook; type its class terminals as the PARENT (T1) since it is hooked after Call
  Parent, and read `outputFolder` through... NOTE: `Read outputFolder` is an FL accessor taking the FL type; a hook
  typed as the parent cannot call it without a cast. Measure as 05a's brief describes: parent-typed pane + `To More
  Specific Class` inside the hook first; if the override reads state 0 cold, try the child type on the hook pane
  and report which worked with exec states (this is the first child hook that reads a CHILD field; 01b's hooks
  wrote a PARENT field).
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions, `.ctl` membership and `Methods` placement are the user's (list
  them). D39: icons without a prompt (step c).
- **T4 scope decided by the manager (phase card 04):** `mx_placeholder_ok` needs the MX class of phase 05, so T4 is
  built here WITHOUT it: `Pass` = AND of `init_ok`, `files_ok`, `lines_ok`, `append_ok`, `placeholder_ok`,
  `close_ok`. Phase 05 adds `mx_placeholder_ok`. Say so in the test's description.
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; a VI must be a project item before the library helper adds it; the library
  helper runs with the project OPEN AND ACTIVE; `Match Regular Expression` is not authorable; `Equal?` on clusters
  is element-wise; `Clear Errors.vi` terminal names are not derivable (clear one code with Unbundle → Equal? →
  Select); a hook after Call Parent in a dynamic override takes and returns the parent class type (T1).

## Goal
The pluggable file-logger child in its own library: `ZM-CP-FL-file_logger.lvclass` (parent
`ZM-CP-communication_protocol`), field `outputFolder` (Path), accessors `Read outputFolder` (private) and `Write
outputFolder` (public), the static privates `ZM-CP-FL-createFolder.vi`, `ZM-CP-FL-buildPath.vi`,
`ZM-CP-FL-appendLine.vi`, the `ZM-CP-init.vi` override (Call Parent → `createFolder`) and the `ZM-CP-publish.vi`
override (own body), wrapped in `ZM-CP-FL-file_logger.lvlib` under `protocol`, depending on
`ZM-CP-communication_protocol.lvlib` and `ZM-PC-packages.lvlib` only. Then `ZM-TST-protocol.vi` (T4 without MX)
in `ZM-TST-tests.lvlib`, run cold until `Pass` true.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\protocol\ZM-CP-FL-file_logger\ZM-CP-FL-file_logger\`; library file
  `...\src\protocol\ZM-CP-FL-file_logger\ZM-CP-FL-file_logger.lvlib`. Parent:
  `...\src\protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol\ZM-CP-communication_protocol.lvclass`
  (qualified `ZM-CP-communication_protocol.lvlib:ZM-CP-communication_protocol.lvclass`), parent methods beside it.
- Packages: `...\src\common\ZM-PC-packages\` (`ZM-PC-package\ZM-PC-getTypeName.vi`, `ZM-PC-getDataAsJson.vi`,
  `ZM-PC-init.vi`; `ZM-PC-TP-test_package\ZM-PC-TP-create.vi`; `ZM-PC-EP-error_package\ZM-PC-EP-create.vi`).
  Test: `...\src\tests\ZM-TST-protocol.vi`; `...\src\tests\ZM-TST-tests.lvlib`. T4's temp folder: a fresh folder
  under `...\zuehlke-mcp-af-test-results\output\test_fl_<tick>\` (git-ignored), created by `init`.
- AIXML sources `...\proof\ZMP-04b\`; evidence `...\proof\runs\04b-checks.txt`; helpers
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md`, `ops\override.md`
  (sections 1, 3 B-after, 4), `ops\run-checks.md`, `ops\sweep.md`, `knowledge\labview-mcp.md`, `kit\README.md`.
- Conventions: `...\.labview\conventions\naming.md`, `layout.md`, `errors.md`, `hygiene.md`; `checks.json` entry
  `ZM-TST-protocol`. Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.7 (lines
  388-401), §3.1 (125-140), §1; `03-acceptance.md` T4; `01-requirements.md` R4, R6; `04-decisions.md` D3, D10.

## What to build, in this order (class → accessors → methods → library → overrides → test)
1. **Class** `ZM-CP-FL-file_logger.lvclass`, `parentClassPath` = the parent above, one plain field `path.outputFolder`.
   `lvproj_drop.py` a stray parent item if any. Commit.
2. **Accessors**: `Read outputFolder` (private) and `Write outputFolder` (public), both static (`set_scope.py`,
   project closed; the pair is wanted here, both directions are used). Commit.
3. **Static private methods** (`lvai_add_class_method`, static; `set_scope.py` private):
   | VI | terminals | body |
   |---|---|---|
   | `ZM-CP-FL-createFolder.vi` | class in/out, error | `Read outputFolder` → `Create Folder`; an "already exists" error (code 10) cleared by Unbundle code → Equal? 10 → Select, as 02a did; other errors pass |
   | `ZM-CP-FL-buildPath.vi` | in `folder` (Path), `type_name` (String); out `file` (Path) | `Build Path(folder, type_name + ".jsonl")` (no class wire needed on the pane beyond what the tool requires for a member) |
   | `ZM-CP-FL-appendLine.vi` | in `file` (Path), `line` (String) | open or create → set file position to end → write `line` + `\n` (one LF, nothing else) → close |
   Descriptions. Commit.
4. **Library** `ZM-CP-FL-file_logger.lvlib` holding the class (cached helper, project open and active; then closed:
   `lvproj_drop.py`, `lvproj_move.py "ZM-CP-FL-file_logger.lvlib" protocol`; reopen/close once). The `.lvproj`
   `protocol` folder lists both CP libraries once each. Commit.
5. **Overrides** (after the library, `ops\override.md`):
   - `ZM-CP-init.vi`: `lvai_create_override` with `parent method path` = the parent's `ZM-CP-init.vi`, `vi name in
     memory` = `ZM-CP-FL-file_logger.lvlib:ZM-CP-FL-file_logger.lvclass:ZM-CP-init.vi`; commit; then hook
     `ZM-CP-FL-createFolder.vi` after Call Parent, shape B-after (`pa_insert_series2`, class block A on `<C> out`,
     error block B on `error out`), `pa_save_member` separately. **Trap T1:** `createFolder`'s class terminals must be
     typed as the PARENT (`ZM-CP-communication_protocol in`/`out`) even though it is a member of the child; if step 3
     made it with the child type, regenerate it with the parent type BEFORE hooking (as 01b ended up doing).
     Export and confirm Call Parent → createFolder → outputs. Commit.
   - `ZM-CP-publish.vi`: `lvai_add_class_method` with the parent's pane (`lvai_connector_pane` on the parent's
     `ZM-CP-publish.vi`) and `dispatchTerminals`, own body, no Call Parent: `Read outputFolder` →
     `ZM-CP-FL-buildPath(folder, package.getTypeName)` → `ZM-CP-FL-appendLine(file, package.getDataAsJson)`. Error
     chain through every call. Description. Prove dynamic (`lvai_describe_class`) and cold state 1 for child and
     parent `publish`. Commit.
6. **`ZM-TST-protocol.vi`** (T4 without MX), indicators exactly: `init_ok` (an FL constant with `Write outputFolder` =
   the fresh temp folder, on a `ZM-CP-communication_protocol` wire: `init` without error and the folder exists),
   `files_ok` (publish 2 TP packages, 1 bare parent package after `init`, 1 EP → `TestPackage.jsonl` has 2 lines,
   `Undefined.jsonl` 1, `ErrorPackage.jsonl` 1), `lines_ok` (every line of each file unflattens and its `type` key
   equals the file's name without `.jsonl`), `append_ok` (one more TP publish → `TestPackage.jsonl` 3 lines),
   `placeholder_ok` (a bare `ZM-CP-communication_protocol` constant: `publish` returns code 5000; wired into the
   indicator logic, not into `error out`), `close_ok` (`close` on the FL without error), `Pass` = AND of six,
   `error out`. Line counting: read the whole file, count LF. Route as 03b (direct Calls, project open with a member
   of each library opened through it). Add to `ZM-TST-tests.lvlib` (`lvai_add_to_library`). Description: "T4 without
   mx_placeholder_ok (added in phase 05) ...". Commit `test(cp): ...`.
7. **Run** per `ops\run-checks.md` (entry `ZM-TST-protocol`); fix the test or this phase's VIs (max three rounds);
   a `ZM-PC` VI at fault = stop with the reading. Evidence file written.
8. **Checks:** cold sweep of `src\protocol\` and `src\tests\`; `check_membership.py`; `lv_save_version.py` (26);
   links of the FL VIs only into `src\protocol\` and `src\common\ZM-PC-packages\`; none into
   `vi.lib\ActorFramework`, `ZM-CU`, `ZM-HW`, `ZM-TST`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\`, `src\hardware\` may change; the 04a parent files only if step 7 proves one at fault.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.7 and `03` T4; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Class, accessors, members (scope/dynamic) from the XML. 3. The
override block of `ops\override.md` (init: hook shape, T1 handling, export evidence; publish: how made, exec
states). 4. Library route; `.lvproj` `protocol` lines. 5. T4: run-checks block (every indicator, rounds, fixes),
the temp folder used. 6. Sweep, membership, versions, links. 7. Commits; `git status`. 8. Deviations / unmeasured /
NEEDS CLARIFICATION; items for the user in the IDE. 9. Side effects.
