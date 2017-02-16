CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.
switch to archive.

run once lib_message.
run once lib_math.
run once lib_io.
run once lib_utils.

set verbose to verboseDebug.

local stageMaxAscent is 2.
local stageMinCircularize is 4.
local stageMaxDescent is 0.
local altitudeWanted is 75.

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
    setNextStep("done").
  }
  else {
    errorMessage("Failed").
    run exe_descent(stageMaxDescent,3).
  }
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
