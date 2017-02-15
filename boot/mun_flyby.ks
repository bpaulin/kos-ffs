CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

switch to archive.

run once lib_message.

global missionGoal is body("Mun").

if ship:status = "prelaunch" {
  missionMessage("Launch!").
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  missionMessage("Ascent.").
  run ascent(80,4).

  set failed to false.
  if apoapsis>body:atm:height {
    missionMessage("Circularize.").
    wait until altitude>body:atm:height.
    run Circularize.
    if periapsis<body:atm:height {
      set failed to true.
    }
  }
  else {
    set failed to true.
  }

  if failed {
    missionMessage("failed, re-enter.").
    run reenter(45,0).
  }
}

if (ship:status = "orbiting") {

  until stage:number=2 {
    stage.
  }
  wait 2.
  // set target to missionGoal.
  // wait 2.

  run node_hohmann(missionGoal).
  run node.
  warpto(time:seconds + eta:transition +1).
  wait (eta:transition +10).
  warpto(time:seconds + eta:transition +1).
  wait (eta:transition +10).
  run node_peri_delay(30,60).
  wait until altitude<ship:body:atm:height.
  run descent(0).
  // warpto(time:seconds + eta:periapsis - 15).
  // wait 30.
  // warpto(time:seconds + eta:transition +1).
  // run node_peri_delay(60,60).
  // run node.
  // run node_apo(500000).
  // run node.
  // run reenter(45,0).
}


set pilotmainthrottle to 0.
