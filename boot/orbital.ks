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

run once lib_ui.

if ship:status = "prelaunch" {
  uiBanner("Mission", "Launch!").
  stage.
  wait 2.
}

if (ship:status = "flying" or ship:status = "sub_orbital") {
  uiBanner("Mission", "Ascent.").
  run ascent(80,2).
  
  wait 1.
  until stage:number=2 {
    stage.
  }

  set failed to false.
  if apoapsis>body:atm:height {
    uiBanner("Mission", "Circularize.").
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
    uiBanner("Mission", "failed, re-enter.").
    run reenter(45,0).
  }
  else {
    uiBanner("Mission", "Success!").
  }

}
set pilotmainthrottle to 0.
