declare parameter TgtInc.

run once lib_message.

// using normal of our orbital velocity vector
local ship_orbit_normal is vcrs(ship:velocity:orbit,ship:position-ship:body:position).
// and the same vector for our target
local target_orbit_normal is vcrs(TgtInc:velocity:orbit,TgtInc:position-ship:body:position).
// cross product gives us the line where AN and DN are
local lineofnodes is vcrs(ship_orbit_normal,target_orbit_normal).

// we can find angles between this line and our position
local angle_to_node is vang(ship:position-ship:body:position,lineofnodes).
local angle_to_opposite_node is vang(ship:position-ship:body:position,-1*lineofnodes).
detailMessage("Match Inclination",
  "nodes are at " + round(angle_to_node,1) + "° and " +
  round(angle_to_opposite_node,1) + "°"
).

// angular velocity
local ship_orbital_angular_vel is (ship:velocity:orbit:mag / (body:radius+ship:altitude))  * (180/constant():pi).
detailMessage("Match Inclination",
  "Angular velocity is " + round(ship_orbital_angular_vel,2) + "°/s"
).

// time til node
local time_to_node is angle_to_node / ship_orbital_angular_vel.
detailMessage("Match Inclination",
  "Node is " + round(time_to_node,0) + "s away"
).
local AngleIfFutur is vang(positionat(ship, time:seconds + time_to_node)-ship:body:position,lineofnodes).
local AngleIfPast is vang(positionat(ship, time:seconds - time_to_node)-ship:body:position,lineofnodes).
local IsFutur is (abs(90-AngleIfFutur)>abs(90-AngleIfPast)).
if not IsFutur {
  set time_to_node to SHIP:OBT:PERIOD - time_to_node.
}
detailMessage("Match Inclination",
  "Node Eta is " + round(time_to_node,0) + "s "
).

// time til opposite node
local time_to_opposite_node is angle_to_opposite_node / ship_orbital_angular_vel.
detailMessage("Match Inclination",
  "Opposite node is " + round(time_to_opposite_node,0) + "s away"
).
local AngleIfFutur is vang(positionat(ship, time:seconds + time_to_opposite_node)-ship:body:position,lineofnodes).
local AngleIfPast is vang(positionat(ship, time:seconds - time_to_opposite_node)-ship:body:position,lineofnodes).
local IsFutur is (abs(90-AngleIfFutur)>abs(90-AngleIfPast)).
if not IsFutur {
  set time_to_opposite_node to SHIP:OBT:PERIOD - time_to_opposite_node.
}
detailMessage("Match Inclination",
  "Opposite node Eta is " + round(time_to_opposite_node,0) + "s "
).

// time to next node
local time_to_node is min(time_to_node, time_to_opposite_node).

// deltaV
local relative_inclination is vang(ship_orbit_normal,target_orbit_normal).
detailMessage("Match Inclination",
  "dI is " + round(relative_inclination,2) + "°"
).
local dv is 2 * velocityat(ship, time:seconds + time_to_node):orbit:mag * sin(relative_inclination / 2).
detailMessage("Match Inclination",
  "dV is " + round(dv) + "°"
).

// place node.
local nodeInc is node(time:seconds+time_to_node,0,dv,0).
add nodeInc.

// up or down?
if abs(nodeInc:orbit:inclination - TgtInc:orbit:inclination)>abs(orbit:inclination - TgtInc:orbit:inclination) {
  remove nodeInc.
  local nodeInc is node(time:seconds+time_to_node,0,-dv,0).
  add nodeInc.
}
