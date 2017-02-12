run once lib_ui.

if ship:status = "prelaunch" {
  uiBanner("Mission", "Launch!").
  sas on.
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  uiBanner("Mission", "Ascent.").
  run ascent(75,1).

  uiBanner("Mission", "Waiting for apoapsis.").
  wait until verticalspeed<0.

  uiBanner("Mission", "Descent.").
  run descent(0).

  wait until ship:status="landed" or ship:status="splashed".
  uiBanner("Mission", "Success!").
}
