REPORT 10c: ROOT panel loop `ZM-ROOT-helperPanel.vi`. **DONE.** The member reads cold state 1, and the cold sweep of the ROOT folder reads 25/25 at state 1. No NEEDS CLARIFICATION. I made 30 LabVIEW calls, each one alone in its own message.

**1. Status**
- `lvai_status` at the start (19:20): ok, port 52603, PID 26148, up 1671 s, dwarn 0.
- At the end (~19:26): same PID and port, up 1961 s, dwarn 4, not degraded. The latest DWarn is "bad to good after compiling" on helperPanel.
- LabVIEW starts made: 0. The project is closed. `lv_windows`: unsaved 0, dialogs 0, LVAutoSave 0.

**2. Helper-loop report block**
```
loop ZM-ROOT-root:ZM-ROOT-helperPanel.vi variant 1  events stop, error (+ static Stop Value Change)  member private static  folder asked (Helpers, D38)
members: createEvents stop close (10b)  add_class_method 1 call (vi only)  swaps 2 calls (repeated stubs)  error case No Error/"Error .."
build: generate ok (state 0 expected)  left+right: derived zmp09c_wire_dyn_deep, left 2 ends broken F, right 2 ends broken F  specs 0:error:2 2:stop:1 (static row 1 kept)  data fields ok (4413 4414:4)
panel on call 1/1 (cold)  Stop action 1 (cold)  stop hidden n/a  export ok  locals 2 (Stop write F, errors read)
hooks: not here (10d)   sweep 25/25, control 0 7, membership ok (25/0)
run: not run (10d; the loop VI was never run by itself)   unmeasured steps met: static frame beside 2 user events in a nested ES, payload field in a nested frame
side effects: see 9   commits 4c72e8d 4e8b180 58e06c3   LabVIEW calls 30   issues: none
```

**3. What differed from the 09c route**
- I first ran the whole route on a throwaway (`proof\ZMP-10c\ZMP-10c-throwaway.vi`, own `_name`): generate, wire, specs, use-default, data field. Its verify copy read state 1 and its export was correct. Then I repeated the same steps on the member.
- **The static frame:** `lvai_generate_vi_with_events` registered ` "Stop"\3A Value Change ` itself, as diagramIdx 1 on the control. The generator's own dynIndex was N+1 = 3; after `set_user_event_specs.py 0:error:2 2:stop:1` the static row was still there (source 3).
  - Frames are in document order: error (0), Stop (1), stop (2). No Timeout frame was needed.
- **The event data field:** `lvai_set_event_data_fields 4413 4414:4` on the String payload. The export shows Event Data Node `fields="Source,error,Time"`, with `error` going into Concatenate Strings. The placeholder constant is kept, unwired.
- **The Stop local:** authored in AIXML in the Stop frame (`Local Variable element="Stop"` ← F). After that frame's Send, Read Self Enqueuer → Send Normal Stop; the send error goes to the frame's error output, and the loop goes on.
- **Stubs:** I reused existing stubs and made no new ones:
  - `3cde02f8b6` → Read events;
  - `ZMP10b-close` → ZM-ROOT-stop (same pane);
  - `17e772cb85` (HWM evaluateError, same pane 4815) → ZM-ROOT-evaluateError;
  - `91950b9cd6` / `9475868c6c` → Read Self Enqueuer / Send Normal Stop, used twice each, so the second swap call took the rest.
- **Use-default:** `zmp09c_set_use_default.py` set 1 tunnel (selTun 517, 0x100801 → 0x300801) in the same extract/rebuild round trip, as in 09c.

**4. Export** (`proof\ZMP-10c\export-ZM-ROOT-helperPanel.xml`)
- Register: Read events (error in) → Unbundle `stop`, `error` → Register For Events with 2 `event source` (stop, error) on the fresh no error, before the loop.
- Unregister: after the loop, on the loop tunnel fed by the case `Out3 cond="true"`. Its error in = Register's error out.
- `vi_nets.py` shows both eventDynDCO wires.
- Shift register: the loop error, seeded by Read events' error out.
- Frames:
  - `<error>`: errors(local) → Empty? → Select("", LF) → Concatenate(old, sep, payload) → `errors`; keep looping.
  - `"Stop"`: Stop = F (local) → Read Self Enqueuer → Send Normal Stop; keep looping.
  - `<stop>`: exit.
  - Case Error frame: exit T.
- D40 tail: a Flat Sequence (after the loop error) runs ZM-ROOT-stop on a fresh no error → Clear Errors. Then Merge(loop error, Unregister) → evaluateError (`stop actor?` unwired) → case. The Error frame runs Read Self Enqueuer → Send Normal Stop (fresh no error) → Clear Errors. `error out` = the raw merge.
- There is no local `stop` Boolean (D40, one loop).

**5. Panel and control, read back cold**
- Show front panel on call 1, close after call 1, state 1 (`pa_read_panel_on_call`).
- `Stop`: mechanical action 1 (Switch When Released), visible T (`pa_read_boolean`).
- `errors`: a plain String indicator. AIXML has no "multi-line" flag; LabVIEW's string default allows multiple lines.

**6. Sweep, membership, versions, links**
- Cold sweep (`proof\ZMP-10c\sweep_final.txt`): 25/25 state 1 (24 + helperPanel), negative control `0 7`.
- `check_membership`: 25 checked, 0 not a member, exit 0.
- Versions: helperPanel 26:3, `.lvclass` 26008000, `.lvproj` 26.0 with SaveVersion 26.0. The `.lvproj` is unchanged, with BOM and CRLF.
- Links: ZM-ROOT-root class and AF only (Actor, Stop Msg, Message, Message Enqueuer, Message Priority Queue). No `LVMCP Stub` link left.
- Scope: MethodScope 2 and LibItem.Scope 2 (`set_scope.py`).
- Static: no dispatch terminal was set. ClassItem.Flags 1073742081 (HWM's loop has 1073741827).

**7. Commits** (explicit paths, no trailer, not pushed)
- 4c72e8d: generated VI.
- 4e8b180: membership, swaps, panel on call.
- 58e06c3: private scope, Stop action.
- `git status --short`: only the untracked `lessons-mcp-skill.md` and `notes-for-run-02.md`, which are not mine.

**8. Deviations and items for the user**
- (a) The VI description and the `Stop`/`errors` descriptions are my texts (D40 wording); please review.
- (b) For the user in the IDE (D38): put `ZM-ROOT-helperPanel.vi` into `Helpers`.
- (c) The `"Stop"` frame's Send error goes into the loop error (keep-looping frame), so a failed self-send ends the loop through the Error frame. This is the same pattern as the HWM producer.
- (d) Not measured here (10d): runs, a headless Stop press (Value (Signaling)), the Actor Core hooks.

**9. Side effects**
- The project was opened and closed 3 times by me (once more inside add_class_method, which I closed afterwards). The sweeps removed nothing; the `.lvproj` is byte-unchanged.
- The `.lvclass` changed only by the new item (8 lines + the scope line).
- No new stubs and no new helpers. I used the cached `%TEMP%\LabVIEWMCP\helpers\zmp09c_wire_dyn_deep.vi`; copies of its source and of `zmp09c_set_use_default.py` are in `proof\ZMP-10c\`.
- `proof\ZMP-10c\` (git-ignored) holds the AIXML, the throwaway (+ x1 copy), bundles, both exports and the sweep list.
