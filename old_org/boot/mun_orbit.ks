// switch to archive.
if ship:status = "prelaunch" {
  runpath("0:/ksc/deploy").
}
run init.

set verbose to verboseDebug.

local stageMaxAscent is 2.
local stageMinCircularize is 4.
local stageMinTransfer is 2.

local altitudeWanted is 80.
local altitudeReEnter is 30.

local stageMaxDescent is 0.
local maxReenterWarp is 3.

local missionGoal is body("Mun").

set steeringmanager:pitchts to 10.
set steeringmanager:yawts to 10.

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
    errorMessage("Failed, periapsis: "+periapsis).
    run exe_descent(stageMaxDescent,3).
  }
}

////////////////////////////////////////////////////////////////////////////////
// orbit -> transfer
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="transfer" {
  missionMessage("Transfer to " + missionGoal:name).
  // stopMessage("").
  dropStageTo(stageMinTransfer).
  wait 1.

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
  setNextMissionStep("orbit").
}

////////////////////////////////////////////////////////////////////////////////
// encounter -> orbit
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="orbit" {
  missionMessage("Orbiting around " + missionGoal:name).
  run node_circularize.
  run exe_node.
  // run node_peri(25000).
  // run exe_node.
  // run node_circularize.
  // run exe_node.
  setNextMissionStep("return").
}

////////////////////////////////////////////////////////////////////////////////
// orbit -> return
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="return" {
  missionMessage("Return from " + missionGoal:name).
  // stopMessage("").
  run node_return_from_moon.
  run exe_node.

  warpto(time:seconds + ship:orbit:nextpatcheta).
  wait until ship:body=Kerbin.
  wait 2.
  setNextMissionStep("reenter").
}

////////////////////////////////////////////////////////////////////////////////
// return -> reenter
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="reenter" {
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
