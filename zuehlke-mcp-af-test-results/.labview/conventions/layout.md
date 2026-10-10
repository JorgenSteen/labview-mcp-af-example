# Convention: layout
status: in force
written: 2026-10-10 by conventions/setup.md

## library-per-actor
Each actor is wrapped in its own `.lvlib`, named after the actor. Interfaces shared by several actors live in a
library of their own. If children of a parent class should be pluggable (installed, replaced or left out
independently), each child gets its own library that depends on the parent's library. Parent and children may share
one library only when they always ship together.
Why: a LabVIEW library is a load unit. Loading any member loads every class in the library and its dependencies.
Addition for this project: the UDP sender and receiver share one library `ZM-CP-UDP-udp_transport.lvlib` and the
abbreviation `UDP`.
Why: "two ends of one transport, always shipped together"
source: decided 2026-10-10 (decisions.md#D37)

## class-folders
An actor's virtual folders: `Accessors`, `AF Overrides`, `Helpers` (helper-loop VIs), `Messages`, `Methods`,
`TypeDefs`, plus `SubVIs` when needed. A plain class uses only the subset it needs (e.g. `Accessors`, `Methods`,
`TypeDefs`). A folder is created only when it holds something. If the folder a new member belongs in is missing in
an existing class, stop and ask; never fall back to the class root.
Addition for this project: overrides of a parent class's or an interface's method go in `Methods` (there is no
`Overrides` folder).
Why: "the skill's folder list has no place named for them; they are methods of the class"
source: decided 2026-10-10 (decisions.md#D35)

## flat-files
Member files stay flat in the class folder on disk. Virtual folders organise them; disk folders do not mirror them.
Why: moving a member file outside LabVIEW breaks the class's link to it.
source: default

## typedef-placement
A typedef that belongs to a class is a member of that class, in its `TypeDefs` virtual folder, with its file flat in
the class folder. Typedefs do not go in a library-level `Controls` folder.
source: default

## scope
New class members are private. Use public only when something outside the class calls the member (e.g. what a
message's `Do.vi` calls, an API method, `writePrelaunchSettings`), and protected for what children override or call. Existing scopes are not
changed.
source: default

## accessors-on-demand
Accessors are created only when some code uses them, and only in the direction used: the Read or the Write, never
both by default, and never one for every field. The set that exists then shows what is used. They are static (not
dynamic dispatch) unless dispatch is wanted on purpose, private by default (`scope`), and kept in `Accessors`.
source: default

## accessors-for-own-data
New members read and write the class's own fields through accessors, never by Unbundle/Bundle of the class wire.
This also applies to the class's own data. Existing members keep their Unbundle/Bundle.
Why: Find Callers on an accessor then shows every read and every write of that field.
source: default
