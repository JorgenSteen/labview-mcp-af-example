# Brief 00b: create the empty project `Zuehlke MCP.lvproj` with its six virtual folders
Type: build (LabVIEW calls)

> MANAGER, BEFORE LAUNCH: replace the `<<FILL ...>>` markers with the values read from `lvai_status` this
> session, and confirm brief 00a's commit is in. Do not launch while a marker is present.

## UPDATES
- Brief 00a wrote `.labview/` (commit `<<FILL 00a commit>>`). `project.json` says `save_version`
  `<<FILL save_version>>`. Read first: it overrides nothing below, it is the source of the facts.
- The user gave NO go-ahead for restarting or closing LabVIEW, and NONE for copying `ZM-errors.txt` into
  LabVIEW's `user.lib\errors\`. The error-code file stays in the repository. Do not ask; do not copy.

## Goal
Create `src\Zuehlke MCP.lvproj` in the product folder **through LabVIEW** (VI Server scripting or a labview-mcp
tool; never by hand-writing the XML), with the empty virtual folders `common`, `hardware`, `protocol`, `actors`,
`tests`, `receiver` directly under `My Computer`, saved in save version `<<FILL save_version>>`, then close it.
Out of scope: any class, library, VI or typedef; anything under `.labview\`; the harness; the user's other projects.

## Paths (absolute, long form)
- Repo root (git): `C:\project\claude\LabVIEW-AFAItest`. Read-only there: `requirements\`, `orchestration\`,
  `runs\`, `README.md`, `CLAUDE.md`.
- Product folder (= the skill's `<repo>`): `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results`.
- Target: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\src\Zuehlke MCP.lvproj`. `src\` holds
  only `errors\ZM-errors.txt` today and must hold only that plus the project (and LabVIEW's own `.lvlps`,
  git-ignored) afterwards.
- Skill: `C:\Users\jorgen.steen\.claude\skills\labview` (`<skill>`). Read `knowledge\labview-mcp.md`
  "Operating rules", "Save version", "Opening and closing a project", "Helper VIs (the kit)"; `kit\README.md`.
- Helper VIs, if you need one: `C:\Users\jorgen.steen\AppData\Local\Temp\LabVIEWMCP\helpers\<name>.vi`
  (long form; never `%TEMP%`, never an 8.3 name).
- Proof folder for throwaway files: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-00b-project\`
  (git-ignored).
- Machine facts (from `lvai_status`, read by the manager): LabVIEW `<<FILL labview_version>>` 32-bit, labview-mcp
  `<<FILL mcp_version>>`, LVAutoSave path `C:\Users\jorgen.steen\OneDrive - Virinco AS\Dokumenter\LabVIEW Data\LVAutoSave`.

## Route (UNMEASURED: no source of this skill has created a project from scratch; report what worked)
1. `lvai_status` once (it must answer; note `labviewUpSeconds`). `git status --short` from the repo root: clean.
2. Find the route, in this order, and use the first that works:
   a. a labview-mcp tool that creates a `.lvproj` when the file does not exist (read the descriptions of
      `lvai_add_vis_to_project`, `lvai_lvproj_reference`, `lvai_open_file`; do not guess an undocumented input);
   b. a helper VI from AIXML (`lvai_generate_vi`, `measurePane: false`, into the helpers folder above) that uses VI
      Server: the Application's project methods to create a new project (look them up with
      `lvai_vi_server_reference` first; a scripting-licence error means stop and report), `Add Item` of
      `Type` virtual folder on the `My Computer` target for each of the six names, `Save` to the target path,
      close. Run it with `lvai_run_vi_and_read_values` with the project closed (no `project path` input).
   Mark in the report which route and what each call answered. If neither route can create a virtual folder, the
   project alone is acceptable for this step: create it, say which folders are missing and why, and the manager
   will decide. Do NOT hand-write or script-edit the `.lvproj` XML.
3. `lvai_open_file` with `projectPath` = the target (check `activeProjectPath` in the answer): it must open
   without a dialog (`<skill>\kit\lv_windows.ps1` shows none). `lvai_describe_project` on it: the six folders,
   nothing else under `My Computer` but the default Dependencies and Build Specifications.
4. `lvai_close_active_project` with `projectPath` = the target (your project must be the active one).
5. Verify from the file: `python <skill>\kit\lv_save_version.py "<target>"` reads `<<FILL save_version>>`; the six
   `<Item Name="..." Type="Folder">` entries are in the XML; `git status --short` shows only the new `.lvproj`
   (plus nothing else; an `.lvlps` is git-ignored).
6. Commit from the repo root: `git add "zuehlke-mcp-af-test-results/src/Zuehlke MCP.lvproj"` then
   `git commit -m "chore: .labview conventions and empty project"` with a one-line body naming the route used.
   NO attribution trailer.

## Traps
- A modal dialog blocks the whole gRPC service until a person answers it; every call then only times out. Check
  with `<skill>\kit\lv_windows.ps1` (no LabVIEW call) and stop. (`knowledge/labview-mcp.md`, "A failed, hung or
  blocked call")
- `lvai_close_active_project` saves and closes WHATEVER project is active; `projectPath` does not choose it. Make
  yours active first with `lvai_open_file` and read `activeProjectPath`. (same file, "Opening and closing a project")
- Opening a project rewrites `.aliases` and `.lvlps` and may add `NI.LV.All.SaveVersion`; saves with no project
  open go to the IDE's version. Both are fine here: this project's version IS the IDE's. Report what the close
  rewrote. (same file, "Save version", "Opening and closing a project")
- The runner refuses an empty string input: omit the input instead. Absolute long-form paths only. (same file,
  "Helper VIs (the kit)")
- A helper VI generated anywhere but the helpers folder is adopted into the open project. (same file)

## Hard rules
Operating rules: `C:\Users\jorgen.steen\.claude\skills\labview\knowledge\labview-mcp.md`, "Operating rules". The
lines below must not be missed.
- LabVIEW is running (checked by the main session). Never start, restart or close LabVIEW. If it stops
  answering, stop and report.
- Strictly sequential LabVIEW calls: one lvai_*/pylv_* call at a time, never two in parallel, not even reads.
- A crash, a hung call, DeadlineExceeded, or a modal dialog: stop at once and make no further LabVIEW call. The
  timed-out helper keeps running and blocks every call. Check dialogs with
  `C:\Users\jorgen.steen\.claude\skills\labview\kit\lv_windows.ps1` (no LabVIEW call). Never answer a LabVIEW dialog.
- Closing a project: lvai_close_active_project closes AND SAVES whatever project is active. First make yours
  the active one: lvai_open_file with projectPath = the target (check activeProjectPath in the answer). If
  another project would be closed, stop and report. Pass projectPath to the close anyway.
- No hand edits of .vi .ctl .lvclass .lvlib .lvproj: only the kit's byte-exact scripts, with the project closed
  (none is needed in this brief).
- Absolute long-form paths everywhere: no %TEMP%, no 8.3 short names.
- Touch nothing outside `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\` except the helpers
  folder named above. Do not copy anything into LabVIEW's `user.lib`.
- Commit before every structural step, by explicit paths: Conventional Commits, no AI attribution trailer. Never push.
- Save version `<<FILL save_version>>`: a file newer after the step = stop and report.
- Report every side effect: items removed, files re-saved or upgraded, project files rewritten, helper VIs left.

## Report (max 35 lines), as your final message
1. `lvai_status`: version, bitness, labview-mcp version, port, `labviewUpSeconds`.
2. The route that created the project (a or b), each LabVIEW call in order with its answer in a few words.
3. `lvai_describe_project`: the items under `My Computer`.
4. `lv_save_version.py` output for the `.lvproj`; the six folder lines quoted from the XML.
5. The commit hash; `git status --short` after it.
6. Deviations (folders missing, a fallback used), each with the evidence.
7. Side effects: list (files rewritten by the open/close, helper VIs left in the helpers folder), or "none".
8. The active project at the end (none expected) and whether LabVIEW still answers (`lvai_status` once).
