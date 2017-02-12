declare parameter maxStage.

sas off.

uiBanner("Mission", "Stage to #" + maxStage).
until stage:number = maxStage {
  stage.
}

uiBanner("Mission", "Prepare Chutes.").
when (not chutessafe) then {
  chutessafe on.
  return (not chutes).
}
