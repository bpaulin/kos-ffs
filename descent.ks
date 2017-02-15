declare parameter maxStage.

run once lib_message.

sas off.

detailMessage("Descent", "Stage to #" + maxStage).
until stage:number = maxStage {
  stage.
}

set warp to 3.
wait until altitude<body:atm:height.
set warp to 3.

lock steering to retrograde.

detailMessage("Descent", "Prepare Chutes.").
when (not chutessafe) then {
  chutessafe on.
  unlock steering.
  return (not chutes).
}

wait until ship:status="landed" or ship:status="splashed".
