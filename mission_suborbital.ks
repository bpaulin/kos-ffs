run once lib_ui.

if ship:status = "prelaunch" {
  uiBanner("Mission", "Launch!").
  sas on.
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  set wantedApoapsis to 75000.

  uiBanner("Mission", "Ascent.").
  sas off.
  lock steering to HEADING(90,75).
  wait 3.
  unlock steering.
  sas on.
  until apoapsis>wantedApoapsis or verticalspeed<0 {
    lock throttle to 1.
  }

  lock throttle to 0.
  uiBanner("Mission", "Waiting for apoapsis.").

  wait until verticalspeed<0.
  uiBanner("Mission", "Descent.").

  uiBanner("Mission", "Stage to #0").
  until stage:number = 0 {
    stage.
  }

  uiBanner("Mission", "Prepare Chutes.").
  when (not chutessafe) then {
    chutessafe on.
    return (not chutes).
  }

  wait until ship:status="landed" or ship:status="splashed".
  uiBanner("Mission", "Success!").
}
