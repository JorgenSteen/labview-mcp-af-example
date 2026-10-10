# Convention: configuration
status: off
written: 2026-10-10 by conventions/setup.md

The configuration question ("How will configuration be handled?") was asked and answered on 2026-10-10: this
project has no configuration files. The concern is switched off; the ops apply no rule of it and the review reports
none. The default rules (INI files per topic, a parent configuration class with one child per file, metadata,
defaults-and-missing, who-reads) were removed, not kept.

## no-config-files
No configuration files. The output folder, the UDP address and port, the 500 ms interval and the placeholder flag
are defaults or launcher inputs, passed down in pre-launch settings (`af-shapes.prelaunch-settings`).
Why: "the pilot has four values; a config class hierarchy would outweigh it"
source: decided 2026-10-10 (decisions.md#D34)
