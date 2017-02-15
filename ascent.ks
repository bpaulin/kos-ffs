declare parameter wantedApoapsisKm.
declare parameter maxStage.

set wantedApoapsis to wantedApoapsisKm*1000.

global launch_gt0 is 0.
global launch_gt1 is 45000.

////////////////////////////////////////////////////////////////////////////////
// Auto-stage logic
////////////////////////////////////////////////////////////////////////////////
function ascentStaging {
  if stage:number > maxStage {
    if maxthrust = 0 {
      detailMessage("Ascent", "no thrust, stage #" + stage:number).
      stage.
    }
    SET numOut to 0.
    LIST ENGINES IN engines.
    FOR eng IN engines
    {
      IF eng:FLAMEOUT
      {
        SET numOut TO numOut + 1.
      }
    }
    if numOut > 0 {
      detailMessage("Ascent", "flameout, stage #" + stage:number).
      stage.
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
// Auto-throttle logic
////////////////////////////////////////////////////////////////////////////////
function ascentThrottle {
  return 1. // yes, kerbal way
}

////////////////////////////////////////////////////////////////////////////////
// Auto steering logic
////////////////////////////////////////////////////////////////////////////////
function ascentSteering {
  set gtPct to (altitude - launch_gt0) / (launch_gt1 - launch_gt0).
  if gtPct<0 {
    return heading(90,90).
  } else if gtPct>1 {
    return heading(90,10).
  }
  set pda to (cos(gtPct * 180) + 1) / 2.
  set theta to max(-80, 90 * ( pda - 1 )).
  return heading(90, theta+90).
}

////////////////////////////////////////////////////////////////////////////////
// Ascent loop
////////////////////////////////////////////////////////////////////////////////
sas off.
lock steering to ascentSteering().
lock throttle to ascentThrottle().
until apoapsis>wantedApoapsis{
  ascentStaging().
  wait 0.2.
}
detailMessage("Ascent", "apoapsis ok, release throttle").
lock throttle to 0.
if apoapsis>body:atm:height {
  wait until altitude>body:atm:height.
}
detailMessage("Ascent", "out of atm").
sas on.
