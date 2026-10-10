# Phase 08: the communication manager actor (`ZM-CM-communication_manager.lvlib`)

**Type:** build (Actor Framework)
**Reads:** `01-requirements.md` R1 (CM), R5 (CM behaviour), R7, R8; `02-specification.md` §5,
§6, §7.10; `04-decisions.md` D2, D14, D26; the skill's `knowledge/actor-framework.md`,
`ops/override.md`, `conventions/defaults/af-shapes.md`, `errors.md`.
**Scope:** `zuehlke-mcp-af-test-results/src/actors/ZM-CM-communication_manager/`, the project file.
**Suggested agents:** class-generator for the class (inherits `Actor`, implements the interface,
the fields and `ZM-CM-PRELAUNCH_SETTINGS.ctl` of `02` §7.10); a general-purpose agent following
the skill's ops for the overrides and hook VIs.

## Goal

The CM owns a protocol object from its pre-launch settings, initialises it in Pre Launch Init
through `createResources`, hands every package it receives to `publish` and counts it, and
releases the protocol in Stop Core after Call Parent. Its Handle Error calls the parent first,
then `ZM-CM-evaluateError`: log, send an error package up, stop with the error cleared.

## Builds

Everything in `02` §7.10: the public `writePrelaunchSettings`, the three AF overrides (Pre Launch
Init, Stop Core, Handle Error) as protected overrides calling the parent, the hook VIs, the
`ZM-CI-handlePackage` override in `Methods`. The class description states the error plan (D14).
The CM has no helper loop and no user events.

Proof in this phase: a throwaway launch in the proof folder (the skill's `proof_folder`), never
in `zuehlke-mcp-af-test-results/src/`: launch the CM with an MX holding one FL on a temp folder, send three test packages
through the interface message, send Normal Stop, check three lines in the file and an empty error
log. The proof VI is not committed into `zuehlke-mcp-af-test-results/src/`.

## Done when

- Every item of `02` §7.10 exists; the class depends on `ZM-CP-communication_protocol.lvlib`,
  `ZM-PC-packages.lvlib`, `ZM-CI-common_interfaces.lvlib`, `ZM-CU-common_utilities.lvlib` and the
  Actor Framework only. **It loads no concrete protocol child** (checked from the files).
- The throwaway launch behaves as above; after Normal Stop the Actor Core is idle.
- Ending steps of `plan.md` done; committed: `feat(cm): communication manager actor`.

## Notes

- Stop Core order: Call Parent first, then `releaseProtocol` (`af-shapes.stop-core-order`).
- Handle Error: Call Parent first, then `evaluateError` on its outputs; no "replace by 43" trick
  (`05-skill-alignment.md`).
- Release errors in Stop Core are logged through `ZM-CU-log` or cleared on purpose.
- `createResources` cleans up what it created if it fails (`af-shapes.pli-failure-cleanup`).
