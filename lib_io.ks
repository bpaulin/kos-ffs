global nextMissionStep is "prelaunch".

if exists("1:/step.json") {
  local l is readjson("1:/step.json").
  set nextMissionStep to l["nextStep"].
}

function getNextMissionStep {
  return nextMissionStep.
}

function setNextMissionStep {
  parameter nextStep.
  set l to lexicon().
  l:add("nextStep", nextStep).
  writejson(l, "1:/step.json").
  set nextMissionStep to nextStep.
}
