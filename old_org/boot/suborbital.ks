switch to archive.
// if ship:status = "prelaunch" {
//   runpath("0:/ksc/deploy").
// }
run init.

local stageMaxAscent is 1.
local stageMaxDescent is 0.
local altitudeWanted is 75.

missionMessage("Launch!").
stage.
wait 2.

missionMessage("Ascent.").
run exe_ascent(altitudeWanted,stageMaxAscent).

missionMessage("Waiting for apoapsis.").
wait until verticalspeed<0.
missionMessage("Descent.").

run exe_descent(stageMaxDescent).
missionMessage("Success!").

sas on.
set pilotmainthrottle to 0.
