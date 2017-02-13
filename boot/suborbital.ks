CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

if ship:status = "prelaunch" {
  switch to archive.

  list files in scripts.
  for file in scripts {
    if file:name:endswith(".ks") {
      copypath(file, core:volume).
    }
  }

  switch to core:volume.
  wait 2.
  sas on.
}

run once lib_ui.

if ship:status = "prelaunch" {
  uiBanner("Mission", "Launch!").
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  uiBanner("Mission", "Ascent.").
  run ascent(80,1).

  uiBanner("Mission", "Waiting for apoapsis.").
  wait until verticalspeed<0.

  uiBanner("Mission", "Descent.").
  run descent(0).

  uiBanner("Mission", "Success!").
}
