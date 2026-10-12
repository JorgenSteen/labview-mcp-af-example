# Zuehlke MCP

A small LabVIEW **Actor Framework (AF)** application, prefix **`ZM`**, LabVIEW project
**`Zuehlke MCP.lvproj`**. It moves simulated measurement data from a hardware object, through a tree
of three actors, to one or more output protocols: a JSON Lines file per package type, and a UDP
stream that a separate viewer VI can show live.

Simulated hardware produces a measurement package every 500 ms. A tree of three actors (root,
hardware manager, communication manager) moves the package through one interface message. The
root routes each package by its destination. Two output protocols exist: a JSON Lines file per
package type, and a UDP stream a separate receiver VI can show live. There is one error-handling
plan, one custom error code (5000, `src/errors/ZM-errors.txt`, catalogue in `docs/error-codes.md`),
and no configuration files.

The application must have a clean dependency structure and a consistent naming, layering and
error-handling scheme that can serve as a template.

## Environment

**LabVIEW 2026 Q3, 32-bit**, Actor Framework from `vi.lib`. Tests are plain test VIs (no Caraya,
LUnit or VI Tester). The project's save version is recorded in `.labview/project.json`.

## Open the project

Open `src/Zuehlke MCP.lvproj` in LabVIEW 2026 Q3 32-bit. The project tree has the virtual folders
`common`, `hardware`, `protocol`, `actors`, `tests` and `receiver`.

## Run it

- **Interactive:** run `src/ZM-launcher.vi`. It launches the root actor; the root's panel opens.
  `output_folder` is optional (empty = `output/` in this folder). The tree runs until **Stop** is
  pressed on the root's panel. The hardware manager's live panel shows the chart and the measured
  interval.
- **Headless:** run `src/ZM-launcher_test.vi`. It deletes the two output files, launches the root
  (optionally with the placeholder hardware, which is the error run), waits `run_time_ms`, sends
  Normal Stop and returns the line counts, the last line and the panel's errors.
- **Receiver:** run `src/receiver/ZM-receiver.vi` while the tree runs to watch the UDP stream on
  `127.0.0.1:61557`. It can start and stop at any time. The root's panel shows this hint (the
  `receiver` virtual folder in the project).
- **Viewer:** open `tools/jsonl_viewer.html` in a browser and drop `output/TestPackage.jsonl` on it.

Run-time output goes to `output/` (`<type>.jsonl` per package type, `ZM-error_log.txt`); it is
git-ignored. A clean stop leaves the error log empty.

## Layout

```
src/        Zuehlke MCP.lvproj, the launchers, and every library, class and VI
src/errors/ ZM-errors.txt, the LabVIEW error-code file for code 5000
docs/       error-codes.md, the custom error catalogue
tools/      jsonl_viewer.html
output/     run-time output (git-ignored)
proof/      throwaway measurements (git-ignored)
.labview/   the labview skill's conventions, decisions and checks for this project
```

This code was generated from written requirements by the test described one folder up
(`../README.md`); no human wrote any LabVIEW code in it.
