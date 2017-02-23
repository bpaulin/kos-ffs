declare parameter wantedAltitudeKm.
set wantedAltitude to wantedAltitudeKm*1000.

run node_circularize.
run exe_node.
run node_peri(wantedAltitude).
run exe_node.
run node_circularize.
run exe_node.
