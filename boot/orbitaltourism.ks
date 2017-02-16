CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.
until not hasnode { remove nextnode. }.
switch to archive.

run once lib_message.
run once lib_math.
run once lib_io.
run once lib_utils.

local stageMaxAscent is 2.
local stageMinCircularize is 2.
local stageMaxDescent is 0.

local altitudeWanted is 75.
local altitudeReEnter is 25.

local maxReenterWarp is 3.

local nextStep is getNextStep().

////////////////////////////////////////////////////////////////////////////////
// Prelaunch -> orbit
////////////////////////////////////////////////////////////////////////////////
if nextstep="prelaunch" {
  missionMessage("Launch!").
  stage.
  wait 1.

  missionMessage("Orbiting").
  run exe_orbit(altitudeWanted, stageMaxAscent, stageMinCircularize).

  if (ship:status = "orbiting") {
    missionMessage("In orbit!").
    panels on.
    setNextStep("descent").
  }
  else {
    errorMessage("Failed").
    run exe_descent(stageMaxDescent,3).
    setNextStep("done").
  }
}

////////////////////////////////////////////////////////////////////////////////
// Prelaunch -> orbit
////////////////////////////////////////////////////////////////////////////////
if nextstep="descent" {
  missionMessage("Re-enter").
  run exe_reenter(altitudeReEnter,stageMaxDescent,maxReenterWarp).
  missionMessage(ship:status).
  setNextStep("done").
}

if (ship:status="landed" or ship:status="splashed") {
  missionMessage("Landed").
}

////////////////////////////////////////////////////////////////////////////////
// reboot
////////////////////////////////////////////////////////////////////////////////
if nextStep<>"done" {
  wait 5.
  reboot.
}

sas on.
set pilotmainthrottle to 0.
