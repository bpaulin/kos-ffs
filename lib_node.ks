function circularizeAt{
  parameter wantedAltitude.
  print wantedAltitude.
  // set wantedAltitude to wantedAltitude*1000.
  local margin is 500.

  local periTooHigh is (periapsis>(wantedAltitude+margin)).

  if orbit:apoapsis<(wantedAltitude-margin){
    run node_apo(wantedAltitude).
    run exe_node.
  }

  if periTooHigh {
    if orbit:apoapsis<(wantedAltitude-margin){
      run node_apo(wantedAltitude).
      run exe_node.
    }
  }
  else {
    if orbit:periapsis<(wantedAltitude-margin){
      run node_peri(wantedAltitude).
      run exe_node.
    }
  }
}


function nodesTransferHohman {
  parameter transferTo.

  local r1 is ship:orbit:semiMajorAxis.
  local r2 is transferTo:orbit:semiMajorAxis.
  local dV is sqrt(body:mu / r1) * (sqrt( (2*r2) / (r1+r2) ) - 1).

  local pt is 0.5 * ((r1+r2) / (2*r2))^1.5.
  local ft is pt - floor(pt).
  // angular distance that transferTo will travel during transfer
  local theta is 360 * ft.
  // necessary phase angle for vessel burn
  local alpha is 180 - theta.

  if alpha<0 { set alpha to 360 + alpha. }
  print "phase angle: " + alpha.

  local currentAlpha is vang(ship:position-body:position, transferTo:position-body:position).
  local VptY is vcrs(ship:position-body:position, transferTo:position-body:position):y.
  if VptY>0 {
    set currentAlpha to 360 - currentAlpha.
  }
  print "current angle: " + currentAlpha.

  local angT is 360 / transferTo:obt:period.
  local angS is 360 / ship:obt:period.
  local gain is angT-angS.
  // if gain<0 { set gain to 360 + gain. }
  print "gain angle: " + gain.

  local delta is alpha-currentAlpha.
  // if delta<0 { set delta to 360 + delta. }
  // if gain<0 { set delta to -1* delta. }
  print "delta angle: " + delta.
  // print delta.

  local dT is delta/gain.
  // local dT is 10.
  print "eta: " + dT.


  local node1 is node(time:seconds+dt,0,0,dV).

  local dV is sqrt(body:mu / r2) * (1 - sqrt( (2*r1) / (r1+r2) )).
  local transfer_time to constant:pi * sqrt((((r1 + r2)^3)/(8*BODY:MU))).

  local node2 is node(time:seconds+dt+transfer_time,0,0,dV).

  return list(node1, node2).
}
