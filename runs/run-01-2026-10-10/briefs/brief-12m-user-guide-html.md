# Brief 12m: an HTML user guide for the application (docs only, no LabVIEW)
Type: documentation. After the run (run-01 accepted). Asked for by the user 2026-10-12 ("where is the documentation for
this project? the one for a user to read? like the html one"; then chose "HTML user guide"). A LabVIEW agent (12l) runs
at the same time: **make no LabVIEW call of any kind** (no lvai_*/pylv_* tool), and touch no file but your own.

## Goal
Write ONE self-contained file:
`C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\docs\user-guide.html`
for a LabVIEW user who has never seen the project: what the application does and how to use it. Not a code reference.

Sections (short, concrete, in this order):
1. **What it is** - one paragraph: simulated hardware -> three actors -> JSON Lines files and a UDP stream.
2. **How it fits together** - an inline SVG diagram: launcher -> ROOT (root) -> CM (communication manager) and HWM
   (hardware manager); the hardware object in the HWM; the protocols in the CM (multi protocol of file logger + UDP
   sender); package flow HWM -> ROOT -> CM -> files/UDP; the receiver VI outside the tree listening on UDP. One short
   paragraph per actor (what it owns, what it does).
3. **Requirements** - LabVIEW 2026 Q3 32-bit with the Actor Framework; open `src/Zuehlke MCP.lvproj`; the project's
   virtual folders (`common`, `hardware`, `protocol`, `actors`, `tests`, `receiver`).
4. **Run it** - `ZM-launcher.vi` (interactive; at the project root), what opens (the root's panel with Stop and the
   errors list, and a note pointing to the receiver; the hardware manager's panel with the live chart and the measured
   interval), how to stop it (Stop on the root's panel stops the whole tree). The receiver `ZM-receiver.vi` in the
   `receiver` folder (port 61557 on 127.0.0.1, chart, last line, packet count, start/stop any time). The headless
   `ZM-launcher_test.vi`, which sits in the project's **`tests`** virtual folder (decision D45, 2026-10-12): what it does
   and its outputs; a table comparing the two launchers.
5. **Output** - `output/<type>.jsonl` (one JSON line per package; example line), `output/ZM-error_log.txt` (format, when
   it gets lines; a clean stop leaves it empty), `tools/jsonl_viewer.html` to view a file.
6. **Errors** - the plan as it is today: errors are not handled yet; an error stops the actor and, through its Last Ack,
   the root and the whole tree; error packages to the root show in the errors list; the one custom code 5000 ("must be
   overridden by a child class"), see `docs/error-codes.md`; the placeholder-hardware error run.
7. **Tests** - the seven test VIs T1-T7 in `ZM-TST-tests.lvlib` (one line each: what it proves; each has `Pass` and
   `error out`), how to run them.
8. **Troubleshooting** - a few real cases: nothing in the receiver (start it while the tree runs; port 61557 in use);
   an error log that already has lines (the tests write marker and "dropped" lines on purpose); Explain Error shows no
   text for 5000 (the error file is not installed in `user.lib`); leftover `test_*` folders under `output/` (safe to
   delete).
9. **Folder layout** - short.

## Sources (read; do not change any of them)
- `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\README.md`, `docs\error-codes.md`, `.labview\decisions.md`
- `C:\project\claude\LabVIEW-AFAItest\requirements\01-requirements.md`, `02-specification.md` (§1, §5-§8 for names,
  panels and controls), `03-acceptance.md` (§1 tests, §2 runs)
- `C:\project\claude\LabVIEW-AFAItest\CLAUDE.md`, "Defaults that need no question" (D40 errors, D41 init, D43 launcher
  error out, D44 release errors, D45 launcher_test in `tests`)
- `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\descriptions-new.json` (the current short VI and class
  descriptions; the most up-to-date text of what each actor VI does)
Every name, control, port and file name in the guide must come from these sources; invent nothing. Where the sources
disagree, `02` wins except where a D-decision in `CLAUDE.md` overrides it (say so in one clause).

## Form
- One HTML file, no external scripts, fonts or images (inline CSS and SVG only), opens offline from disk. `<title>`
  "Zuehlke MCP - User Guide". Readable on a laptop and in print; a light and a dark theme by `prefers-color-scheme`.
- A short table of contents with in-page links. Plain, calm design. ASCII in names; code names in `<code>`.
- About 600-1200 words of text plus the diagram and tables. Write for a user, not about the build or the AI test.
- Validate: well-formed HTML (Python `html.parser` with no errors), every `href="#..."` has its target.

## Hard rules
- No LabVIEW call. Write only that one file (and scratch files under
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12m\` if you need any). Do NOT edit
  `README.md` (the other agent changes it). Do not commit; the manager commits. Never push.

## Report (max 20 lines), as your final message
The file path, its size and word count, the section list, the sources used per section, anything you could not find
in the sources, the validation result. Ends with DONE, or NEEDS CLARIFICATION / CANNOT PROCEED.
