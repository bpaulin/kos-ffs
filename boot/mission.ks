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
  wait 1.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  missionMessage("Begin.").
}
