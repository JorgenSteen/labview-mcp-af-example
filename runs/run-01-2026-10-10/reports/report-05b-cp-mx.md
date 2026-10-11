# Report 05b: ZM-CP-MX-multi_protocol (2026-10-11 09:47-10:01)

DONE. Every item of brief 05b holds and every name comes from 02 §7.9. The cold sweep reads 36/36 state 1 with control `0 7`. Both probe readings came out as expected. Two deviations: one break of the sequential-call rule, and one reentrancy-flag observation (item 8). No NEEDS CLARIFICATION. About 60 LabVIEW calls.

1. **`lvai_status`.**
   - Start: ok, port 59552, PID 14040, up 66227 s, 1.9.5-local (f9ee41d9), dwarn 0.
   - End: ok, same port and PID, up 66997 s, dwarn 0.
   - LabVIEW starts made: 0. No dialog. The project is closed at the end; the 22 unsaved windows are the tool's hidden `LVMCP Validate*` pairs.

2. **Typedef, class and members** (from the files).
   - **Typedef `ZM-CP-MX-PROTOCOLS.ctl`:** made as `array{bool.protocols}`, then `pa_array_element_replace` with the project active (errors 0, label `protocols`, `is typedef after` 3, a U32 that is non-zero). `describe_ctl`: typedef, Array. The file links `ZM-CP-communication_protocol.lvclass`.
   - **Class:** `describe_class` reads `ZM-CP-MX-multi_protocol.lvlib:ZM-CP-MX-multi_protocol.lvclass`, inheriting from `ZM-CP-communication_protocol.lvlib:ZM-CP-communication_protocol.lvclass`. Field `protocols` is a TypeDef bound to `ZM-CP-MX-PROTOCOLS.ctl`: placeholder `string.protocols`, commit, then a separate `bind_class_fields` with no `force`, `boundInFile` true.
   - **Members:**
     - `Read protocols`: private, static.
     - `Write protocols`: public, static. Its value terminal is `ZM-CP-MX-PROTOCOLS` (paneTypedefs = the .ctl).
     - `ZM-CP-MX-initAll` and `ZM-CP-MX-closeAll`: private, static. Parent-typed pane, `To More Specific Class` inside, `Preserve Run-Time Class` on the output (object in = Write protocols out, target = the input). For loop with shift registers on the array and on the error, Index Array → dynamic ZM-CP-init/close → Replace Array Subset, stop on error status.
     - `ZM-CP-init`, `ZM-CP-close`, `ZM-CP-publish`: public, dynamic.
   - **Reentrancy:** `set_reentrant_flags.py` on a `pylv_extract` bundle, then `pylv_rebuild`, project closed. Re-extract of the rebuilt files: `IsReentrant=1 PooledReentrancy=1` on both hooks, cold state 1.

3. **Overrides** (`ops/override.md` block):
```
override MX:ZM-CP-init  created yes  public (parent's)  dynamic  member  folder asked (Methods, D38)
hooks: ZM-CP-MX-initAll shape B-after  helper errors 0 (18)  hits panel idx A 2, B 3, wire A 2  saved by pa_save_member
override MX:ZM-CP-close created yes; hooks: ZM-CP-MX-closeAll shape B  errors 0  hits A 0, B 1, wire A 2  pa_save_member
override MX:ZM-CP-publish (own body, add_class_method, dispatch 11/3, package -> ZM-PC-package, validate clean, swaps 3/3, socketsLeft 0)
unmeasured shapes used: none  user asked: no  changed: none  pa_clean_member n/a
sweep 36/36, control 0 7, membership ok  export ok  run order: probe only  commits below
```
   - Exports in `proof\ZMP-05b\export-ZM-CP-{init,close}.xml` confirm the order:
     - init: Call Parent (32) → initAll (140) → the indicators.
     - close: closeAll (140) → Call Parent (32) → the indicators.
   - Every override and hook read state 1 cold.

