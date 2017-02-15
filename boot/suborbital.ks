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

run once lib_message.

if ship:status = "prelaunch" {
  missionMessage("Launch!").
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  missionMessage("Ascent.").
  run ascent(80,1).

  missionMessage("Waiting for apoapsis.").
  wait until verticalspeed<0.

  missionMessage("Descent.").
  run descent(0).

  missionMessage("Success!").
}
