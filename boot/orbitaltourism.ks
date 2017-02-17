switch to archive.
// if ship:status = "prelaunch" {
//   runpath("0:/ksc/deploy").
// }
run init.

local stageMaxAscent is 2.
local stageMinCircularize is 2.
local stageMaxDescent is 0.

local altitudeWanted is 75.
local altitudeReEnter is 25.

local maxReenterWarp is 3.

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
    setNextMissionStep("descent").
  }
  else {
    errorMessage("Failed").
    run exe_descent(stageMaxDescent,3).
    setNextMissionStep("done").
  }
}

////////////////////////////////////////////////////////////////////////////////
// orbit -> landing
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="descent" {
  missionMessage("Re-enter").
  run exe_reenter(altitudeReEnter,stageMaxDescent,maxReenterWarp).
  missionMessage(ship:status).
  setNextMissionStep("done").
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
