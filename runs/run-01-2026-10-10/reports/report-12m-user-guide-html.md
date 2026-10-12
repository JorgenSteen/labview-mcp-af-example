Report 12m: HTML user guide (docs only, no LabVIEW call)

1. File: C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\docs\user-guide.html. It is 23,278 bytes and ASCII only (0 non-ASCII characters). It has about 1,270 words of prose and headings; with the tables included it is about 1,670 visible words. The prose is a little over the brief's "about 1200".
2. Form: one self-contained file with inline CSS and an inline SVG. It loads no external script, font or image. The `<title>` is "Zuehlke MCP - User Guide". It has light and dark themes by `prefers-color-scheme`, print styles, a 9-entry table of contents with in-page links, and a layout that works at phone width.
3. Sections and sources:
   - 1 What it is: README, 01 §1.
   - 2 How it fits together: an SVG of launcher -> ROOT, the ROOT launching 1. CM and 2. HWM, the hardware object, the multi protocol of file logger + UDP sender, the package flow, output/<type>.jsonl, and ZM-receiver.vi outside the tree; then one paragraph per actor. Sources: 02 §1/§4/§6/§7.10-7.12, the class descriptions in descriptions-new.json, D41.
   - 3 Requirements, with a table of the virtual folders: README, 02 §8, D45.
   - 4 Run it: interactive launcher, the root panel and the HWM panel, Stop, the receiver, the headless launcher, and a table comparing the two launchers. Sources: 02 §7.11/§7.12/§8, 01 R9/R10, 03 §2, D43, D45, descriptions-new.json. The receiver note on the root panel is taken from brief 12l.
   - 5 Output: 01 R6, D15. The example JSON line and the example log line are real lines from output/.
   - 6 Errors: D40 (the guide says in one clause that it overrides the specification's plan), D44, docs/error-codes.md, 03 R-error.
   - 7 Tests (T1-T7): 03 §1, .labview/checks.json (side effects).
   - 8 Troubleshooting and 9 Folder layout: README, 02 §9, error-codes.md, the output/ listing.
4. Facts not taken from the brief's source list:
   - The error-run result `error out` 1556 ("the tree had already stopped") comes from status.md, row 12a/R-error.
   - "Today no actor sends an error package" and "the log gets lines from root drops, CM release errors, T2/T7" come from grepping which .vi files link ZM-PC-EP-create and ZM-CU-log. Only T1 and T4 call EP-create. The log is called by ROOT's handlePackage, CM releaseProtocol and T2. T7 writes its lines through ROOT's handlePackage.
   - Two troubleshooting lines are inferences, not measured: T5 failing while the receiver is running, and the receiver showing an error at once when port 61557 is in use. Both follow from T5 and the receiver both opening 61557.
5. Things written ahead of 12l: the guide describes the D45 state (ZM-launcher_test.vi in the `tests` folder) and the receiver note on the root panel. When I read the .lvproj, launcher_test was still at the project root, because 12l had not finished.
6. Validation (Python html.parser with a tag-balance check): no mismatched or unclosed tags, no duplicate ids, all 10 `href="#..."` targets present.
7. Files: only docs/user-guide.html was written, and the docs/ folder already existed. No proof scratch files. The other entries in `git status` (README.md, ZM-ROOT-helperPanel.vi, status.md) are not mine. No commit, no push.

DONE
