# Runs

One folder per attempt to build the application from scratch. A run can span several Claude Code
sessions; the status file carries over between them.

## Naming

`runs/run-NN-<yyyy-mm-dd>/`, numbered in order of the first session, dated by that session's start.
The current run is the highest number whose `status.md` is not marked `closed`.

```
runs/run-01-2026-10-xx/
  status.md         the hand-over file (format: orchestration/status-template.md); updated after every phase
  briefs/           brief-NN-<slug>.md, one per subagent launch, saved before the launch
  reports/          report-NN-<slug>.md, the agent's report, unedited
  mcp-reports/      one labview-mcp report per session (the skill's session/close.md)
  cost.md           time and token notes per phase, and the /cost output pasted by the user
  findings.md       requirement errors, skill gaps, tool issues, each with its evidence
```

`zuehlke-mcp-af-test-results/.labview/project.json` points up at these folders (`briefs_folder`,
`status_file`, `mcp_reports_folder`), so the skill's own session files land here and not inside the
product. A run's record therefore survives when the product folder is deleted for the next run;
the product itself is kept under the tag `run-NN-result`.

## Run log

| run | started | ended | phases done | result | notes |
|---|---|---|---|---|---|
| run-01 | 2026-10-10 | 2026-10-11 | 00-13 | partial | three sessions, Fable 5.1 then Opus 5.5; T1-T7 and every run of `03` §2 pass (R-error under D40); `03` §3 rows needing the user in the IDE (D38) pending, library count F3 undecided; user decisions D38-D41; tag `run-01-result`; `runs/run-01-2026-10-10/` |

Fill one row per run when it closes. "Result" is one of: `accepted` (every check in
`requirements/03-acceptance.md` holds on a cold start), `partial` (name the last phase that passed),
`abandoned` (say why).

## Cost

`cost.md` in each run holds a table with one row per agent launch:

| phase | step | agent type | model | effort | start | end | minutes | tokens seen | notes |
|---|---|---|---|---|---|---|---|---|---|

The manager's own model and effort are stated once at the top. The `/cost` output the user pastes
goes at the bottom, per session. Where a number is not known, the cell says `not visible`. Nothing
in this folder is an estimate. The model column is what makes two runs comparable: the first run
proves the route on the strongest model, later runs measure cheaper ones
(`orchestration/plan.md`, "Models and effort").
