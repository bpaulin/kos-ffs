CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

if ship:status = "prelaunch" {
  switch to archive.

  list files in scripts.
  for file in scripts {
    if file:name:endswith(".ks") {
      copypath(file, core:volume).
    }
  }

  switch to core:volume.
  wait 2.
  sas on.
}

run once lib_message.

if ship:status = "prelaunch" {
  missionMessage("Launch!").
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  missionMessage("Ascent.").
  run ascent(80,2).

  wait 1.
  // until stage:number=2 {
  //   stage.
  // }

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
  else {
    missionMessage("Success!").
  }

}
set pilotmainthrottle to 0.
