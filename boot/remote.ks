CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

if ship:status = "prelaunch" {
  runpath("0:/ksc/deploy", true, false).
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
