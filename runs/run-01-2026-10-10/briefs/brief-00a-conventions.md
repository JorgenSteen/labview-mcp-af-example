# Brief 00a: set up `.labview/` for the product folder (conventions, decisions, checks)
Type: build (files only: NO LabVIEW call in this brief)

> MANAGER, BEFORE LAUNCH: replace the three `<<FILL ...>>` markers under "Paths" with the values read from
> `lvai_status` this session. Do not launch while a marker is present.

## Goal
Run the `labview` skill's conventions setup for a brand-new project, with every answer given here so you ask
nothing, and write `.labview/` inside the product folder. Out of scope: anything in `src/` (no `.lvproj`, no
class, no VI; that is brief 00b), the harness (everything in the repo root except the product folder), and
LabVIEW itself (you make no `lvai_*`/`pylv_*` call at all).

## Paths (absolute, long form)
- Repo root (git): `C:\project\claude\LabVIEW-AFAItest`. Harness folders there are READ-ONLY for you:
  `requirements\`, `orchestration\`, `runs\`, `README.md`, `CLAUDE.md`.
- Product folder = the skill's `<repo>`: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`.
  Everything you write goes under it, in `.labview\`. Git commands run from the repo root (the product folder
  is a subfolder of the outer repository, not a repository of its own).
- Skill: `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`). Read `conventions\setup.md`,
  `conventions\dot-labview.md`, `conventions\defaults\*.md`, `conventions\templates\*`, `ops\run-checks.md`
  ("Entry format"), `ops\icons.md` ("Icon standard"). Nothing else of the skill is needed.
- Requirements (read-only): `C:\project\claude\LabVIEW-AFAItest\requirements\04-decisions.md` (the decided
  rules and their "why" to quote), `02-specification.md` §1, §2, §9 (names, abbreviations, disk layout),
  `03-acceptance.md` §1 and §2 (the checks).
- Machine facts (read by the manager from `lvai_status`): LabVIEW version `<<FILL labview_version>>`,
  save version `<<FILL save_version>>`, 32-bit, labview-mcp `<<FILL mcp_version>>`.

## Route: `<skill>\conventions\setup.md`, sections 1, 2, 4, 5, with these answers
Section 1 state: no `.labview/`, no LabVIEW code, repo under git. First-contact question: answered,
`analysis_depth` = `none`; but `conventions_mode` = `full` (defaults plus decided rules). Skip section 3.

**Section 2, `project.json`** (template `conventions\templates\project.json`; paths relative to the product
folder, forward slashes): `$schema_version` 2, `project_name` "Zuehlke MCP", `prefix` "ZM", `source_root` "src",
`project_file` "src/Zuehlke MCP.lvproj" (it does not exist yet; 00b creates it), `labview_version` and
`save_version` = the machine facts above, `git` true, `conventions_mode` "full", `analysis_depth` "none",
`restart_go_ahead` "ask", `proof_folder` "proof", `proof_prefix` "ZMP-",
`briefs_folder` "../runs/run-01-2026-10-10/briefs", `status_file` "../runs/run-01-2026-10-10/status.md",
`mcp_reports_folder` "../runs/run-01-2026-10-10/mcp-reports", `knowledge_files` []. No `commit_attribution`.

**Section 4, all seven concerns, answer = accept every default**, except the decided rules below, which you write
with `source: decided 2026-10-10 (decisions.md#Dn)` and the "why" quoted from `04-decisions.md`:

| D | goes into | as |
|---|---|---|
| D36 | `naming.md` `prefix` | add: top-level VIs with no owner keep `ZM-<name>.vi` (`ZM-launcher.vi`, `ZM-launcher_test.vi`, `ZM-receiver.vi`) |
| D4 | `naming.md`, new rule `element-labels` | the JSON keys are typedef element labels in snake_case: header `timestamp`, `type`, `destination`, `data`; data `temperature_c` DBL, `sample_index` I32, `duty_percent` U8, `sensor_ok` Boolean, `status` String; error data `sender`, `code`, `source`. Other element labels camelCase |
| D35 | `layout.md` `class-folders` | overrides of a parent class's or an interface's method go in `Methods` (no `Overrides` folder) |
| D37 | `layout.md` `library-per-actor` | the UDP sender and receiver share one library `ZM-CP-UDP-udp_transport.lvlib` and the abbreviation `UDP` |
| D14 | `errors.md` `plan-required` | the plan: HWM and CM log, send an error package (`ZM-PC-EP-error_package`, sender `HWM`/`CM`) to the caller, and stop with the error cleared after the parent (`stop actor?` stays T) so the Last Ack is clean; ROOT logs and stops with the error. Written in each actor's class description |
| D15 | `errors.md` `log-local` | the log is `ZM-CU-log.vi` in `ZM-CU-common_utilities.lvlib`, fixed file `output/ZM-error_log.txt` under the product folder, line `<ISO UTC timestamp>\t<message>`; callers write `<sender>\t<code>\t<source>` |
| D18 | `errors.md`, new rule `custom-error-codes` | codes 5000–5999, each registered in `docs/error-codes.md` and `src/errors/ZM-errors.txt`, and a free diagram label `#customerror <code>` where raised; ignored system codes (UDP 66, 56) listed there too |
| D34 | `configuration.md` | `status: off`; remove the default rules; one rule `no-config-files` (decided): no configuration files; output folder, UDP address and port, the 500 ms interval and the placeholder flag are defaults or launcher inputs passed down in pre-launch settings. The concern counts as asked and answered (2026-10-10) |
| D3, D16 | `decisions.md` only (design decisions) | D3: JSON Lines, one file per package type, `output/<type>.jsonl`, opened and closed per write. D16: a placeholder parent method returns error 5000; a child override calls its parent where the parent does real work |

`af-shapes.md`, `icons.md`, `hygiene.md`: defaults unchanged. `decisions.md` (template
`conventions\templates\decisions.md`): the ten entries D3, D4, D14, D15, D16, D18, D34, D35, D36, D37, keeping
these numbers, dated 2026-10-10, "Why" quoted from `04-decisions.md`. Do not add any other decision.

**`icon-spec.json`** (`.labview\conventions\icon-spec.json`, from `<skill>\kit\icon-spec.example.json`): owners =
the class folder names of `02` §9 plus `tests`, `receiver`, `launcher`; banners = the abbreviations of `02` §2
(`PC`, `PC-TP`, `PC-EP`, `CU`, `CI`, `HW`, `HW-SIM`, `CP`, `CP-FL`, `CP-UDP` for sender and receiver, `CP-MX`,
`HWM`, `CM`, `ROOT`, `TST`, `ZM` for the launchers, `RX` for the receiver VI); `libs` = the 13 shipped libraries
plus `ZM-TST-tests`; colours and glyph names taken from the pilot's
`C:\project\claude\LabVIEW-AFAItest\requirements\assets\icons\icon-spec.json` for the owner with the same
abbreviation (a value source only; owners that `02` does not have, such as `ZM-CM-init Msg`, are dropped; test VI
names become the `02` names `ZM-TST-packages.vi` etc.). Copy the pilot's `palette`, `lib_glyphs`, `glyphs` and
`rules` unchanged. Set `paths.out` to `proof/icons`. If anything here is ambiguous, write `icons.md` only, leave
the spec out, and say so in the report.

**`checks.json`** (`conventions\templates\checks.json`; entry format in `ops\run-checks.md`): seven `tests[]`
entries, kind `vi`, project `closed`, `read_only` `["Pass", "error out"]`, `returns` true, `inputs` `{}`,
`expected` `{"pass": "Pass", "error out code": 0}`, `evidence` `proof/runs/<X>-checks.txt`:
- T1 `ZM-TST-packages`, path `src/tests/ZM-TST-packages.vi`, class_under_test
  `src/common/ZM-PC-packages/ZM-PC-package/ZM-PC-package.lvclass`, side_effects none;
- T2 `ZM-TST-log`, `src/tests/ZM-TST-log.vi`, class_under_test
  `src/common/ZM-CU-common_utilities/ZM-CU-common_utilities.lvlib`, side_effects "two marker lines appended to
  output/ZM-error_log.txt";
- T3 `ZM-TST-hardware`, `src/tests/ZM-TST-hardware.vi`, class_under_test
  `src/hardware/ZM-HW-SIM-simulated_hardware/ZM-HW-SIM-simulated_hardware/ZM-HW-SIM-simulated_hardware.lvclass`, none;
- T4 `ZM-TST-protocol`, `src/tests/ZM-TST-protocol.vi`, class_under_test
  `src/protocol/ZM-CP-FL-file_logger/ZM-CP-FL-file_logger/ZM-CP-FL-file_logger.lvclass`, "writes JSONL files in a temp folder";
- T5 `ZM-TST-udp`, `src/tests/ZM-TST-udp.vi`, class_under_test
  `src/protocol/ZM-CP-UDP-udp_transport/ZM-CP-UDP-sender/ZM-CP-UDP-sender.lvclass`, "UDP on 127.0.0.1:61557; writes
  output/test_mx_a and output/test_mx_b";
- T6 `ZM-TST-pipeline`, `src/tests/ZM-TST-pipeline.vi`, class_under_test as T3, "writes JSONL files in a temp folder";
- T7 `ZM-TST-routing`, `src/tests/ZM-TST-routing.vi`, class_under_test
  `src/actors/ZM-ROOT-root/ZM-ROOT-root/ZM-ROOT-root.lvclass`, "lines appended to output/ZM-error_log.txt".

Two `runs[]` entries, path `src/ZM-launcher_test.vi`, project closed, steps
`[{"tool": "lvai_run_vi_and_read_values"}]`, timeout_s 60, evidence `proof/runs/<X>-runs.txt`, preconditions
"the launcher deletes the output files itself":
- `R-normal`: inputs `{"run_time_ms": "5000", "use_placeholder_hardware": "false"}`, repeat 3, expected
  `lines_written` 8–11, `error_lines` 0, `ui_errors` empty, `last_line` type TestPackage with five data fields and
  destination Communication, `error out code` 0;
- `R-error`: inputs `{"run_time_ms": "5000", "use_placeholder_hardware": "true"}`, expected `lines_written` 0,
  `last_line` empty, `error_lines` 1 (holds `HWM`, `5000`, `ZM-HW-do.vi`), `ui_errors` holds the ErrorPackage JSON,
  `error out code` 0.

**Section 5:** every convention file gets `written: 2026-10-10 by conventions/setup.md` and loses the
default-template note. Commit from the repo root by explicit paths:
`git add zuehlke-mcp-af-test-results/.labview` then
`git commit -m "docs(labview): set up conventions, decisions and checks for Zuehlke MCP"`
(NO attribution trailer of any kind). Then `git status --short` must show nothing.

## Hard rules
- No LabVIEW call in this brief: no `lvai_*`, no `pylv_*`, no helper VI, no `.vi`/`.lvproj` written.
- Write only under `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\.labview\`. The harness
  (`requirements\`, `orchestration\`, `runs\`, root files) is read-only; `src\`, `docs\`, `tools\` untouched.
- Names come from `02-specification.md` only. Do not rename or invent a name, a decision or a rule; if something is
  ambiguous, write a `NEEDS CLARIFICATION` block in the report and leave that part out.
- Absolute long-form paths in your own work; relative forward-slash paths inside `project.json` and `checks.json`.
- Commit by explicit paths, Conventional Commits, no AI attribution trailer. Never push.

## Report (max 40 lines), as your final message
1. Files written (paths) and the commit hash.
2. Per concern: counts of default / decided rules; `configuration.md` status.
3. `decisions.md`: the ten numbers present.
4. `project.json`: the three run-folder paths and the two version values as written.
5. `checks.json`: number of tests and runs.
6. `icon-spec.json`: written or deferred, and why.
7. Anything in `setup.md` that did not fit this placement (`.labview/` one level below the git root) or that you
   could not do as told.
8. Side effects outside `.labview\`: list, or "none".
