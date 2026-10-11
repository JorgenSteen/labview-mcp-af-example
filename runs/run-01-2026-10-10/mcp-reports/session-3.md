# labview-mcp report: run-01, session 3 (2026-10-11 10:58 to ~22:05)

## Environment

- LabVIEW 2026 Q3 32-bit, labview-mcp 1.9.5-local (f9ee41d9). Three LabVIEW instances this session:
  - PID 14040 (from session 1): closed by the user at ~11:01 through its "Save changes? (Exit)" dialog (only
    `LVMCP Validate*` scratch VIs unsaved).
  - PID 14516: started by the 08a agent 11:03 (port 59983); killed 18:52 under the user's single kill go-ahead
    ("you may kill LabVIEW") to clear a suspected stale state (it was not the cause, see issue 4).
  - PID 26148: started 18:52 (port 52603); killed 20:42 under the user's standing go-ahead ("feel free to kill labview
    at will for this session") because a hung ROOT tree from 12a (F14) held it.
  - PID 26716: started 20:42 (port 56779); running at the end.
- Manager and agents on Opus 5.5 (`claude-opus-5-5`); effort not visible.

## Use

| step | agent (type, fresh) | LabVIEW calls | wall clock | result |
|---|---|---|---|---|
| 08a | general-purpose | 24 | 11:03-11:10 | CM class, typedef with a class element (derived helper), accessors |
| 08b | general-purpose | ~45 | 11:13-11:26 | CM hooks, interface override, library, three AF overrides |
| 08c | general-purpose | ~69 | 11:32-11:46 | CM launch proof, PLI failure, cleanup, icons |
| 09a | general-purpose | ~27 | 11:49-11:56 | HWM class, two typedefs (U32 default by a derived helper) |
| 09b | general-purpose | ~44 | 11:58-12:10 | HWM hooks, override, library, PLI, Handle Error |
| 09c | general-purpose | ~60 | 12:14-~13:20 (with a clarification) | HWM helper loop (event structure three levels deep), D40 |
| 09d | general-purpose | ~100 | 13:46-14:12 | HWM Actor Core, proofs, cleanup, icons |
| 10a | general-purpose | 24 | 14:57-15:03 | ROOT class |
| 10b | general-purpose | ~71 + 11 + 7 | 15:08-15:33, 18:52-18:56, 19:13 | ROOT hooks, routing, library; launchHwm broken wire (issue 4) |
| 10c | general-purpose | 30 | 19:20-19:26 | ROOT panel loop |
| 10d | general-purpose | 31 | 19:30-19:39 | ROOT Actor Core, T7, launch proofs, Stop press |
| 10e | general-purpose | 56 | 19:42-19:53 | ROOT cleanup, icons, closing checks |
| 11a | general-purpose | 16 | 19:58-20:04 | launchers |
| 11b | general-purpose | 24 | 20:08-20:14 | receiver, cleanup, icons |
| 12a | general-purpose | 38 | 20:18-20:30 | the runs of `03` §2; R-pli-failure hung (F14) |
| 12c | general-purpose | ~80 | 20:42-21:12 | D41 on the HWM |
| 12d | general-purpose | ~60 | 21:15-21:30 | D41 on the ROOT; R-pli-failure passes |
| 12b | general-purpose | 4 (rest offline) | 21:32-22:20 | structural checks, cold sweep 137/137 |
| 12e | general-purpose | 15 | ~21:45-21:56 | T7 error terminals, CM Handle Error cleanup |

## Issues

| # | issue | kind | where | workaround | candidate id |
|---|---|---|---|---|---|
| 1 | the validator leaves hidden unsaved `LVMCP Validate*` VIs; every LabVIEW close then raises a save dialog no agent may answer, so a restart needs a kill | tool gap | session start, report-10b | the user answered the dialog / gave kill go-aheads | restart-with-guards |
| 2 | `lvai_wire_dynamic_events` searches two levels; the convention's loop (event structure in a case frame in a loop) is three deep | tool gap | report-09c | derived `zmp09c_wire_dyn_deep` | wire-dynamic-events-fix |
| 3 | the right-side wiring leaves a case output tunnel without a value in the Error frame; "Use Default if Unwired" refused by the AIXML catalogue | tool gap | report-09c | pylv objFlags patch 0x100801 -> 0x300801 | vi-server-catalogue |
| 4 | a leftover broken wire segment after generate/swap/bind leaves a VI at state 0; five rebuilds and a restart did nothing, Remove Bad Wires fixed it | tool gap | report-10b, -10b2, -10b3 | `pa_clean_member` (the user's rule: remove broken wires first) | broken-wire-cleanup |
| 5 | `lvai_create_typedef` has no class element and no default value | tool gap | reports 08a, 09a | derived element-replace and default helpers | user-event-cluster |
| 6 | `lvai_placeholder_subvi`: a typedef cluster with a class element becomes a scalar path; same-pane members share one stub | tool gap | reports 08b, 09b, 09c, 10b | hand-made stubs | stub-per-target |
| 7 | `lvai_swap_subvis` `constantsJson` finds top-level constants only | tool gap | report-09c | derived deep-replace helper | swap-deep |
| 8 | misleading answers: `add_class_method` `ok:false`/`pathStandInsLeft` for a stand-in inside a cluster; `bind_typedef_constants` 1055 for a bare name; `exec_state` "error of type 8" for a missing interface override | tool messages | reports 08a, 10b, 08a | read the export / qualify the name | error-messages |
| 9 | `lvai_create_override` keeps NI's help text as the description | tool gap | reports 08c, 09b, 10b | `pa_replace_description` | override-description |
| 10 | `kit/lvproj_drop.py` empties an LF `.lvproj` (CRLF-only split) | kit bug (F10) | report-09a | derived `lvproj_drop_eol.py` | (kit) |
| 11 | `kit/pa_close_join.xml` hard-codes `error in` and skips all steps after an empty Delete | kit bug (F12) | report-09d | derived `zmp09d_close_join` | (kit) |
| 12 | a stop generated before the loop VI registers is lost; the tree hangs (measured; the skill listed it as unmeasured) | AF fact / skill default | F14, report-12a | D41: `init` registers in Actor Core before Call Parent | (knowledge) |
| 13 | agents put two calls in one message in seven of 21 Opus steps | agent rule break | F9 | none; harmless here | call-lock |
| 14 | no tool sets a class description, adds a `.ctl` to a class or moves members into virtual folders, though VI Server can (`LVClassLibrary.Description`, `Library.AddItem`, `ProjectItem.AddItem`/`Move`); the names are missing from the VI Server catalogue | tool gap | report-12f (after the run) | derived `zmp12f_*` helpers | class-folders |

## Side effects

Two kills (14516, 26148) under the user's go-aheads; two starts by agents; the stub cache grew to 219; derived helper
VIs in `%TEMP%\LabVIEWMCP\helpers\` (`zm_*`, `zmp09c_*`, `zmp09d_*`, `zmp12c_*`, `zmp12d_*`), their sources in the
git-ignored `proof\ZMP-*`; output\ test folders (git-ignored). No product item removed; nothing upgraded; every file at 26.

## Open at the end

The D38 IDE list for the user (class descriptions with the D40 texts in `status.md`, virtual folders, `.ctl`
membership); F3 (13 vs 14 libraries); the `error out` on `ZM-launcher.vi` to confirm; `/cost` for sessions 1-3.
