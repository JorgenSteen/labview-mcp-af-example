# labview-mcp report: run-01, session 2 (2026-10-11 09:34 to 10:58)

## Environment

- LabVIEW 2026 Q3 32-bit, PID 14040 (started by the manager 2026-10-10 15:24), port 59552, labview-mcp 1.9.5-local
  (f9ee41d9). No start, restart or crash this session. Manager and agents on Opus 5.5 (the user's `/model`).

## Use

| step | agent (type, fresh) | LabVIEW calls | wall clock | result |
|---|---|---|---|---|
| 05a2 | general-purpose | ~37 | 09:36-09:45 | recovered the open project; four UDP overrides hooked; open hooks regenerated with PRTC |
| 05b | general-purpose | ~60 | 09:47-10:01 | MX class: array-of-class typedef, reentrant hooks, three overrides, library |
| 05c | general-purpose | ~22 | 10:04-10:16 | T5 PASS, T4 PASS (seven checks) after a 1357 on regeneration |
| 05d | general-purpose | 61 | 10:17-10:27 | cleanup and icons for 27 VIs |
| 06 | general-purpose | 35 | 10:30-10:39 | T6 PASS (round 2), T1-T6 rerun PASS |
| 07 | general-purpose | 41 | 10:42-10:50 | interface, method, Message Maker message class in a Messages folder |

## Issues

| # | issue | kind | where | workaround | candidate id |
|---|---|---|---|---|---|
| 1 | a hook after Call Parent that writes a child field and returns the written object reads state 0 on the override | LabVIEW fact / trap | report-05a2 item 3 | `Preserve Run-Time Class` on the hook's output | (knowledge) |
| 2 | `lvai_generate_vi` over a VI that is a member of a loaded library answers 1357 | tool gap | report-05c item 6a | remove the member (project closed), regenerate, re-add | add-class-method-rerun |
| 3 | `Equal?` on clusters is generated in Compare Elements mode | AIXML gap | report-06 item 2 | `Cluster To Array` + `And Array Elements` | vi-server-catalogue |
| 4 | the Message Maker helper writes the message class flat into its destination | kit gap | report-07 item 4 | create `<Msg>\` first and pass it | message-interface-method |
| 5 | reentrancy flags of a pylv-edited VI read differently after LabVIEW's next save | LabVIEW fact (unmeasured meaning) | report-05b item 8b, report-05d item 4 | none needed; the VIs work | control-property-setters |
| 6 | agents put two or three tool calls in one message in four of six steps | agent rule break | F9; reports 05a2, 05b, 05d, 07 | none; harmless here | call-lock |

## Side effects

LabVIEW kept running (PID 14040); the project closed at the end; stub cache +7; helper VIs regenerated in place
(`lvai_create_actor_library.vi`, `lvai_create_message_class.vi`), new `zmp05c_save_orphan*.vi`; output\ test folders.
No item removed, nothing upgraded.

## Open at the end

Phase 08 next (brief 08a filled; 08b, 08c drafted). F3, F6, F8, F9 open for the user.
