CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.
switch to archive.

run once lib_message.

set verbose to verboseDebug.

local stageMaxAscent is 2.
local stageMinCircularize is 4.
local stageMaxDescent is 0.
local stageMinTransfer is 2.

local altitudeWanted is 75.
local altitudeReEnter is 45.

local missionGoal is body("Mun").
local missionSuccess is false.

if ship:status = "prelaunch" {
  missionMessage("Launch!").
  set steeringmanager:pitchts to 5.
  set steeringmanager:yawts to 5.
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  missionMessage("Ascent.").
  run ascent(altitudeWanted, stageMaxAscent).

  wait 1.
  run stageTo(stageMinCircularize).

  missionMessage("Circularize.").
  run Circularize.

  if (ship:status = "orbiting") {
    missionMessage("In orbit!").
  }
  else {
    errorMessage("Failed").
    run descent(stageMaxDescent,3).
  }
}

if (ship:status = "orbiting" and ship:orbit:transition = "final") {
  run stageTo(stageMinTransfer).
  wait 1.

  missionMessage("Transfer to " + missionGoal:name).
  run transfer(missionGoal).
}

if (ship:orbit:transition = "encounter" and ship:orbit:nextpatch:body=missionGoal) {
  missionMessage("Waiting for " + missionGoal:name + " encounter").
  warpto(time:seconds + ship:orbit:nextpatcheta).
  wait until ship:body=missionGoal.
  wait 2.
}
else {
  errorMessage("Failed, no " + missionGoal:name + " encounter").
}

if (ship:orbit:transition = "escape" and ship:orbit:nextpatch:body=Kerbin) {
  missionMessage("Waiting for " + missionGoal:name + "escape").
  // warpto(time:seconds + eta:periapsis - 15).
  // wait eta:periapsis - 15.
  // missionMessage("near mun, start again in 30s").
  // wait 30.
  // missionMessage("let's go back").
  warpto(time:seconds + ship:orbit:nextpatcheta).
  wait until ship:body=Kerbin.
  wait 2.
  set missionSuccess to true.
}

if (ship:body = Kerbin and missionSuccess) {
  missionMessage("Re-enter").
  run node_peri_delay(altitudeReEnter,60).
  run node.
  set warp to 7.
  wait until altitude<ship:body:atm:height+40000.
  set warp to 0.
  missionMessage("Descent").
  run descent(stageMaxDescent).
  missionMessage(ship:status).
}

sas on.
set pilotmainthrottle to 0.
