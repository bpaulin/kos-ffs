////////////////////////////////////////////////////////////////////////////////
// ascent
//
// Raise apoapsis, staging til maxStage
////////////////////////////////////////////////////////////////////////////////
declare parameter wantedApoapsisKm is 0. // wanted apoapsis, in km
declare parameter maxStage is 0. // max stage

run once lib_utils.

set wantedApoapsis to wantedApoapsisKm*1000.
if wantedApoapsis=0 {
  set wantedApoapsis to body:atm:height + 10000.
}

sas off.
////////////////////////////////////////////////////////////////////////////////
// Vertical ascent
////////////////////////////////////////////////////////////////////////////////
lock throttle to 1.
detailMessage("Ascent", "Vertical ascent").
lock steering to heading(90,90).
local beginTurn is 10.
if body:atm:exists {
  set beginTurn to 80.
}
wait until verticalspeed>=beginTurn.
local beginTurnA is altitude.

////////////////////////////////////////////////////////////////////////////////
// Ascent loop
////////////////////////////////////////////////////////////////////////////////
detailMessage("Ascent", "Gravity turn").
if body:atm:exists {
  lock pitch to sqrt((90^2)*(altitude-beginTurnA)/body:atm:height).
}
else {
  lock pitch to 45.
}
lock steering to heading(90,90-pitch).
until apoapsis>=wantedApoapsis{
  burnStaging(maxStage).
  wait 0.2.
}
lock throttle to 0.
lock steering to heading(90,0).
detailMessage("Ascent", "Apoapsis ok: "+round(apoapsis)).

////////////////////////////////////////////////////////////////////////////////
// Waiting for out of atm, if any
////////////////////////////////////////////////////////////////////////////////
if apoapsis>body:atm:height {
  wait until altitude>body:atm:height.
  detailMessage("Ascent", "out of atm").
  FOR module IN SHIP:MODULESNAMED("ModuleProceduralFairing") {
    module:DOEVENT("deploy").
  }
  panels on.
}
sas on.
