###  SLICE_MARK_START: user_apps  ###  EDITS OUTSIDE THESE MARKS WILL BE LOST ON UPGRADE

keymap("User overrides terminals", {
    # Tab navigation
    C("RC-Left"):  C("C-Shift-Page_Down"),     # Tab nav: Go to prior tab (Left)
    C("RC-Right"): C("C-Shift-Page_Up"),       # Tab nav: Go to next tab (Right)

    # Switch workspaces
    C("LC-RC-Left"):  C("RC-LSuper-Left"),
    C("LC-RC-Right"): C("RC-LSuper-Right"),

    C("LC-Space"): [bind,C("Alt-Space")],      # keyboard input source switching
}, when = lambda ctx:
      cnfg.screen_has_focus and
      matchProps(clas=termStr)(ctx)
)

keymap("User overrides general", {
    C("RC-Space"):    [bind,C("Alt-f1")],      # launcher
    C("Super-Space"): [bind,C("Alt-Space")],   # keyboard input source switching
}, when = lambda ctx:
      cnfg.screen_has_focus and
      matchProps(not_clas=remoteStr)(ctx)
)

###  SLICE_MARK_END: user_apps  ###  EDITS OUTSIDE THESE MARKS WILL BE LOST ON UPGRADE
