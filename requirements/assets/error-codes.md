# Custom error codes

Every custom error code the project raises. Add a row here **and** an entry in
`src/errors/ZM-errors.txt` whenever a new code is introduced.

- **Range:** 5000–5999 (inside LabVIEW's user-defined range 5000–9999).
- **Registry:** `src/errors/ZM-errors.txt`, LabVIEW's error-code file format (the file name must end
  in `-errors.txt`). Copy it to `<LabVIEW 2026>\user.lib\errors\` and restart LabVIEW; then *Explain
  Error* and `Error Cluster From Error Code.vi` show the text below.
- **Marker:** every place that raises a custom code carries a free label `#customerror <code>` on
  its block diagram, next to the node that builds the error. Search for `#customerror` to find
  them all (in the AIXML exports or with the VI search).

| code | message | when it happens | how to fix it | raised in |
|---|---|---|---|---|
| 5000 | a parent placeholder method was called; the child class must override it | a bare parent object (`ZM-HW-hardware`, `ZM-CP-communication_protocol`) is used where a child was meant, or a new child class forgot to override the method. The error `source` names the VI. `ZM-CP-UDP-receiver` does not override `publish` on purpose (D25), so publishing through a receiver gives 5000 | inject the intended child class (the root's launch methods), or add the missing override to the child. In the Phase 6.4 error run it is raised on purpose | `ZM-HW-do.vi` (parent), `ZM-CP-publish.vi` (parent) |

## Ignored system codes

LabVIEW or system codes that a VI clears on purpose because they are expected and harmless. Each
row names the VI that clears it. No custom code is raised for these.

| code | meaning | why it is ignored | cleared in |
|---|---|---|---|
| **66** | UDP "no listener" (M4a): `UDP Write` itself returns 0, but the next `UDP Read` on the sending socket returns 66 at once (Windows ICMP port-unreachable reset). The sender never reads, so 66 is cleared defensively |  sending to nobody must be silent (D25) | `ZM-CP-UDP-sender` `ZM-CP-publish.vi` |
| **56** | UDP timeout (M4a): `UDP Read` with no datagram in `timeout ms`. Cleared defensively in the sender; in the receiver cleared into `timed_out` | sending to nobody must be silent (D25): the viewer starts and stops whenever it likes | `ZM-CP-UDP-sender` `ZM-CP-publish.vi` |
