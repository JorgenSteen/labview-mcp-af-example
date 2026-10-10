# Phase 07: the interface and its one message (`ZM-CI-common_interfaces.lvlib`)

**Type:** build
**Reads:** `01-requirements.md` R5; `02-specification.md` §4, §7.3; `04-decisions.md` D17;
the skill's `knowledge/actor-framework.md` (messages, Message Maker products).
**Scope:** `zuehlke-mcp-af-test-results/src/common/ZM-CI-common_interfaces/`, the project file.
**Suggested agents:** class-generator for the interface (it creates interfaces); a VI agent or the
skill's ops for the message class, which must be what Message Maker would produce (`Send ...`,
`Do.vi`, the message class inheriting from `Message`).

## Goal

One LabVIEW interface `ZM-CI-package_handler` with one method
`ZM-CI-handlePackage(package: ZM-PC-package)`, and one message class `ZM-CI-handlePackage Msg`
generated from it. It is the only message class in the application. The interface passes the
generic package and has no logic.

## Builds

Everything in `02` §7.3: the library, the interface, the method, the message class with its `Send`
VI and `Do.vi`, the virtual folders.

No test VI in this phase: the proof is structural (below) and T7 in phase 10.

## Done when

- The library loads with the project closed; every VI runnable.
- The interface's method has the terminals `02` §7.3 gives; the message class's `Do.vi` calls the
  interface method on the actor cast to the interface.
- The library depends on `ZM-PC-packages.lvlib` and the Actor Framework only.
- Committed: `feat(ci): package handler interface and its message`.

## Notes

- Message Maker is a LabVIEW tool; if the toolchain cannot drive it, the message class is built
  by the skill's route and must match Message Maker's shape exactly (names, inheritance, the
  `Do.vi` override). The report says which route was used.
- An actor overrides `ZM-CI-handlePackage` in its `Methods` folder (D35), in phases 08–10.
