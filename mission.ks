run once lib_ui.

if ship:status = "prelaunch" {
  uiBanner("Mission", "Launch!").
  stage.
  wait 1.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  uiBanner("Mission", "Begin.").
}
