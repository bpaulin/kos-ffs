CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.
until not hasnode { remove nextnode. }.
switch to archive.

run once lib_message.
run once lib_math.
run once lib_io.
run once lib_utils.

set verbose to verboseDebug.

local stageMaxAscent is 2.
local stageMinCircularize is 4.
local stageMinTransfer is 2.
local stageMaxDescent is 0.

local altitudeWanted is 75.
local altitudeReEnter is 45.

local maxReenterWarp is 3.

local missionGoal is body("Mun").

set steeringmanager:pitchts to 5.
set steeringmanager:yawts to 5.

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
    setNextStep("transfer").
  }
  else {
    errorMessage("Failed").
    run exe_descent(stageMaxDescent,3).
  }
}

////////////////////////////////////////////////////////////////////////////////
// orbit -> transfer
////////////////////////////////////////////////////////////////////////////////
if nextStep="transfer" {
  dropStageTo(stageMinTransfer).
  wait 1.

  missionMessage("Transfer to " + missionGoal:name).
  run exe_transfer(missionGoal).

  setNextStep("encounter").
}

////////////////////////////////////////////////////////////////////////////////
// transfer -> encounter
////////////////////////////////////////////////////////////////////////////////
if nextStep="encounter" {
  missionMessage("Waiting for " + missionGoal:name + " encounter").
  warpto(time:seconds + ship:orbit:nextpatcheta).
  wait until ship:body=missionGoal.
  wait 2.
  setNextStep("escape").
}

////////////////////////////////////////////////////////////////////////////////
// encounter -> escape
////////////////////////////////////////////////////////////////////////////////
if nextStep="escape" {
  missionMessage("Waiting for " + missionGoal:name + " escape").
  // warpto(time:seconds + eta:periapsis - 15).
  // wait eta:periapsis - 15.
  // missionMessage("near mun, start again in 30s").
  // wait 30.
  // missionMessage("let's go back").
  warpto(time:seconds + ship:orbit:nextpatcheta).
  wait until ship:body=Kerbin.
  wait 2.
  setNextStep("return").
}

////////////////////////////////////////////////////////////////////////////////
// escape -> return
////////////////////////////////////////////////////////////////////////////////
if nextStep="return" {
  missionMessage("Decrease velocity").
  run exe_return(altitudeWanted,altitudeReEnter,stageDeltaV()).

  missionMessage("Descent").
  run exe_descent(stageMaxDescent, maxReenterWarp).

  missionMessage(ship:status).
  set nextStep to "done".
  setNextStep("done").
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
