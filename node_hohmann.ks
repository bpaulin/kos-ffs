declare parameter transferTo.

run once lib_message.

////////////////////////////////////////////////////////////////////////////////
// Checking
////////////////////////////////////////////////////////////////////////////////
local canDoTransfer is true.
function abortTransfer {
  parameter msg.
  warningMessage(msg).
  set canDoTransfer to false.
}

if body <> transferTo:body {
  abortTransfer("Incompatible orbits").
}
if ship:obt:eccentricity > 0.1 {
  abortTransfer("Eccentric ship " + round(ship:obt:eccentricity, 2) + ">0.1").
}
if transferTo:obt:eccentricity > 0.1 {
  abortTransfer("Eccentric ship " + round(transferTo:obt:eccentricity, 2) + ">0.1").
}
set transferToInclination to obt:inclination - transferTo:obt:inclination.
if abs(transferToInclination) > 0.2 {
  abortTransfer("transferTo Inclination " + round(transferToInclination, 2) + ">0.2").
}

if canDoTransfer {
  //////////////////////////////////////////////////////////////////////////////
  // orbit radius
  //////////////////////////////////////////////////////////////////////////////
  local r1 is ship:obt:semimajoraxis.
  local r2 is transferTo:obt:semimajoraxis - transferTo:soiradius/3.

  //////////////////////////////////////////////////////////////////////////////
  // deltaV
  //////////////////////////////////////////////////////////////////////////////
  local dV is sqrt(body:mu / r1) * (sqrt( (2*r2) / (r1+r2) ) - 1).

  //////////////////////////////////////////////////////////////////////////////
  // Phase angle
  //////////////////////////////////////////////////////////////////////////////
  // dv is not a vector in cartesian space, but rather in "maneuver space"
  // (z = prograde/retrograde dv)
  // local dv is V(0, 0, dV).
  local pt is 0.5 * ((r1+r2) / (2*r2))^1.5.
  local ft is pt - floor(pt).
  // angular distance that transferTo will travel during transfer
  local theta is 360 * ft.
  // necessary phase angle for vessel burn
  local phi is 180 - theta.

  //////////////////////////////////////////////////////////////////////////////
  // Timing
  //////////////////////////////////////////////////////////////////////////////
  function synodicPeriod {
    parameter o1, o2.

    if o1:period > o2:period {
      local o is o2.
      set o2 to o1.
      set o1 to o.
    }

    return 1 / ( (1 / o1:period) - (1 / o2:period) ).
  }
  // minimum Timing @todo way to far
  local minimum is Time:seconds + synodicPeriod(ship:obt, transferTo:obt).
  // local minimum is Time:seconds.
  local shipPosition is positionat(ship, minimum) - body:position.
  local transferToPosition is positionat(transferTo, minimum) - body:position.
  // current phase angle
  local phiT is vang(shipPosition, transferToPosition).
  local VptY is vcrs(shipPosition, transferToPosition):y.
  // local phiT is vang(ship:obt:position - body:position, transferTo:obt:position - body:position).
  // local VptY is vcrs(ship:obt:position - body:position, transferTo:obt:position - body:position):y.
  if VptY>0 {
    set phiT to 360 - phiT.
  }
  // angle/s
  local angT is 360 / transferTo:obt:period.
  local angS is 360 / ship:obt:period.
  local gain is angT-angS.
  local dT is (phi-phiT)/gain.


  //////////////////////////////////////////////////////////////////////////////
  // Node creation
  //////////////////////////////////////////////////////////////////////////////
  local nd is node(minimum + dT, 0, 0, dV).
  add nd.
}
