// switch to archive.
if ship:status = "prelaunch" {
  runpath("0:/ksc/deploy").
}
run init.

set verbose to verboseDebug.

local stageMaxAscent is 2.
local stageMinCircularize is 4.
local stageMinTransfer is 2.
local stageMaxDescent is 0.

local altitudeWanted is 75.
local altitudeReEnter is 45.

local maxReenterWarp is 3.

local missionGoal is body("Mun").

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
    setNextMissionStep("transfer").
  }
  else {
    errorMessage("Failed").
    run exe_descent(stageMaxDescent,3).
  }
}

////////////////////////////////////////////////////////////////////////////////
// orbit -> transfer
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="transfer" {
  dropStageTo(stageMinTransfer).
  wait 1.

  missionMessage("Transfer to " + missionGoal:name).
  run exe_transfer(missionGoal).

  setNextMissionStep("encounter").
}

////////////////////////////////////////////////////////////////////////////////
// transfer -> encounter
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="encounter" {
  missionMessage("Waiting for " + missionGoal:name + " encounter").
  warpto(time:seconds + ship:orbit:nextpatcheta).
  wait until ship:body=missionGoal.
  wait 2.
  setNextMissionStep("escape").
}

////////////////////////////////////////////////////////////////////////////////
// encounter -> escape
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="escape" {
  missionMessage("Waiting for " + missionGoal:name + " escape").
  // warpto(time:seconds + eta:periapsis - 15).
  // wait eta:periapsis - 15.
  // missionMessage("near mun, start again in 30s").
  // wait 30.
  // missionMessage("let's go back").
  warpto(time:seconds + ship:orbit:nextpatcheta).
  wait until ship:body=Kerbin.
  wait 2.
  setNextMissionStep("return").
}

////////////////////////////////////////////////////////////////////////////////
// escape -> return
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="return" {
  missionMessage("Decrease velocity").
  run exe_return(altitudeWanted,altitudeReEnter,stageDeltaV()).

  missionMessage("Descent").
  run exe_descent(stageMaxDescent, maxReenterWarp).

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
