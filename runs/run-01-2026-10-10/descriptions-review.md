# Agent-written VI descriptions, run-01 (read offline 2026-10-11, for the user's review)

## CM Pre Launch Init (472 chars)

Override of Actor:Pre Launch Init (protected, dynamic dispatch) of the communication manager. Call Parent, then the hook ZM-CM-createResources: it initialises the protocol from the pre-launch settings (ZM-CP-init) and writes it into the protocol field; if the init fails, it releases what was opened (ZM-CM-releaseProtocol) and returns the original error, so the launch fails with that error and Stop Core does not run (af-shapes.resources, af-shapes.pli-failure-cleanup).

## CM Stop Core (442 chars)

Override of Actor:Stop Core (protected, dynamic dispatch) of the communication manager. Call Parent first (the parent stops the auto-stop nested actors), then the hook ZM-CM-releaseProtocol closes the protocol (ZM-CP-close): code 1 from a never-opened resource is cleared without a log, any other release error is logged with ZM-CU-log and cleared; the hook's error out ends in Clear Errors (af-shapes.stop-core-order, errors.release-errors).

## CM Handle Error (531 chars)

Override of Actor:Handle Error (protected, dynamic dispatch) of the communication manager. Call Parent first (43 from a normal stop is cleared by the parent), then the hook ZM-CM-evaluateError on the class and the parent's error. By decision D40 (2026-10-11, errors are not handled yet) evaluateError is a pass-through: no log, no error package, no clearing; an error stops the CM, and its Last Ack carries the error to the root, which stops the root and the tree. stop actor? comes from Call Parent (af-shapes.handle-error-order).

## ZM-CM-evaluateError (434 chars)

Hook of the communication manager (static, private), called by the Handle Error override after Call Parent and by a helper loop after its loops. A PASS-THROUGH by decision D40 (2026-10-11: errors are not handled yet): the class, error in and stop actor? in go out unchanged; no log, no error package, no clearing. Shutdown and errors are controlled by the normal stops (an error stops the actor and, through its Last Ack, its caller).

## HWM Pre Launch Init (443 chars)

Override of Actor:Pre Launch Init (protected, dynamic dispatch) of the hardware manager. Call Parent, then the hook ZM-HWM-createResources: it creates the stop user event (ZM-HWM-createEvents) and writes it into the events field; if the create fails, it destroys what was created (ZM-HWM-close) and returns the original error, so the launch fails with that error and Stop Core does not run (af-shapes.resources, af-shapes.pli-failure-cleanup).

## HWM Handle Error (517 chars)

Override of Actor:Handle Error (protected, dynamic dispatch) of the hardware manager. Call Parent first (43 from a normal stop is cleared by the parent), then the hook ZM-HWM-evaluateError on the class and the parent's error. evaluateError is a pass-through for now (D40): the error is not logged, not sent and not cleared, so an error stops the actor and its Last Ack carries the error to the caller, whose default Handle Last Ack Core stops it too. stop actor? comes from Call Parent (af-shapes.handle-error-order).

## HWM Actor Core (911 chars)

Override of Actor:Actor Core (protected, dynamic dispatch) of the hardware manager. ZM-HWM-init runs in series before Call Parent on the class and error wires (D41): it registers for the stop user event, so the registration exists before Call Parent can return, and its error goes into Call Parent. ZM-HWM-helperAcquisition runs beside Call Parent on the class input, a copy of the actor (af-shapes.helper-loop-vi), with the registration refnum from ZM-HWM-init. After Call Parent (the message loop has ended), ZM-HWM-stop fires the stop user event on a fresh error chain, with the class wire from before Call Parent (af-shapes.stop-site). Merge Errors (loop error out, stop error out) feeds ZM-HWM-close, which destroys the events after both (af-shapes.close-vi); Merge Errors (Call Parent error out, close error out) goes to error out, so a helper-loop error reaches the Last Ack (D40). No Stop Core override.

## ZM-HWM-init (840 chars)

Init hook of the hardware manager (private, static), called in Actor Core in series BEFORE Call Parent on the class and error wires (D41). It does everything Actor Core sets up before the actor runs: Read events -> Unbundle By Name stop -> Register For Events on a fresh no error; the event registration refnum goes out on the pane to ZM-HWM-helperAcquisition, which wires it into its event structure's dynamic terminal and unregisters it after its event loop. So the registration exists before Call Parent can return, and the stop event that ZM-HWM-stop generates after Call Parent always reaches the loop (finding F14). The registration runs whatever error comes in; error out = Merge Errors(error in, Read events, Register For Events), so an incoming or a registration error goes on into Call Parent. Error-handling plan: none yet (D40).

## ZM-HWM-helperAcquisition (1634 chars)

Helper loop of the hardware manager (private, static), started by Actor Core beside Call Parent with a copy of the actor; it talks to its actor only through Read Self Enqueuer and Send VIs. Its panel opens when called and closes afterwards. Two loops in this one VI: an EVENT LOOP on the stop user event, whose event registration refnum comes in on the pane from ZM-HWM-init (D41: registered in Actor Core before Call Parent, so no stop is lost) that exits on the event (writing the local stop = T) and a timed PRODUCER LOOP that calls ZM-HW-do every interval set (ms), sends the package to its own actor (ZM-CI-handlePackage), plots a test package on the live chart (temperature_c, duty_percent; any other package is skipped, its cast error cleared), shows the measured interval and exits when the local stop reads T after the Wait or on an error. Before the loops: stop = F and interval set (ms) = prelaunchSettings.intervalMs by local, ZM-HW-init on the settings' hardware. After the producer loop: ZM-HW-close (also on an error, safe state). Every loop stops the other when it ends for any reason (D40): after each loop the stop hook ZM-HWM-stop sends the stop event, its error ignored (Clear Errors); the event loop also writes the local stop = T. After both loops: Merge Errors -> ZM-HWM-evaluateError (a pass-through by D40) -> on an error Read Self Enqueuer -> Send Normal Stop to its own actor. error out is the raw merged error of both loops; the user event is unregistered here and destroyed by ZM-HWM-close in Actor Core. Error-handling plan: none yet (D40): an error stops this actor, and through its Last Ack its caller.

