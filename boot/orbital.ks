switch to archive.
// if ship:status = "prelaunch" {
//   runpath("0:/ksc/deploy").
// }

local stageMaxAscent is 2.
local stageMinCircularize is 4.
local stageMaxDescent is 0.
local altitudeWanted is 75.

local nextStep is getNextStep().

////////////////////////////////////////////////////////////////////////////////
// Prelaunch -> orbit
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="prelaunch" {
  missionMessage("Launch!").
  stage.
  wait 1.

  missionMessage("Orbiting").
  run exe_orbit(altitudeWanted, stageMaxAscent, stageMinCircularize).

  if (ship:status = "orbiting") {
    missionMessage("In orbit!").
    panels on.
    setNextMissionStep("done").
  }
  else {
    errorMessage("Failed").
    run exe_descent(stageMaxDescent,3).
  }
}

////////////////////////////////////////////////////////////////////////////////
// reboot
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep<>"done" {
  wait 5.
  reboot.
}

sas on.
set pilotmainthrottle to 0.
