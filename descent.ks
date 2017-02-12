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
  return (not chutes).
}
