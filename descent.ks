declare parameter maxStage.

run once lib_ui.

sas off.

uiBanner("Mission", "Stage to #" + maxStage).
until stage:number = maxStage {
  stage.
}

lock steering to retrograde.

uiBanner("Mission", "Prepare Chutes.").
when (not chutessafe) then {
  chutessafe on.
  unlock steering.
  return (not chutes).
}

wait until ship:status="landed" or ship:status="splashed".
