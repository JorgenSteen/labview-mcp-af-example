# Convention: naming
status: in force
written: 2026-10-10 by conventions/setup.md

Every name of this project is listed in `requirements/02-specification.md`; that file is the source of truth for
names. The project prefix `<P>` is `ZM` (`project.json` `prefix`).

## prefix
Every hand-written file starts with `<P>-<ABBR>-`. `<P>` is the project prefix (`project.json` `prefix`). `<ABBR>`
is the abbreviation of the owning actor, class or library, unique within the project. Example:
`PRJ-COM-helperCommunicationReceiver.vi`.
Why: a file name says who owns it, also outside LabVIEW (git, search, file lists).
Addition for this project: top-level VIs with no owner keep `ZM-<name>.vi` (`ZM-launcher.vi`,
`ZM-launcher_test.vi`, `ZM-receiver.vi`).
Why: "they belong to no actor, class or library"
source: decided 2026-10-10 (decisions.md#D36)

## method-case
Class members are methods and are named in camelCase after the prefix. That covers every member VI, including
helper-loop VIs, hook VIs and custom accessors. Example: `<P>-<ABBR>-readSettings.vi`.
source: default

## function-case
Plain function VIs (not members of any class) are named in snake_case after the prefix. Example:
`<P>-<ABBR>-format_timestamp.vi`.
source: default

## typedef-case
Typedefs are named in UPPER_SNAKE after the prefix. Example: `<P>-<ABBR>-PRELAUNCH_SETTINGS.ctl`.
source: default

## override-names
AF overrides (`Pre Launch Init.vi`, `Actor Core.vi`, `Stop Core.vi`, `Handle Error.vi`, ...) and interface overrides keep
the parent's name. Message Maker products keep the tool's names (`<method> Msg.lvclass`, `Send <method>.vi`,
`Do.vi`).
source: default

## accessor-names
Generated accessors keep the default names `Read <field>` / `Write <field>`, with no rename. A custom accessor (a
grouping of fields that belong together) gets a proper camelCase name per `method-case`.
source: default

## class-library-names
Classes and libraries are named `<P>-<ABBR>-<name>`, with `<name>` in snake_case. Example:
`<P>-HWM-hardware_manager.lvclass`.
source: default

## field-names
Private data fields are named in camelCase without the prefix. Examples: `events`, `prelaunchSettings`.
source: default

## element-labels
The JSON keys of the output are typedef element labels in snake_case: header `timestamp`, `type`, `destination`,
`data`; data `temperature_c` DBL, `sample_index` I32, `duty_percent` U8, `sensor_ok` Boolean, `status` String;
error data `sender`, `code`, `source`. Other element labels are camelCase.
Why: "the keys are the output format; changing them breaks the viewer and the receiver"
source: decided 2026-10-10 (decisions.md#D4)

## role-names
Members and typedefs with a fixed role in an actor (`af-shapes`) have these default names:

| Role | Default name |
|---|---|
| helper-loop VI | `<P>-<ABBR>-helper<Purpose>.vi`, e.g. `helperCommunicationReceiver` |
| creates everything Pre Launch Init owns, cleans up on its own error | `<P>-<ABBR>-createResources.vi` |
| creates the actor's user events (called by `createResources`) | `<P>-<ABBR>-createEvents.vi` |
| sends the helper loop's stop (Actor Core) | `<P>-<ABBR>-stop.vi` |
| releases what the helper loop used (Actor Core) | `<P>-<ABBR>-close.vi` |
| the actor's own user events | `<P>-<ABBR>-EVENTS.ctl`, field `events` |
| global events (root) | `<P>-<ABBR>-GLOBAL_EVENTS.ctl`, `<ABBR>` = the root's |
| pre-launch settings | `<P>-<ABBR>-PRELAUNCH_SETTINGS.ctl`, field `prelaunchSettings` |
| writes the pre-launch settings (custom accessor) | `<P>-<ABBR>-writePrelaunchSettings.vi` |
| launches a child (a method of the caller) | `<P>-<ABBR>-launch<Child>.vi`, e.g. `<P>-ROOT-launchHwm.vi` |

An existing project's own role names (found by the analysis) replace these.
source: default
