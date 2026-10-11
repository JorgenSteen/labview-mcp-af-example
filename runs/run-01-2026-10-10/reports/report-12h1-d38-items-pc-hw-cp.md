## Report 12h1: D38 items by scripting on the PC children, HW and CP classes (9 classes)

All 9 classes now have their description and folders, and no member sits at a class root. The sweep and tests T1, T3, T4, T5 and T6 all pass.

1. **LabVIEW state:** `lvai_status` answered at the start (23:56) and at the end (00:06): port 56779, PID 26716, 0 DWarn. There was no kill, no start and no restart. At the end the project is closed, no dialog is open, LVAutoSave is 0, and the only unsaved VIs are the 2 `LVMCP Validate` scratch VIs.
2. **Per class:** the description was written and read back exactly in each class. Members were moved only into folders the table names; no member was left unplaced.
   - `ZM-PC-TP-test_package`: TypeDefs `ZM-PC-TP-DATA.ctl`; Methods init, getDataAsJson, TP-setType, TP-create.
   - `ZM-PC-EP-error_package`: TypeDefs `ZM-PC-EP-DATA.ctl`; Methods init, getDataAsJson, EP-setType, EP-create.
   - `ZM-HW-hardware`: Methods init, do, close.
   - `ZM-HW-SIM-simulated_hardware`: Methods ZM-HW-do, HW-SIM-randomData.
   - `ZM-CP-communication_protocol`: Methods init, publish, close.
   - `ZM-CP-FL-file_logger`: Methods CP-init, CP-publish, FL-createFolder, FL-buildPath, FL-appendLine.
   - `ZM-CP-UDP-sender`: Methods CP-init, CP-publish, CP-close, UDP-openSender, UDP-closeConnection.
   - `ZM-CP-UDP-receiver`: Methods CP-init, CP-close, UDP-receive, UDP-openReceiver, UDP-closeConnection. `Write localPort` was already in Accessors.
   - `ZM-CP-MX-multi_protocol`: TypeDefs `ZM-CP-MX-PROTOCOLS.ctl`; Methods MX-initAll, MX-closeAll and the three overrides.
   - **Differences from the brief's table:** the sender has no `Write remoteAddress`/`Write remotePort`. Its accessors are Read connection, Read remoteAddress, Read remotePort and Write connection, and they stay in Accessors. Every other member name matched the `.lvclass` XML.
3. **Typedef adds:**
   - **TP-DATA:** a grep found callers outside the class in `ZM-HW-SIM` do and randomData, and in `ZM-receiver.vi`.
     - The HW-SIM VIs were already in memory as class members. I opened `ZM-receiver.vi` through the project before the add.
     - LabVIEW modified Read data, Write data, the `.ctl`, TP-create and the class; Save All on the class saved them.
     - It also modified `ZM-HW-SIM-randomData.vi` (saved by Save All on `ZM-HW-SIM-simulated_hardware.lvlib`) and `ZM-receiver.vi` (VI mods 520, saved by `zmp12f_project_vis_modified` with save on).
   - **EP-DATA and MX-PROTOCOLS:** callers only inside the class. Modified were Read/Write data or protocols, the `.ctl` and the class, all saved by Save All on the class. Nothing was left modified in memory.
4. **MX reentrancy (read only):** I generated a new helper, `proof\ZMP-12h1\zmp12h1_read_reentrancy.xml`, that reads the VIs in the project instance.
   - `initAll` and `closeAll` both read `Execution:Is Reentrant` = T and `Execution:Reentrancy Type` = 0.
   - The file flags, read offline with `pylv_extract`, are `IsReentrant=1` and `PooledReentrancy=1` on both, with State 1.
   - So both are shared clone reentrant, as expected. Nothing was changed.
5. **Checks** (project closed):
   - Cold sweep of `src`: 137/137 state 1, negative control 0 7, 26.8 s.
   - `check_membership`: 134 checked, 0 not a member, 3 plain (the launchers and the receiver), exit 0.
   - T1 `ZM-TST-packages`, T3 `ZM-TST-hardware`, T4 `ZM-TST-protocol`, T5 `ZM-TST-udp` and T6 `ZM-TST-pipeline` all PASS with error 0 and every sub-check T.
   - `lv_save_version.py` reads 26 on all 21 changed files.
   - Evidence is in `C:\project\claude\LabVIEW-AFAItest\zuehlke-mcp-af-test-results\proof\runs\12h1-checks.txt`, with in-memory lists and scripts in `...\proof\ZMP-12h1\`. Both are git-ignored.
6. **Commits** (explicit paths, no trailer, not pushed): `e6b8c9b` TP, `6b0371c` EP, `6ffda78` HW, `59b0861` HW-SIM, `623521f` CP, `c59e9b7` FL, `411c3d9` UDP-sender, `866cd59` UDP-receiver, `49fa58a` MX. Each message is `refactor(<pc|hw|cp>): class description and folders of <class> by scripting`.
   - `git status` lists only your untracked run files: `brief-12h2-d38-items-actors-ci.md`, `lessons-mcp-skill.md` and `notes-for-run-02.md`.
7. **Side effects and new traps:**
   - The project close dropped the `.lvproj` BOM, which was the only change; I restored it from git with the project closed.
   - The close also swept 1 adopted helper (`zmp12h1_read_reentrancy.vi`) out of the project.
   - A new helper VI is in `%TEMP%\LabVIEWMCP\helpers\`.
   - Git warns that the `.lvclass` files will have CRLF replaced by LF (`.gitattributes` sets `* text=auto eol=lf`). This was the same in 12f.
   - The FL description holds `<getTypeName>`, which is stored XML-escaped as `&lt;getTypeName&gt;` in the `.lvclass`. That is correct XML, and the read-back text is exact.
   - **New trap:** `Execution:Reentrancy Type` reads 0 for shared clones, so 0 does not mean "non-reentrant". Read it together with `Is Reentrant`. The enum's item names are not in `lvserver.rsc`.
   - **New trap:** the in-memory list helper's answer is about 85 KB and goes over the tool-result limit every time. Parse the saved answer with `proof\ZMP-12h1\mem_lines.py`.
   - Not every VI that contains a typedef's name is marked modified by the add; LabVIEW decides which ones are. Only those were saved, and the cold sweep is the proof that nothing broke.

DONE
