run once lib_ui.

if ship:status = "prelaunch" {
  uiBanner("Mission", "Launch!").
  sas on.
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  uiBanner("Mission", "Ascent.").
  run ascent(80,1).

  if apoapsis>body:atm:height {
    uiBanner("Mission", "Circularize.").
    wait until altitude>body:atm:height.
    run Circularize.
  }
  wait 1.

  if periapsis<body:atm:height {
    uiBanner("Mission", "Descent.").
    run descent(0).
  } else {
  uiBanner("Mission", "Success!").
  }
}
