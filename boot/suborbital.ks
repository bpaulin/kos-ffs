CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.
switch to archive.

run once lib_message.
run once lib_math.
run once lib_io.
run once lib_utils.

local stageMaxAscent is 1.
local stageMaxDescent is 0.
local altitudeWanted is 75.

missionMessage("Launch!").
stage.
wait 2.

missionMessage("Ascent.").
run ascent(altitudeWanted,stageMaxAscent).

missionMessage("Waiting for apoapsis.").
wait until verticalspeed<0.
missionMessage("Descent.").

run descent(stageMaxDescent).
missionMessage("Success!").

sas on.
set pilotmainthrottle to 0.
