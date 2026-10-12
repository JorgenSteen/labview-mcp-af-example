# Brief 12n: a "Flows" section with four diagrams in the user guide (docs only, no LabVIEW)
Type: documentation. Asked for by the user 2026-10-12: "I want the flows tab. but more refined, the launch tree is
perfect, the class hierachy should be a standalone one. then another with message paths between things, this will
also include the reciever ... and lastly the library dependencies, it is also perfect". The user chose: a "Flows"
section in the user guide, diagrams as inline SVG that work offline.

## The file you change
`C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\docs\user-guide.html` (written in 12m; read it first,
keep its style, CSS variables, light/dark themes and print styles). Add ONE new section **"Flows"** (after "How it
fits together", renumber the table of contents and headings) with **four tabs**, one diagram each. Nothing else in
the guide changes except the TOC and numbering.

## Reference (read only; never edit, copy into git, or commit)
`C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-design.html`, section `id="flows"` (Mermaid sources inside
`<pre class="mermaid">`). It is the ORIGINAL pilot's page: its names (snake_case, `handle_package`, init messages,
8 libraries) and parts of its design are out of date. Take the **layout and level of detail** of its "Launch tree"
and "Library dependencies" (the user: "perfect"), and of its "Communication path of one package"; take every
**name and fact** from the current requirements below. Where the page and the requirements differ, the requirements
win.

## Sources of truth
- `C:\project\claude\LabVIEW-AFAItest\requirements\02-specification.md` (version 2): §1 (libraries, dependency
  rule), §3 (hierarchy), §4 (package path), §5 (errors, D40/D44), §6 (start-up and shutdown, `init` D41, the AF
  overrides table), §7 (every class, field and VI, camelCase names), §8 (launchers, receiver, project tree D45).
- `C:\project\claude\LabVIEW-AFAItest\requirements\01-requirements.md` R5 (routing table), R7, R8, R9, R10.
- The built dependency graph: `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12i\dep_full.txt`
  (from the files; use it to check every edge you draw). The current short descriptions:
  `C:\project\claude\LabVIEW-AFAItest\runs\run-01-2026-10-10\descriptions-new.json`.
Invent nothing. If a fact you want to draw is in none of these, leave it out and say so in the report.

## The four tabs
1. **Launch tree** - as the page draws it (launcher on top, root, ① CM and ② HWM, owned objects below, the UDP hop
   to the receiver), with the current content: `ZM-launcher.vi` (and `ZM-launcher_test.vi`: launch, wait, read
   errors, Normal Stop, count lines); per actor its overrides in one or two lines (ROOT: Pre Launch Init
   `createResources`; Actor Core `init` (`launchCm` → `launchHwm` → Register) → `helperPanel` ∥ Call Parent → `stop`
   → `close`; Handle Error `evaluateError`. CM: Pre Launch Init `createResources`; Stop Core `releaseProtocol`; Handle
   Error. HWM: Pre Launch Init `createResources`; Actor Core `init` (Register) → `helperAcquisition` (producer loop
   ∥ event loop) ∥ Call Parent → `stop` → `close`; Handle Error). Edge labels ① `ZM-ROOT-launchCm.vi` (injects
   `ZM-CP-MX` [FL, UDP sender]) and ② `ZM-ROOT-launchHwm.vi` (`ZM-HW-SIM`, or bare `ZM-HW-hardware`; 500 ms). Owned
   objects: SIM (init → do every 500 ms → close), MX → FL (`output/<type>.jsonl`) and UDP sender (one JSON line per
   datagram → 127.0.0.1:61557) → `ZM-receiver.vi`. A one-line note: why ① before ②.
2. **Class hierarchy** - standalone, UML style: Actor Framework `Actor` → `ZM-ROOT-root`, `ZM-HWM-hardware_manager`,
   `ZM-CM-communication_manager`, all three implementing the interface `ZM-CI-package_handler` (`ZM-CI-handlePackage`);
   AF `Message` → `ZM-CI-handlePackage Msg` (holds the package); `ZM-PC-package` → `ZM-PC-TP-test_package`,
   `ZM-PC-EP-error_package`; `ZM-HW-hardware` → `ZM-HW-SIM-simulated_hardware`; `ZM-CP-communication_protocol` →
   `ZM-CP-FL-file_logger`, `ZM-CP-UDP-sender`, `ZM-CP-UDP-receiver`, `ZM-CP-MX-multi_protocol` (which holds an array
   of protocols). Has-a links: HWM → hardware, CM → protocol, Msg → package. In each box: the fields and the main
   public/protected methods with `02` §7 names (prefix may be dropped, say so in the note); mark placeholders that
   return 5000. Inheritance (solid line, hollow triangle), implements (dashed), aggregation (hollow diamond); a small
   legend.
3. **Message paths** - everything that travels between the parts, with the receiver: (a) the data path every 500 ms:
   SIM `do` → HWM helper loop (chart) → `Send ZM-CI-handlePackage` to its own HWM → HWM counts, sends to its caller
   (ROOT) → ROOT routes by destination (Communication → note type, forward to the CM while `cmRunning`; Root → error
   package shown on the panel, else noted; Unknown/Hardware → dropped, one log line) → CM `ZM-CP-publish` on the MX →
   FL appends a line, UDP sender sends a datagram → `ZM-receiver.vi` (separate, one way, can come and go); (b) the
   stop path: the root panel's Stop → Normal Stop to ROOT → AF Stop Core sends Normal Stop to HWM and CM → each
   Actor Core fires its `stop` user event to its helper loop after Call Parent; the CM's Stop Core releases the
   protocol; (c) the error path (D40): an error stops its actor, the Last Ack carries it up, the caller stops with it,
   the whole tree stops; the error-package path to the root's panel is built but not used yet. Use a sequence
   diagram (lifelines) or a lane diagram, whichever reads best; label each arrow with what travels (message name,
   user event, UDP datagram, Last Ack).
4. **Library dependencies** - as the page draws it (bottom-up graph, "depends on" arrows), but with the **13
   libraries** of `02` §1 (the four pluggable children `ZM-HW-SIM`, `ZM-CP-FL`, `ZM-CP-UDP`, `ZM-CP-MX` have their
   own libraries; plus `ZM-TST-tests`, which may be drawn compactly or as a note) and the receiver VI (no library).
   Every edge must exist in `dep_full.txt`; note the forbidden edges (`02` §1) under the diagram.

## Form
- Inline SVG only (no external scripts, fonts, images or CDN); tabs switch with a few lines of inline JS and work by
  keyboard (role="tablist"/"tab"/"tabpanel", aria-selected); with JS off or in print, all four diagrams show one
  after the other. Each diagram readable at laptop width (it may scroll sideways inside its own box on a phone),
  colours from the guide's CSS variables so dark mode works (use `currentColor`/CSS classes, not hard-coded black).
- Under each diagram a 1-3 sentence note. ASCII in names (arrows in SVG text may be drawn as paths).
- Validate: well-formed HTML (Python `html.parser`, tag balance), unique ids, every `href="#..."` has a target, each
  SVG parses as XML (`xml.etree`). Write a short check script under `...\proof\ZMP-12n\` if useful.

## Hard rules
- No LabVIEW call of any kind. Write only `docs\user-guide.html` (and scratch under
  `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12n\`). Do not edit or move
  `zuehlke-mcp-design.html`; do not commit; never push.

## Report (max 20 lines), as your final message
What each tab shows, the sources per tab, any fact left out (and why), the dependency edges checked against
`dep_full.txt` (count, any mismatch), the validation result, the file size. Ends with DONE, or NEEDS CLARIFICATION /
CANNOT PROCEED.
