# Phase 05: UDP transport and multi protocol (`ZM-CP-UDP-udp_transport.lvlib`, `ZM-CP-MX-multi_protocol.lvlib`)

**Type:** build
**Reads:** `01-requirements.md` R4 (UDP, MX), R6; `02-specification.md` §7.8, §7.9;
`03-acceptance.md` T4 (`mx_placeholder_ok`), T5; `04-decisions.md` D24, D25, D26, D37;
`zuehlke-mcp-af-test-results/docs/error-codes.md` (ignored codes 66 and 56).
**Scope:** `zuehlke-mcp-af-test-results/src/protocol/ZM-CP-UDP-udp_transport/`, `zuehlke-mcp-af-test-results/src/protocol/ZM-CP-MX-multi_protocol/`,
`zuehlke-mcp-af-test-results/src/tests/`, the project file.
**Suggested agents:** class-generator for the three classes (sender and receiver in one library,
MX in another); a VI agent for methods and the test.

## Goal

The UDP sender (one JSON line per datagram, unicast to `127.0.0.1:61557` by default, sending to
nobody is silent), the UDP receiver (the reading side; it does not override `publish`), and the
composite MX holding an array of protocols whose `init`, `publish`, `close` go to every element in
order, stopping at the first error.

## Builds

Everything in `02` §7.8 and §7.9, including `ZM-CP-MX-PROTOCOLS.ctl`. Ignored codes 66 and 56 are
cleared where `zuehlke-mcp-af-test-results/docs/error-codes.md` says, with `Clear Errors.vi`, never unwired.

Test: `zuehlke-mcp-af-test-results/src/tests/ZM-TST-udp.vi`, the checks of T5; and the `mx_placeholder_ok` check of T4 added
to `ZM-TST-protocol.vi` if phase 04 left it out.

## Done when

- Both libraries exist; the UDP library depends on `ZM-CP-communication_protocol.lvlib` and
  `ZM-PC-packages.lvlib` only; MX on the parent only.
- `ZM-TST-udp.vi` runs, `Pass` true; `ZM-TST-protocol.vi` `Pass` true with every check.
- Ending steps of `plan.md` done; committed: `feat(cp): udp transport and multi protocol`.

## Notes

- The receiver's `publish` is deliberately not overridden: publishing through it returns 5000 and
  T5 checks that (D25).
- Port 61557 must be free on the machine during T5. If it is not, the test fails for a reason
  that has nothing to do with the code; the report says so.
- The datagram bytes equal the file line of phase 04 (D24).
