declare parameter wantedPeriapsisKm.
declare parameter maxStage.

run once lib_message.

set wantedPeriapsis to wantedPeriapsisKm*1000.

if periapsis>wantedPeriapsis {
  run node_peri(wantedPeriapsis).
  run node.
}
detailMessage("Re-enter", "Descent.").
run descent(maxStage).
