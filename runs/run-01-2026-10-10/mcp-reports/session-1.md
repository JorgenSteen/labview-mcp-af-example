# labview-mcp report: run-01, session 1 (2026-10-10 14:40 to 2026-10-11 09:40)

## Environment

- LabVIEW 2026 Q3 32-bit (`LabVIEW_32_26.3.1f1`), `C:\Program Files (x86)\National Instruments\LabVIEW 2026\`; four
  LabVIEW installs on the station (2026 x86, 2025 x86, 2024 x64, 2020 x86).
- labview-mcp server 1.9.5-local.20261010-1430 (f9ee41d9), local plugin build.
- LabVIEW started by the manager twice (`lvai_ensure_labview`): PID 2428 at 15:06 (crashed 15:13:55 in
  `lvai_validate_aixml`, F2), PID 14040 at 15:24 (still running at the hand-over). No restart by an agent. Nigel chat
  never needed. The plugin failed to connect at session start and reconnected after the user's `/mcp`.

## Use

| step | agent (type, fresh or resumed) | LabVIEW calls | wall clock | result |
|---|---|---|---|---|
| 00b | general-purpose, fresh, resumed once | ~10 | 15:09-15:29 | project with six virtual folders by a VI Server helper (route b) after one crash |
| 00a | general-purpose, docs only | 0 | 15:36-15:42 | `.labview/` |
| 01a | general-purpose | ~25 | 15:38-15:45 | 3 classes, 5 typedefs, 10 accessors |
| 01b | general-purpose, resumed once (usage limit) | ~75 | 15:52-16:32 | 14 methods, 2 pane bindings, library, 4 overrides; trap T1 |
| 01c | general-purpose | ~22 | 16:36-16:47 | test library, T1 PASS |
| 01d | general-purpose | 8 | 16:50-16:56 | cleanup 25 VIs, icon spec, preview |
| 01e | general-purpose | 51 | 17:48-17:58 | icons applied, read back 0 px |
| 02a | general-purpose | 23 | 18:01-18:12 | log VI, library, T2 PASS |
| 02b | general-purpose | 14 | 18:15-18:19 | cleanup, icons |
| 03a | general-purpose | 25 | 18:23-18:28 | HW parent, 5000 placeholder with FreeLabel |
| 03b | general-purpose, resumed once (usage limit) | ~38 | 18:33-22:02 | SIM child, T3 PASS |
| 03c | general-purpose | 33 | 22:05-22:13 | cleanup, icons |
| 04a | general-purpose | 22 | 22:16-22:22 | CP parent |
| 04b | general-purpose | ~53 | 22:27-22:43 | file logger, T4 PASS (six checks) |
| 04c | general-purpose | 39 | 22:47-22:56 | cleanup, icons |
| 05a | general-purpose, resumed once (usage limit), then stopped (model limit) | not reported | 23:01-~03:00 | UDP classes, library, bare overrides; hooks not done |

Routes that worked on this station, each with its report: project creation by `Project.New` → `My Computer` →
`AddItem` Type "Folder" (with a required empty Path) → `Save` (report-00b); a plain `.lvlib` by `Library.Create` →
`AddItem` → `Save All This Library`, project open and active (report-01b item 4); a class member with no class
terminal by the tool's `lvai_add_one_to_library.vi` on the `.lvclass` (report-03b item 3); a free label as
`<FreeLabel comment="...">` (report-03a item 3); a child hook after Call Parent with a parent-typed pane and a cast
inside (report-04b item 3); a test VI over several libraries by direct Calls with the project open (report-02a item 4).

## Issues

| # | issue | kind | where | workaround | candidate id |
|---|---|---|---|---|---|
| 1 | `lvai_validate_aixml` on an invented method of `{LV.Application}` terminated LabVIEW 2026 Q3 (`DWarn 0x762E6013: Out of bounds TypedObjList access`, `invoke.cpp(74)`, minidump fd529ccf-601a-49a4-d740-28409e75b42d). The plugin's own `ni-bug-validateaixml-crash.md` says an invented METHOD on a known class is reported, not a crash | crash | report-00b item 6; findings F2 | never probe names; take spellings from `resource\lvserver.rsc` | (new) validate-probe-crash |
| 2 | no tool creates a `.lvproj`, a plain `.lvlib`, or a virtual folder in a new library | tool gap | reports 00b, 01b | VI Server helpers derived from the kit's `lvai_create_actor_library.xml` | project-item-tools, library-virtual-folder |
| 3 | no tool sets a class description, adds a `.ctl` to a class, or places a member in a class virtual folder (only `Accessors` via `lvai_create_accessors`) | tool gap | report-01a items 3, 8; findings F4; D38 | the user does it in the IDE | add-to-class, (new) class-description |
| 4 | a hook after Call Parent in a dynamic override typed as the child reads state 0 with only "VI is not executable" | LabVIEW fact / trap | report-01b item 9 (T1) | parent type on the hook pane, cast inside | (knowledge) |
| 5 | `lvai_add_class_method` refuses a member with no class terminal; `lvai_add_to_library` refuses a `.lvclass` | tool gap | report-03b item 3 | the tool's `lvai_add_one_to_library.vi` on the `.lvclass` | add-to-class |
| 6 | `lvai_create_class` strips the `.lvproj` BOM; library closes leave a stray top-level class item in some cases, not in others | tool quirk | reports 03a, 03b, 04a | `lvproj_drop.py` after every library close | project-item-tools |
| 7 | the runner's own helper `lvai_run_and_read_typed.vi` was a 14-byte stub (error 1059) | tool bug | report-00b item 2e-f | `regenerateHelper: true` once | (new) runner-helper-stub |
| 8 | the validator leaves hidden unsaved `LVMCP Validate*` VIs in memory; `lv_windows.ps1` counts them as unsaved | tool quirk | reports 02a-04c | ignore them by name | dialog-detection (window filter) |
| 9 | `lv_loadability.py --links` on a `.lvlib` or a folder prints only the target name | kit gap | reports 01e, 04a | pass VI paths | offline-loadability |
| 10 | `make_icons.py` does not draw the skill's own icon convention (white 3x5 banner, library glyph left) | kit gap (KT-4) | report-01d item 4; findings F5; D39 | accepted by the user | icon-generator |
| 11 | `Match Regular Expression` (XNode) and `Clear Errors.vi` terminal names are not authorable in AIXML | AIXML gap | reports 01c, 02a | `Match Pattern`; Unbundle → Equal? → Select | vi-server-catalogue |

## Proposed MCP candidates (for the skill's maintainer; nothing goes upstream without the user's go-ahead)

- **validate-probe-crash** (new): Gap: the documented "probe a name with `lvai_validate_aixml`" recipe can terminate
  LabVIEW. Proposed: the tool refuses names absent from its catalogue, or validates in an isolated instance.
  Evidence: issue 1. Workaround: offline spellings. Removes: the probing recipe in `knowledge/labview-mcp.md`.
- **class-description** (new): Gap: no tool writes `NI.Lib.Description` on a class or library. Proposed: an input on
  `lvai_create_class` and a setter. Evidence: issue 3. Workaround: the user in the IDE (D38).
- **runner-helper-stub** (new): Gap: the runner's cached helper can be a stub. Proposed: the runner checks size or
  version before use. Evidence: issue 7.
- New evidence for **add-to-class**, **project-item-tools**, **library-virtual-folder**, **icon-generator**,
  **offline-loadability**: issues 2, 3, 5, 6, 9, 10.

## Knowledge proposed for `<skill>/knowledge/`

- The hook-typing rule (issue 4) with its measured cast-inside form, for `knowledge/actor-framework.md` or
  `ops/override.md` ("B-after on a plain-class override").
- The AIXML spellings in issue list "Routes that worked" (project, library, FreeLabel).

## Side effects

As `status.md`, "Side effects (session 1, unshortened)": LabVIEW started twice by the manager (one crash), PID 14040
running at the end with the project open and LVAutoSave 2; stub cache 145 → 169; helper VIs `zm_*` left in the
helpers folder; read-back folders; no item removed; nothing upgraded; nothing copied into `user.lib\errors\`.

## Open at the end

The project is open in LabVIEW with unsaved edits; 05a's hooks remain (brief 05a2); phases 05b-13.
