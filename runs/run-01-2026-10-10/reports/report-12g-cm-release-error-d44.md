REPORT 12g: CM release error D44 (2026-10-12, 08:41:59 to 08:45:12). **CANNOT PROCEED**, plus one NEEDS CLARIFICATION. Nothing was changed and nothing was committed.

1. **Status and calls**
   - `lvai_status` at 08:42 was ok: port 56779, PID 26716, 1.9.5-local, up 43233 s, dwarn 0.
   - I made 2 LabVIEW calls, both read-only: `lvai_status` and `lvai_vi_terminals` on the CM `Stop Core.vi`.
   - No start, restart, close or kill. No dialog answered.
   - **CANNOT PROCEED:** at about 08:44 the harness reported `plugin:labview-mcp:labview` as "failed to connect", so the lvai_*/pylv_* tools are no longer available to me.
     - LabVIEW itself is still running (PID 26716, started 2026-10-11 20:42:34).
     - No labview-mcp server process is running.
     - Something else is running at the same time: a `dotnet test` of `C:\project\claude\labview-mcp-fork-wt\restart-guards\tests\LabVIEWMCP.Tests` (PIDs 23156, 2648 and testhost 17232, started 08:44:33/58), from a PowerShell in `labview-mcp-fork`. That is a second caller next to LabVIEW, which breaks the one-caller rule.
   - I did not retry. The user needs to restore the labview-mcp connection and let the fork tests finish, then continue this agent.

2. **NEEDS CLARIFICATION (for the user): brief Goal 2 cannot be built as written.**
   - The brief and D44 say: "CM Stop Core: error out = Merge Errors(Call Parent error out, releaseProtocol error out)" and "the error reaches the Last Ack".
   - I measured `lvai_vi_terminals` on the current `Stop Core.vi`:
     - inputs: `ZM-CM-communication_manager in` (11), `final error code` (10, int32)
     - outputs: `ZM-CM-communication_manager out` (3) only
   - So AF's Stop Core has no error in and no error out, and Call Parent returns only `Actor out`. The skill says the same (`knowledge/actor-framework.md` line 38).
   - An override cannot add a terminal, so a release error in Stop Core cannot reach the Last Ack through Stop Core.
   - Options:
     - **A (my recommendation):** keep the Clear Errors in Stop Core. releaseProtocol logs the error and passes it on (Goal 1). The error then ends at the Stop Core boundary, logged.
     - **B:** remove the Clear Errors and leave releaseProtocol's `error out` unwired. If automatic error handling is on for that VI, this risks an error dialog at shutdown. Not recommended.
     - **C:** add a CM Actor Core override that calls releaseProtocol after Call Parent and merges its error into Actor Core's `error out`, which goes to the Last Ack. Stop Core would no longer call it. This is an architecture change against `af-shapes.stop-core-order`.
   - Whichever option the user picks, D44 in `decisions.md` needs a correction.

3. **Goal 1, planned and not applied.** It works with every option above.
   - Route: an in-place scripted helper, project closed. It adds two nodes after Write protocol:
     - Clear Errors, with `specific error code to clear` taken from the existing "never opened code" constant (= 1) and `error in` from ZM-CP-close's `error out`.
     - Merge Errors (GrowableFunction, style 2147), with inputs (Clear Errors out, Write protocol `error out`), feeding the `error out` indicator.
   - The existing log case stays unchanged, so Write protocol still runs after a close error.
   - Error order: the close error first, then a log failure, as the brief asks.
   - Nets before the edit (offline, `vi_nets.py`): `proof\ZMP-12g\nets-rp-before.txt`.

4.–6. Descriptions, cleanup, icons, runs, sweep and commit: not started.

7. **Side effects**
   - New git-ignored folder `zuehlke-mcp-af-test-results\proof\ZMP-12g\` (the nets dump and its pylabview extraction).
   - `git status --short`: only the two untracked runs files, which are not mine.
   - The `lvai_vi_terminals` export of Stop Core went to the tool's own cache.

CANNOT PROCEED
