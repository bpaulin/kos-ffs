CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
switch to archive.

run once lib_message.

set verbose to 1.

local stageMaxAscent is 2.
local stageMinCircularize is 2.
local stageMaxDescent is 0.

local altitudeWanted is 75.
local altitudeReEnter is 25.

local maxReenterWarp is 3.

if ship:status = "prelaunch" {
  missionMessage("Launch!").
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  missionMessage("Ascent.").
  run ascent(altitudeWanted, stageMaxAscent).

  wait 1.
  until stage:number=stageMinCircularize {
    stage.
  }

  if apoapsis>body:atm:height {
    wait until altitude>body:atm:height.
    missionMessage("Circularize.").
    run Circularize.
  }
  if (ship:status = "orbiting") {
    missionMessage("Success").
  }
  else {
    errorMessage("Failed").
    run descent(stageMaxDescent).
  }
}

if (ship:status = "orbiting") {
  missionMessage("Re-enter").
  run reenter(altitudeReEnter,stageMaxDescent,maxReenterWarp).
}

if (ship:status="landed" or ship:status="splashed") {
  missionMessage("Landed").
}

sas on.
set pilotmainthrottle to 0.
