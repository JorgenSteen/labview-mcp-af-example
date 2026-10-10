# Smoke test

A short run to prove the basics before spending a real run on them: the manager reads the right
files, asks the right question, writes a brief, launches one agent, verifies, commits, and
everything can be put back. Two levels; do the first, then the second.

## Before either level

Either tag the clean state so the revert is one command:

```
git tag pre-smoke
```

or run the smoke test in a **copy of the whole folder** and delete the copy afterwards. The copy
is simpler and keeps the real repository untouched; tell the manager which you did, so it does
not go looking for the tag.

The manager cannot read the session's effort setting. State it in the first message, together
with the model the agents should run on, so `cost.md` can record both.

## Level 1: no LabVIEW

Tell the manager: "smoke test, level 1". It then does phase 00 steps 1 to 3 only (run folder,
git check, product folder skeleton) and stops. No LabVIEW call, no agent launch.

What to look for:

- it reported the state correctly (no run, no product folder, phase 00 next) and asked once;
- `runs/run-01-<date>/` exists with `status.md`, `cost.md`, `findings.md` and the three empty
  folders;
- `zuehlke-mcp-af-test-results/` exists with `README.md`, `.gitignore`, `.gitattributes`,
  `src/errors/ZM-errors.txt`, `docs/error-codes.md`, `tools/jsonl_viewer.html`, `output/.gitkeep`;
- one commit, Conventional Commits, no attribution trailer, nothing outside those two folders;
- it did not offer to push.

Takes minutes.

## Level 2: phase 00 complete

Tell the manager: "smoke test, level 2". It runs all of phase 00: the status call, the go-ahead
question about `user.lib\errors\` (answer **no** for the smoke test, so nothing outside the repo
is touched), the skill setup by one agent, the empty project, the close.

What to look for, beyond level 1:

- `lvai_status` answered and the machine facts are in `status.md`;
- the brief was saved under `runs/<run>/briefs/` before the agent started, and the report under
  `reports/` after;
- `zuehlke-mcp-af-test-results/.labview/` exists with `project.json`, `decisions.md`,
  `checks.json` and seven `conventions/*.md`; the three run-folder paths in `project.json` point
  up into `runs/<run>/`;
- `zuehlke-mcp-af-test-results/src/Zuehlke MCP.lvproj` exists and opens in LabVIEW with the six
  virtual folders;
- the manager made no LabVIEW call of its own after the status call;
- `cost.md` has a row for the launch with the agent type, model and effort filled in.

Takes longer: the skill's setup reads its defaults and writes seven convention files through an
agent. Expect tens of minutes and a noticeable token spend; that spend is itself useful data.

## Revert

In a copy: delete the copy. In the real repository:

```
git reset --hard pre-smoke
git clean -fd
git tag -d pre-smoke
```

`git clean -fd` removes the untracked run folder and product folder. Check with `git status` that
the tree is clean and `ls` that both folders are gone. If level 2 copied anything into
`user.lib\errors\` (it should not, with a "no"), remove it by hand.

The smoke test leaves nothing behind in the repository. Note what it taught you (a question the
manager should not have asked, a file in the wrong place, a stall) in a scratch file outside the
repository or straight into the phase card it concerns, then commit that fix before the real run.
