function getNextStep {
  if exists("1:/step.json") {
    local l is readjson("1:/step.json").
    return l["nextStep"].
  }
  return "prelaunch".
}

function setNextStep {
  parameter nextStep.
  set l to lexicon().
  l:add("nextStep", nextStep).
  writejson(l, "1:/step.json").
}
