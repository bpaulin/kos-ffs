declare parameter wantedPeriapsisKm.
declare parameter maxStage.

run once lib_ui.

set wantedPeriapsis to wantedPeriapsisKm*1000.

if periapsis>wantedPeriapsis {
  run node_peri(wantedPeriapsis).
  run node.
}
uiBanner("Mission", "Descent.").
run descent(maxStage).
