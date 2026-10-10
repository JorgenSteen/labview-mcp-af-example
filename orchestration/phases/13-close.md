# Phase 13: close the run

**Type:** close
**Reads:** `05-skill-alignment.md` (the expected differences); `runs/<run>/status.md`,
`findings.md`, `cost.md`; the skill's `session/close.md`.
**Scope:** `runs/<run>/`, `runs/README.md`, the repository `README.md`. No LabVIEW call is needed unless
`session/close.md` asks for the MCP report's status read.
**Suggested agent:** the manager itself, or a general-purpose agent following `session/close.md`
for the MCP report.

## Goal

Leave the repository in a state where someone who was not there can see what happened, what it
cost, what passed, where the remake differs from the original, and what the skill and the tools
got wrong.

## Steps

1. **Compare with the original.** For every row of `05-skill-alignment.md`, note whether the
   remake shows the expected difference. Every *other* difference between `zuehlke-mcp-af-test-results/src/` and `02` is a
   finding. Write the result to `runs/<run>/comparison.md`.
2. **Findings.** `runs/<run>/findings.md` holds every requirement error, ambiguity that had to be
   asked, skill gap and tool issue hit during the run, each with evidence (the brief, the report,
   the error text). Skill gaps are phrased so they can be filed against
   https://github.com/JorgenSteen/labview-mcp-skills; labview-mcp issues so they can go upstream.
3. **Cost.** `runs/<run>/cost.md` complete: one row per phase with start, end, minutes, tokens as
   seen; ask the user to run `/cost` and paste the output at the bottom.
4. **MCP report** per `session/close.md` into `runs/<run>/mcp-reports/`.
5. **Status.** `status.md` marked `closed`, every phase row filled, "where the next session
   starts" replaced by "run closed; result: accepted | partial | abandoned".
6. **Run log.** The row in `runs/README.md` filled.
7. **README.** Replace the "not yet run" note at the top of the repository `README.md` with one
   line pointing at the run folder and its result.
8. **Tag** the final commit `run-NN-result`, so the product can be deleted for the next run and
   still be found (`README.md`, "Resetting").
9. **Commit:** `docs(run-NN): close run, comparison, findings, cost`.

## Done when

- `comparison.md`, `findings.md`, `cost.md`, `status.md` (closed) exist and are committed.
- `runs/README.md` has the run's row.
- The repository `README.md` points at the result.

## Notes

- Nothing in this phase is an estimate. A number that was not seen is "not visible".
- A run that ended `partial` or `abandoned` is closed the same way; the value of the test is in the
  record, not in the pass.