## ZM-HWM-evaluateError (429 chars)

Hook of the hardware manager (static, private), called by the Handle Error override after Call Parent and by a helper loop after its loops. A PASS-THROUGH by decision D40 (2026-10-11: errors are not handled yet): the class, error in and stop actor? in go out unchanged; no log, no error package, no clearing. Shutdown and errors are controlled by the normal stops (an error stops the actor and, through its Last Ack, its caller).

## ROOT Pre Launch Init (525 chars)

Override of Actor:Pre Launch Init (protected, dynamic dispatch) of the root. Call Parent, then the hook ZM-ROOT-createResources: it creates the stop and error user events (ZM-ROOT-createEvents) and writes them into the events field; if the create fails, it destroys what was created (ZM-ROOT-close) and returns the original error, so the launch fails with that error and Stop Core does not run (af-shapes.resources, af-shapes.pli-failure-cleanup). The children are launched from Actor Core, not here (af-shapes.launch-owner).

## ROOT Handle Error (494 chars)

Override of Actor:Handle Error (protected, dynamic dispatch) of the root. Call Parent first (43 from a normal stop is cleared by the parent), then the hook ZM-ROOT-evaluateError on the class and the parent's error. By decision D40 (2026-10-11, errors are not handled yet) evaluateError is a pass-through: no log, no clearing, the error goes out unchanged, so an error stops the root and, through AF's Stop Core, the whole tree. stop actor? comes from Call Parent (af-shapes.handle-error-order).

## ROOT Actor Core (1232 chars)

Override of Actor:Actor Core (protected, dynamic dispatch) of the root. Before Call Parent, ZM-ROOT-init runs in series on the class and error wires (D41): it launches the nested actors (ZM-ROOT-launchCm first, then ZM-ROOT-launchHwm, so the CM enqueuer is stored before the first package arrives; af-shapes.launch-owner, D6) and registers for the stop and error user events; a launch or registration error goes into Call Parent, so the root stops at once, and the registration exists before Call Parent can return, so the stop event always reaches the panel loop (F14). ZM-ROOT-helperPanel (the panel loop with the Stop button and the errors string) runs beside Call Parent on a copy of the actor with init's event registration refnum (af-shapes.helper-loop-vi). After Call Parent (the message loop has ended), ZM-ROOT-stop fires the stop user event on a fresh error chain (af-shapes.stop-site). Merge Errors (panel loop error out, stop error out) feeds ZM-ROOT-close, which destroys the user events after both (af-shapes.close-vi); Merge Errors (Call Parent error out, close error out) goes to error out. Errors are not handled yet (D40): an error stops the root, and AF's Stop Core stops the nested actors. No Stop Core override.

## ZM-ROOT-init (1038 chars)

Init hook of the root (private, static), called in Actor Core in series BEFORE Call Parent on the class and error wires (D41). It does everything Actor Core sets up before the actor runs: ZM-ROOT-launchCm -> ZM-ROOT-launchHwm (the class and error in series; each writes its enqueuer into the class) -> Read events on a fresh error chain -> Unbundle By Name stop, error -> Register For Events on a fresh no error (stop first, error second); the event registration refnum goes out on the pane to ZM-ROOT-helperPanel, which wires it into its event structure's dynamic terminal and unregisters it after its event loop. So the registration exists before Call Parent can return, also when a launch failed, and the stop event that ZM-ROOT-stop generates after Call Parent always reaches the panel loop (finding F14). The registration runs whatever error the launches give; error out = Merge Errors(launch chain, Read events, Register For Events), so a launch or a registration error goes on into Call Parent. Error-handling plan: none yet (D40).

## ZM-ROOT-helperPanel (1401 chars)

Panel loop of the root (private, static), started by Actor Core beside Call Parent with a copy of the actor; it talks to its actor only through Read Self Enqueuer and Send VIs. Its panel opens when called and closes afterwards. One event loop (variant 1): the event registration refnum input (stop first, error second) comes from ZM-ROOT-init, which registers in Actor Core before Call Parent (D41, F14), and goes into the event structure's dynamic terminal; Read events gives only the error that seeds the loop's shift register; the loop carries its error in a shift register; Error frame: the loop stops; No Error frame: the event structure. Stop Value Change: Stop = F by local (Switch When Released), then Read Self Enqueuer -> Send Normal Stop to its own actor, and the loop goes on. error user event: the event's text is appended to the errors indicator, a newline between entries. stop user event: the loop exits (its only event exit). After the loop: Unregister For Events; the stop hook ZM-ROOT-stop sends the stop event, its error ignored (Clear Errors, D40); Merge Errors -> ZM-ROOT-evaluateError (a pass-through by D40) -> on an error Read Self Enqueuer -> Send Normal Stop to its own actor. error out is the raw merged error; the user events are destroyed by ZM-ROOT-close in Actor Core. Error-handling plan: none yet (D40): an error stops this actor, and through its Last Ack its caller.

## ZM-ROOT-evaluateError (404 chars)

Hook of the root (static, private), called by the Handle Error override after Call Parent and by the helper loop after its loop. A PASS-THROUGH by decision D40 (2026-10-11: errors are not handled yet): the class, error in and stop actor? in go out unchanged; no log, no clearing. Shutdown and errors are controlled by the normal stops (an error stops the root, and through AF's Stop Core the whole tree).
