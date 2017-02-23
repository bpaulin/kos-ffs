////////////////////////////////////////////////////////////////////////////////
// Return
//
// This script should be called when orbit is eliptic.
// It will use available deltaV to decrease apoapsis as close as possible to
// the required altitude, leaving just enough to then lower the periapsis.
////////////////////////////////////////////////////////////////////////////////
parameter apoParking. // minimum apoapsis, in km
parameter periEnter. // re enter periapsis, in km
parameter availableDv is 0. // available delatV to use, in m/s

run once lib_math.
run once lib_message.

if periapsis<(body:atm:height+10000) {
  run node_peri_delay(80,30).
  run exe_node.
}

if availableDv = 0 {
  set availableDv to stageDeltaV().
}

local dv1 is 0.
local dv2 is 0.
////////////////////////////////////////////////////////////////////////////////
// Find min/max apoapsis we can reach.
////////////////////////////////////////////////////////////////////////////////
local minParking is apoParking.
local maxParking is minParking.
local foundMax is false.
until foundMax {
  // to set apoapsis to apoParking
  set dv1 to dVtoChangeApoapsisAtPeriapsis(
    ship:body,
    ship:orbit:periapsis,
    ship:orbit:apoapsis,
    maxParking*1000
  ).

  //to reenter
  set dv2 to dVtoChangePeriapsisAtApoapsis(
    ship:body,
    ship:orbit:periapsis,
    maxParking*1000,
    periEnter*1000
  ).

  if (abs(dv1)+abs(dv2)<=availableDv) {
    set foundMax to true.
  }
  else {
    set minParking to maxParking.
    set maxParking to maxParking*2.
  }
}
debugMessage("apoapsis is between " + minParking + " and " + maxParking).

////////////////////////////////////////////////////////////////////////////////
// Binary search to find apoapsis
////////////////////////////////////////////////////////////////////////////////
until abs(maxParking-minParking)<1 {
  local meanParking is (minParking+maxParking)/2.

  // to set apoapsis to apoParking
  set dv1 to dVtoChangeApoapsisAtPeriapsis(
    ship:body,
    ship:orbit:periapsis,
    ship:orbit:apoapsis,
    meanParking*1000
  ).

  //to reenter
  set dv2 to dVtoChangePeriapsisAtApoapsis(
    ship:body,
    ship:orbit:periapsis,
    meanParking*1000,
    periEnter*1000
  ).

  if (abs(dv1)+abs(dv2)<availableDv) {
    set maxParking to meanParking.
  }
  else {
    set minParking to meanParking.
  }
}

////////////////////////////////////////////////////////////////////////////////
// Find velocity at periapsis
////////////////////////////////////////////////////////////////////////////////
local Vperi is orbitVelocityAt(
  ship:body,
  periEnter*1000,
  maxParking*1000,
  periEnter*1000
).

debugMessage("apoapsis: " + round(maxParking) + " km").
debugMessage("deltaV to decrease apoapsis: " + round(dv1) + " m/s").
debugMessage("deltaV to reenter: " + round(dv2) + " m/s").
debugMessage("velocity at periapsis is " + round(Vperi) + " m/s").

////////////////////////////////////////////////////////////////////////////////
// execute nodes
// @todo abort if velocity is too high
////////////////////////////////////////////////////////////////////////////////
local nd1 is node(time:seconds + eta:periapsis, 0, 0, dv1).
add nd1.
run exe_node.
local nd2 is node(time:seconds + min(eta:apoapsis, eta:periapsis), 0, 0, dv2).
add nd2.
run exe_node.
