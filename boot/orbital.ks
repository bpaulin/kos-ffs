CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.
switch to archive.

run once lib_message.
set verbose to verboseDebug.

local stageMaxAscent is 2.
local stageMinCircularize is 4.
local stageMaxDescent is 0.
local altitudeWanted is 75.

if ship:status = "prelaunch" {
  missionMessage("Launch!").
  set steeringmanager:pitchts to 5.
  set steeringmanager:yawts to 5.
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  missionMessage("Orbiting").
  run launch_orbit(altitudeWanted, stageMaxAscent, stageMinCircularize).

  if (ship:status = "orbiting") {
    missionMessage("In orbit!").
  }
  else {
    errorMessage("Failed").
    run descent(stageMaxDescent,3).
  }
}

set pilotmainthrottle to 0.
