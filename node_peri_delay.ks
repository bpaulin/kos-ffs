// wanted periapsis, in km
declare parameter wantedPeriapsisKm.
// wanted delay before node, in s
declare parameter delay.

run once lib_message.

local wantedPeriapsis is wantedPeriapsisKm*1000.
local raising is (periapsis<wantedPeriapsis).
local burnDirection is 0.
if (raising) {
  set burnDirection to 1.
}
else {
  set burnDirection to -1.
}

//
// Create node
//
local nd is node(time:seconds + delay, 0, 0, 0).
add nd.

//
// Find min/max dv
//
local minDV is 0.
local maxDV is 0.25.
until (nd:orbit:periapsis>wantedPeriapsis and raising)
or (nd:orbit:periapsis<wantedPeriapsis and not raising) {
  set minDv to maxDv.
  set maxDv to maxDv*2.
  set nd:prograde to burnDirection*maxDv.
  debugMessage("min:"+minDV+", max:"+maxDV).
}

//
// Binary search
//
until maxDV-minDV<0.01 {
    set meanDV to (maxDV+minDV)/2.
    set nd:prograde to burnDirection*meanDV.
    if ((nd:orbit:periapsis>wantedPeriapsis and raising)
    or (nd:orbit:periapsis<wantedPeriapsis and not raising)) {
      set maxDV to meanDV.
    }
    else {
      set minDV to meanDV.
    }
    debugMessage("mean:"+meanDV).
}

//
// Set right dV
//
set meanDV to (maxDV+minDV)/2.
set nd:prograde to burnDirection*meanDV.
