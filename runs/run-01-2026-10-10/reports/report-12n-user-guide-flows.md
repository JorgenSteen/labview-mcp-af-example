Report 12n: Flows section in the user guide (docs only, no LabVIEW call)

1. File changed: C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\docs\user-guide.html (80 976 bytes, was 23 343; pure ASCII). New section "3. Flows" after "How it fits together". The TOC has the new entry and sections 3-9 are now 4-10. Diffed against the original: the only removed lines are the 7 old headings. I also had to add Flows CSS in the existing `<style>` (new tokens --actor, --stop, --err with dark and print variants) and one small inline `<script>` for the tabs.
2. Tabs: role tablist/tab/tabpanel with aria-selected and aria-controls. Arrow keys, Home and End work, with roving tabindex. With JS off or in print, the tab bar is hidden and all four panels show one after the other, each with its own h3. Each SVG sits in its own sideways-scrolling box, with a min-width of 700-760 px for phones.
3. Launch tree (`02` §6, §7.10-7.12, §8; `01` R8, R10): launcher box (plus the `ZM-launcher_test.vi` steps) → ROOT, then ① CM and ② HWM. The edge labels and the overrides per actor are as listed in the brief. Below them: MX → FL [0] and UDP sender [1], the SIM owned by the HWM, and the UDP hop to `ZM-receiver.vi`. The note under it says why ① comes before ②.
4. Class hierarchy (`02` §3, §3.1, §7): UML style. The three actors inherit from AF Actor and implement `ZM-CI-package_handler`. AF Message → `ZM-CI-handlePackage Msg`. Below those: the PC, HW and CP families, with MX holding protocols [0..*]. Has-a links: HWM to hardware, CM to protocol, Msg to package. Each box shows its fields and its +/# methods; [5000] marks a placeholder; there is a legend. The note says the prefix is dropped and accessors and private members are not shown.
5. Message paths (`02` §4-§6, §7; `01` R5, R7-R9): a sequence diagram with 7 lifelines in three parts:
   - (a) data path inside a loop frame, with an alt frame for Communication / Root ("built, not used yet") / Unknown or Hardware;
   - (b) clean stop;
   - (c) D40 error path.
   Every arrow is labelled with what travels: message name, user event, UDP datagram or Last Ack.
6. Library dependencies (`02` §1 plus dep_full.txt): drawn bottom-up with "depends on" arrows, as the reference page does: `ZM-PC` is a bar at the top, `ZM-ROOT` a bar at the bottom with its arrows in blue. It shows the 12 shipped libraries, AF, the receiver VI and the launchers. `ZM-TST-tests` is a compact box that lists its 9 dependencies. The forbidden edges of `02` §1 are in the note under the diagram. A search script placed the boxes so that no arrow crosses a box.
7. Edges vs `proof\ZMP-12i\dep_full.txt`: built 46, drawn 46 (37 arrows + 9 listed for TST), missing 0, extra 0, checked by script. The drawing follows the build where it is narrower than `02` §1: the receiver points only to UDP and PC, and the HWM has no arrow to CU.
8. Left out because it is in none of the sources: the Last Ack of a clean stop, and the second Normal Stop the root's Stop Core sends to the already stopped HWM in (c). Inferred: in (c), the error running on from AF Handle Last Ack Core into the root's Handle Error, which I drew from the AF facts in `02` §5.
9. Validation (proof\ZMP-12n\check_guide.py), RESULT PASS:
   - tags balanced (html.parser);
   - 67 ids, all unique;
   - 11 internal hrefs, 18 ARIA references and 12 marker url(#) references all resolve;
   - all 5 SVGs parse with xml.etree;
   - no external resource, 0 non-ASCII bytes.
   I looked at headless-Chrome screenshots in light and dark, with JS on and off. The screenshot PNGs are in the session scratchpad, not the repo, because Chrome could not write into the repository.
10. Scratch files are in C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\ZMP-12n\: generator scripts, deps_layout.json, deps_search.py, check_guide.py, preview.py, and user-guide.before.html (a copy of the original guide; assemble.py rebuilds from it). git status shows proof\ZMP-12n as neither tracked nor untracked; I did not check whether it is ignored. `zuehlke-mcp-design.html` was only read, not touched. Nothing committed or pushed. The only change git reports is docs/user-guide.html; the two untracked runs/ files were there before.

DONE
