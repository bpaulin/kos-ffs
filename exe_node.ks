////////////////////////////////////////////////////////////////////////////////
// next Node execution
// https://www.reddit.com/r/Kos/comments/4568p2/executing_maneuver_nodes_figuring_out_the_rocket/
// https://ksp-kos.github.io/KOS/tutorials/exenode.html
////////////////////////////////////////////////////////////////////////////////

run once lib_message.

set nd to nextnode.

if maxthrust=0 {
  detailMessage("Node", "failed: no thrust").
}
else {
  ////////////////////////////////////////////////////////////////////////////////
  // Duration math
  ////////////////////////////////////////////////////////////////////////////////
  set e to constant():e.
  set m0 to ship:mass.
  set dv to nd:deltav:mag.
  set eIsp to 0.
  list engines in my_engines.
  for eng in my_engines {
    set eIsp to eIsp + eng:maxthrust / maxthrust * eng:isp.
  }
  set surfaceGravity to kerbin:mu / kerbin:radius^2.
  set ve to eIsp * surfaceGravity.
  set mfr to ship:maxthrust/ve.

  set burn_duration to (m0 * (1 - 1/(e^(dv/ve)))) / mfr.
  set start_time TO time:seconds + nd:eta - burn_duration/2.
  set end_time TO time:seconds + nd:eta + burn_duration/2.

  detailMessage("Node", "eta:" + round(nd:eta) + ", dV: " + round(nd:deltav:mag) + ", dT: " + round(burn_duration)).

  ////////////////////////////////////////////////////////////////////////////////
  // Point at the the node
  ////////////////////////////////////////////////////////////////////////////////
  sas off.
  lock steering to nd:burnvector.
  wait until vang(ship:facing:vector, nd:burnvector) < 2.

  ////////////////////////////////////////////////////////////////////////////////
  // warp
  ////////////////////////////////////////////////////////////////////////////////
  set warpmode to "rails".
  detailMessage("Node", "begin warp").
  warpto(start_time - 30).

  ////////////////////////////////////////////////////////////////////////////////
  // Burn !!
  ////////////////////////////////////////////////////////////////////////////////
  wait until time:seconds >= start_time.
  local original is nd:deltaV.
  local lastMag is 10000.
  detailMessage("Node", "end warp").
  detailMessage("Node", "begin burn").
  until abs(nd:deltaV:mag)<0.1 or abs(nd:deltaV:mag)>abs(lastMag) {
    if nd:deltav:mag>0.1 {
      lock throttle to nd:deltav:mag/10.
    }
    else {
      lock throttle to 1.
    }
    set lastMag to nd:deltaV:mag.
    wait 0.1.
  }
  lock throttle to 0.
  detailMessage("Node", "end burn, error:"+round(nd:deltaV:mag,2)+"m/s").

  ////////////////////////////////////////////////////////////////////////////////
  // Clean
  ////////////////////////////////////////////////////////////////////////////////
  remove nd.
  unlock steering.
  set ship:control:pilotmainthrottle to 0.
  unlock throttle.
}
