////////////////////////////////////////////////////////////////////////////////
// launch to orbit
//
// It will raise apoapsis and circularize.
////////////////////////////////////////////////////////////////////////////////
declare parameter wantedApoapsisKm. // wanted apoapsis, in km
declare parameter stageMaxAscent. // max stage to use for ascent
declare parameter stageMinCircularize. // min stage to begin circularize

run once lib_message.

detailMessage("Launch to orbit", "raise apoapsis").
run launch_ascent(wantedApoapsisKm, stageMaxAscent).

if stage:number>stageMinCircularize {
  detailMessage("Launch to orbit", "drop stages").
  run stageTo(stageMinCircularize).
}

detailMessage("Launch to orbit", "circularize").
run Circularize.
