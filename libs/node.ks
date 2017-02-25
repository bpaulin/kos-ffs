{
  global node_lib is lex(
    "exec", node_exec@,
    "burn_time", node_time@
  ).

  function node_exec {
    parameter autowarp is false.

    if not hasnode return.

    local nd is nextnode.
    local v is nd:burnvector.

    sas off.
    lock steering to nd:burnvector.
    wait until vang(ship:facing:vector, nd:burnvector) < 2.

    local burn_duration is node_time(nd).
    local start_time is time:seconds + nd:eta - burn_duration/2.
    output("eta:" + round(nd:eta) + ", dV: " + round(nd:deltav:mag,2) + ", dT: " + round(burn_duration), true).
    wait until time:seconds >= start_time.
    local lastMag is 10000.
    local v is nd:burnvector.
    output("begin burn: " + round(nd:deltav:mag,2) + " m/s", true).
    until abs(nd:deltaV:mag)<0.1 or abs(nd:deltaV:mag)>(abs(lastMag)+0.1) or (vdot(nd:burnvector, v) < 0) {
      if nd:deltav:mag>0.1 {
        lock throttle to nd:deltav:mag/10.
      }
      else {
        lock throttle to 1.
      }
      set lastMag to nd:deltaV:mag.
      wait 0.01.
    }
    output("end burn, error:"+round(nd:deltaV:mag,2)+"m/s", true).

    lock throttle to 0.
    unlock steering.
    remove nd.
  }

  function node_time {
    parameter nd.

    local e to constant():e.
    local m0 to ship:mass.
    local dv to nd:deltav:mag.
    local eIsp to 0.
    list engines in my_engines.
    for eng in my_engines {
      set eIsp to eIsp + eng:maxthrust / maxthrust * eng:isp.
    }
    local surfaceGravity to kerbin:mu / kerbin:radius^2.
    local ve to eIsp * surfaceGravity.
    local mfr to ship:maxthrust/ve.

    return (m0 * (1 - 1/(e^(dv/ve)))) / mfr.
  }
}
