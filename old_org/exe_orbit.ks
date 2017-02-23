////////////////////////////////////////////////////////////////////////////////
// launch to orbit
//
// Raise apoapsis and circularize.
////////////////////////////////////////////////////////////////////////////////
declare parameter wantedApoapsisKm. // wanted apoapsis, in km
declare parameter stageMaxAscent. // max stage to use for ascent
declare parameter stageMinCircularize is -1. // min stage to begin circularize

run once lib_message.
run once lib_utils.

detailMessage("Launch to orbit", "ascent").
run exe_ascent(wantedApoapsisKm, stageMaxAscent).

if stageMinCircularize>0 and stage:number>stageMinCircularize {
  detailMessage("Launch to orbit", "drop stages to circularize").
  dropStageTo(stageMinCircularize).
}

detailMessage("Launch to orbit", "circularize").

run node_circularize.
run exe_node.

detailMessage(
  "Circularized",
  "e:" + round(ship:obt:eccentricity, 3)
  + ", i:" + round(ship:obt:inclination, 3)
).
