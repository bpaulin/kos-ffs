run once lib_ui.

// if obt:transition = "ESCAPE" or eta:periapsis < eta:apoapsis {
  // run node_apo(obt:periapsis).
// } else {
  run node_peri(obt:apoapsis).
// }

run node.

uiBanner("Circularized", "e:" + round(ship:obt:eccentricity, 3) + ", i:" + round(ship:obt:inclination, 3)).