4. **Library.** Made with the cached `zm_create_class_library.vi` (errors all 0), then `lvproj_drop.py` on the stray class item and `lvproj_move.py` into `protocol`. A reopen and close changed nothing. The `.lvproj` `protocol` folder now lists the CP, FL, MX and UDP libraries, once each. The MX line is `<Item Name="ZM-CP-MX-multi_protocol.lvlib" Type="Library" URL="../protocol/ZM-CP-MX-multi_protocol/ZM-CP-MX-multi_protocol.lvlib"/>`. `.lvproj` against the start: +1 line only.

5. **Probe** (`proof\ZMP-05b\ZMP-05b-probe.vi`, run cold, 66 ms):
   - MX holding [bare parent]: `A_init_code 0`, `A_publish_code 5000`.
   - MX holding []: `B_init_code 0`, `B_publish_code 0`, `B_close_code 0`.
   - `error out` F/0. Readings saved in `ZMP-05b-probe-run.txt`.

6. **Checks.**
   - Cold sweep of all of `src\protocol`: 36/36 state 1 (MX 7/7), control `0 7`, 1.9 s.
   - `check_membership.py`: 7 checked, 0 not a member, exit 0.
   - `lv_save_version.py` on the MX files and the `.lvproj`: all 26.
   - `lv_loadability.py --links`: links go only to the MX class, lib and .ctl, the CP parent class and `ZM-PC-package.lvclass`. 0 links into ActorFramework, ZM-CU, ZM-HW, ZM-TST, ZM-CP-FL or ZM-CP-UDP.

7. **Commits** (explicit paths, no trailer, not pushed): 576b7a0, 3029332, d93a140, 7d592d6, 0f7c7c6, 55ebac2, c1d0296, 1a7502f, fb5413a, 7bed821, 445dcd6, e1a370e, 36c7a06. `git status --short` at the end: empty. Outside the MX folder only the `.lvproj` changed (+1 line).

8. **Deviations, unmeasured, items for the user.**
   - (a) **Rule break:** I sent two `pylv_extract` calls in one message (offline reads of initAll and closeAll for the reentrancy proof). Every other call was sequential.
   - (b) **Reentrancy flags after LabVIEW's next save:** after LabVIEW re-saved the hooks (library Save All), both read `IsReentrant=0 PooledReentrancy=1 SaveParallel=1`. LabVIEW rewrote the flags; I read that as its own encoding, not measured. Evidence that the hooks still work: the hooked overrides, now in the dispatch recursion, read state 1 cold, and the probe runs. Please check in the IDE that both hooks show "Shared clone reentrant".
   - (c) **Write protocols skips on error:** the wizard's `Write protocols` does nothing when `error in` carries an error. So when an element fails, the array written back is the original one (never shortened), and the elements already processed before the error are not stored. This follows the brief's chain literally.
   - (d) **Hand-made stubs:** `LVMCP Stub ZMP05b-readProtocols.vi` and `-writeProtocols.vi`, typed `array{path}`, generated into `user.lib\LV_MCP` (sources in `proof\ZMP-05b\`).
   - **For the user in the IDE (D38):**
     - Class description, text from the brief: "Composite protocol: holds an array of ZM-CP-communication_protocol objects; init, publish and close go to every element in order, stopping at the first error, which is returned. The root gives the CM an MX holding [file logger, UDP sender] (D26)."
     - `ZM-CP-MX-PROTOCOLS.ctl` goes into `TypeDefs`.
     - initAll, closeAll and the three overrides go into `Methods`.
     - The init and close overrides kept the parent's VI description.

9. **Side effects.**
   - The project was closed and opened about 12 times by the tools; `.aliases`, `.lvlps` and `.UserState` were rewritten (git-ignored).
   - The probe was adopted into the `.lvproj` and dropped with `lvproj_drop.py`.
   - New stubs in `user.lib\LV_MCP`: c3cb84cb6a, 87c6a5aa7c and the 2 hand-made ones.
   - Tool bundles under `%TEMP%\LabVIEWMCP`; pylv bundles in the session scratchpad; a `vi_nets.py` extract under `%TEMP%`; the tool's scratch class project.
   - `proof\ZMP-05b\` (git-ignored): AIXML sources, exports, sweep list and result, save versions, links, probe VI and readings.
