// switch to archive.
if ship:status = "prelaunch" {
  runpath("0:/ksc/deploy").
}
run init.

set verbose to verboseDebug.

local stageMaxAscent is 4.
local stageMinCircularize is 6.
local stageMinTransfer is 3.

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
  run exe_orbit(
    80, // lko
    6 // stop staging here
  ).

  if (ship:status = "orbiting") {
    missionMessage("In orbit!").
    panels on.
    setNextMissionStep("transfer").
  }
  else {
    errorMessage("Failed, periapsis: "+periapsis).
    run exe_descent(
      0, // this stage will go down
      3 // warp
    ).
  }
}

////////////////////////////////////////////////////////////////////////////////
// orbit -> transfer
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="transfer" {
  missionMessage("Transfer to " + missionGoal:name).
  dropStageTo(
    4 // stage for transfer
  ).
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
  run exe_catch(
    10 // orbit 10km above the mun.
  ).
  setNextMissionStep("land").
}

////////////////////////////////////////////////////////////////////////////////
// orbit -> land
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="land" {
  dropStageTo(
    2 // landing stage
  ).
  run exe_land.
  setNextMissionStep("liftoff").
}

////////////////////////////////////////////////////////////////////////////////
// land -> liftoff
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="liftoff" {
  pauseMessage("").
  run exe_orbit(
    10, // orbit 10km above the mun.
    2 // don't stage
  ).
  setNextMissionStep("return").
}

////////////////////////////////////////////////////////////////////////////////
// liftoff -> return
////////////////////////////////////////////////////////////////////////////////
if nextMissionStep="return" {
  missionMessage("Return from " + missionGoal:name).
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
  run exe_return(
    80, //min parking
    35 // reenter altitude
  ).

  missionMessage("Descent").
  run exe_descent(
    0, // landing stage
    3 // warp
  ).

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
