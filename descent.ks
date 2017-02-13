declare parameter maxStage.

run once lib_ui.

sas off.

uiBanner("Mission", "Stage to #" + maxStage).
until stage:number = maxStage {
  stage.
}

set warp to 3.
wait until altitude<body:atm:height.
set warp to 0.

lock steering to retrograde.

uiBanner("Mission", "Prepare Chutes.").
when (not chutessafe) then {
  chutessafe on.
  unlock steering.
  return (not chutes).
}

wait until ship:status="landed" or ship:status="splashed".
