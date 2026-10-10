# Brief 03b: `ZM-HW-SIM-simulated_hardware` class and library, `randomData`, the `do` override, and `ZM-TST-hardware.vi` (T3)
Type: build + test (LabVIEW calls). Phase 03 step b of 3 (a: the parent, done; c: cleanup, icons, sweep).

## UPDATES (read first)
- Report to read first: `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\reports\report-03a-hw-parent.md`
  (the parent class, its pane, how the 5000 placeholder and its label were authored, the library route).
  Also `report-01b-pc-methods-library.md` (item 5: a dynamic override with its own body via `lvai_add_class_method`
  with the parent's pane and `dispatchTerminals`; item 3: pane typedef binding) and `report-02a-cu-log-test.md`
  (item 4: the direct Call route for a VI that calls library members).
  <<MANAGER: traps from reports 02b/03a go here before launch>>
- Save version **26.0**. User go-ahead (2026-10-10 15:22, extended 15:30): you may start or restart LabVIEW yourself
  when it crashes or stops answering, per `<skill>\session\start.md`, at most two starts in this step, each reported.
  Never answer a dialog. D38: class descriptions, `.ctl` membership and `Methods`/`TypeDefs` placement are the
  user's job in the IDE: do not ask, do not hand-edit, list them. D39: icons without a prompt (step c).
- **`02` §3.1 wins over the phase card:** the SIM overrides ONLY `do` (own body, no Call Parent). It does NOT
  override `init` or `close`.
- Traps: never probe a VI Server name with `lvai_validate_aixml`; `regenerateHelper: true` once on runner error
  1059; `sweep_paths.py` needs `--out`; a VI must be a project item before the library helper adds it; the library
  helper runs with the project OPEN AND ACTIVE, then `lvproj_drop.py`/`lvproj_move.py` with it closed;
  `Match Regular Expression` is not authorable (use `Match Pattern`); `Equal?` on clusters is element-wise;
  `Clear Errors.vi` terminal names are not derivable (clear one code with Unbundle → Equal? → Select).

## Goal
The pluggable child in its own library: `ZM-HW-SIM-simulated_hardware.lvclass` (parent `ZM-HW-hardware`, no fields,
no accessors), `ZM-HW-SIM-randomData.vi` (private, static), the `ZM-HW-do.vi` override (own body), wrapped in
`ZM-HW-SIM-simulated_hardware.lvlib` under the project's `hardware` folder, depending on `ZM-HW-hardware.lvlib` and
`ZM-PC-packages.lvlib` only. Then `ZM-TST-hardware.vi` (T3) in `ZM-TST-tests.lvlib`, run cold until `Pass` true.

## Paths (absolute, long form)
- Product folder `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`; project `...\src\Zuehlke MCP.lvproj`.
- Class folder (create): `...\src\hardware\ZM-HW-SIM-simulated_hardware\ZM-HW-SIM-simulated_hardware\` (class and VIs
  flat); library file `...\src\hardware\ZM-HW-SIM-simulated_hardware\ZM-HW-SIM-simulated_hardware.lvlib`.
- Parent: `...\src\hardware\ZM-HW-hardware\ZM-HW-hardware\ZM-HW-hardware.lvclass` (library `ZM-HW-hardware.lvlib`,
  qualified `ZM-HW-hardware.lvlib:ZM-HW-hardware.lvclass`); parent method `...\ZM-HW-hardware\ZM-HW-do.vi`.
- Packages: `...\src\common\ZM-PC-packages\` (`ZM-PC-TP-test_package\ZM-PC-TP-create.vi`, `ZM-PC-TP-DATA.ctl`,
  `ZM-PC-package\Write destination.vi`, `ZM-PC-DESTINATION.ctl`, `ZM-PC-getTypeName.vi`, `ZM-PC-getDataAsJson.vi`,
  `ZM-PC-getDestinationName.vi`). Test: `...\src\tests\ZM-TST-hardware.vi`; test library `...\src\tests\ZM-TST-tests.lvlib`.
- AIXML sources `...\proof\ZMP-03b\`; evidence `...\proof\runs\03b-checks.txt`; helpers
  `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\`.
- Skill `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`): `ops\class-field.md` ("New classes"),
  `ops\run-checks.md`, `ops\sweep.md`, `knowledge\labview-mcp.md` ("Operating rules", "Evidence, git, build order",
  "Known gaps": `lvai_create_class`, `lvai_add_class_method`, `lvai_bind_pane_typedef`, `lvai_generate_vi`,
  `lvai_add_to_library`), `kit\README.md`.
- Conventions: `...\.labview\conventions\naming.md`, `layout.md`, `errors.md`, `hygiene.md`; `checks.json` entry
  `ZM-TST-hardware`. Spec: `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` §7.5 (lines
  368-376), §3.1 (125-140), §1; `03-acceptance.md` T3; `01-requirements.md` R3.

## What to build, in this order (class → methods → pane binding → library → override → test)
1. **Class** `ZM-HW-SIM-simulated_hardware.lvclass`, `parentClassPath` = the parent `.lvclass` above (in its library),
   no fields (`lvai_create_class` with an empty field list, or whatever the tool needs for "no fields"; report it),
   `projectPath` = the project. `lvai_describe_class`: parent `ZM-HW-hardware.lvlib:ZM-HW-hardware.lvclass`. Check the
   `.lvproj` for a stray top-level parent item (`lvproj_drop.py`, project closed). Commit `feat(hw): class
   ZM-HW-SIM-simulated_hardware (parent ZM-HW-hardware)`.
2. **`ZM-HW-SIM-randomData.vi`** (ST, private; out `data`, a cluster shaped like `ZM-PC-TP-DATA.ctl`
   `{temperature_c: DBL, sample_index: I32, duty_percent: U8, sensor_ok: Boolean, status: String}`, then
   `lvai_bind_pane_typedef` to `...\ZM-PC-TP-test_package\ZM-PC-TP-DATA.ctl`, proven from the file as in 01b):
   `Random Number (0-1)` five times: `temperature_c` = 20 + 10·r; `sample_index` = floor(1000·r) (I32);
   `duty_percent` = floor(101·r) (U8); `sensor_ok` = r > 0.1; `status` = `{"ok","warm","cold"}[floor(3·r)]` (Index
   Array on a string-array constant). Description. Scope private (`set_scope.py`, project closed). Commit.
3. **Library** `ZM-HW-SIM-simulated_hardware.lvlib` holding the class (the 01b helper route, project open and
   active; then closed: `lvproj_drop.py` strays, `lvproj_move.py "ZM-HW-SIM-simulated_hardware.lvlib" hardware`;
   reopen/close once, no dialog). The `.lvproj` `hardware` folder lists both HW libraries once each. Commit.
4. **`ZM-HW-do.vi` override** (OVR, public, dynamic, own body, NO Call Parent): `lvai_add_class_method` with the
   parent's pane read by `lvai_connector_pane` on the parent's `ZM-HW-do.vi` and `dispatchTerminals`, as 01b did
   for `getDataAsJson`. Body: `ZM-HW-SIM-randomData` → `ZM-PC-TP-create` (`data` in; `package` out, typed
   `ZM-PC-TP-test_package`) → `Write destination` = `Communication` (a `ZM-PC-DESTINATION.ctl`-shaped enum constant
   `{Unknown, Root, Hardware, Communication}` value 3; `Write destination` is a parent-class static, so its
   package input takes the TP wire and its output is `ZM-PC-package`) → the `package` output terminal (typed
   `ZM-PC-package`, as the parent's pane says). The class wire of the SIM passes straight from `in` to `out`. Error
   chain through every call. Description. Prove: `lvai_describe_class` shows `ZM-HW-do.vi` dynamic; cold
   `lvai_exec_state` 1 for the override, the parent's `do`, and `randomData`. Commit `feat(hw): ZM-HW-do override of
   ZM-HW-SIM-simulated_hardware`.
5. **`ZM-TST-hardware.vi`** (T3), indicators exactly: `sim_ok` (a SIM constant on a `ZM-HW-hardware` wire:
   `init` → `do` three times → `close` without error, and each package's `getTypeName` = `TestPackage`),
   `sim_destination_ok` (each package's `getDestinationName` = `Communication`), `ranges_ok` (per package, from
   `getDataAsJson` → `Unflatten From JSON` into a header+data cluster as 01c did: `temperature_c` in [20, 30),
   `sample_index` in [0, 999], `duty_percent` in [0, 100], `status` in {ok, warm, cold}), `varies_ok` (the three
   `sample_index` values are not all equal), `placeholder_ok` (a bare `ZM-HW-hardware` constant: `do` returns code
   5000 and `source` = `ZM-HW-do.vi: must be overridden by a child class`; wire that error into the indicator logic,
   not into `error out`), `Pass` = AND of five, `error out` (the SIM chain's error). Route as 02a (direct Calls with
   the project open and a member of each library opened through it; class constants of two libraries), or stubs +
   swaps as 01c. Add to `ZM-TST-tests.lvlib` with `lvai_add_to_library`. Description. Commit `test(hw): ...`.
6. **Run** per `ops\run-checks.md` (entry `ZM-TST-hardware`; loadability, returns, cold run, evidence file). Fix
   the test when the test is wrong; a SIM/parent VI of this phase at fault = fix it (this phase's code; the parent's
   files belong to 03a, say so), regenerate, re-add to its library if membership is lost, commit, re-run; max three
   rounds. Any `ZM-PC` VI at fault = stop with the reading.
7. **Checks:** cold sweep of `src\hardware\` and `src\tests\` (`ops\sweep.md`); `check_membership.py`;
   `lv_save_version.py` on every file written (26); dependency links of the SIM VIs: only into
   `src\hardware\` and `src\common\ZM-PC-packages\`; none into `vi.lib\ActorFramework`, `ZM-CU`, `ZM-TST`, `ZM-CP`.

## Hard rules
Operating rules: `<skill>\knowledge\labview-mcp.md`, "Operating rules".
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- LabVIEW restarts: as UPDATES says (max two, reported). A modal dialog: `lv_windows.ps1`, stop that chain, never
  answer it. No retry loops.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active: open yours first, pass
  projectPath. No hand edits of .vi .ctl .lvclass .lvlib .lvproj (kit scripts only, project closed). AIXML with the
  Write tool. Absolute long-form paths. Nothing outside the product folder except helpers and the stub cache.
  Nothing under `src\common\` may change; the 03a parent files change only if step 6 proves one at fault.
- Commit before every structural step, explicit paths, Conventional Commits, no attribution trailer. Never push.
  Save version 26.0 or stop. Names only from `02` §7.5 and `03` T3; nothing extra. Ambiguity → `NEEDS CLARIFICATION`.

## Report (max 60 lines), as your final message
1. `lvai_status` start/end; starts made. 2. Class: describe_class (parent), members with scope/dynamic from the
XML. 3. `randomData` pane binding proof; the override: how it was made, exec states. 4. Library route; the `.lvproj`
`hardware` lines. 5. T3: the run-checks block (every indicator, rounds, fixes). 6. Sweep, membership, versions,
links. 7. Commits; `git status`. 8. Deviations / unmeasured / NEEDS CLARIFICATION; items for the user in the IDE.
9. Side effects.
