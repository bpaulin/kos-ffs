////////////////////////////////////////////////////////////////////////////////
// Return from a moon
////////////////////////////////////////////////////////////////////////////////
// Perform a hohmann transfer to get back in kerbin SOI
//
// https://www.reddit.com/r/Kos/comments/3xihu7/automated_mun_science_return_probe/
// https://en.wikipedia.org/wiki/Specific_relative_angular_momentum
// https://en.wikipedia.org/wiki/Specific_orbital_energy
// https://en.wikipedia.org/wiki/Hohmann_transfer_orbit
//
// @todo: improve fine tuning, understand better timing, debug messages
////////////////////////////////////////////////////////////////////////////////
parameter target_periapsis is 75000.


// we are now where the mun is, that's our r1
local r1 to (BODY:OBT:SEMIMAJORAXIS).
// we want the r2 radius to be consistent with wanted periapsis
local r2 to (BODY:BODY:RADIUS + target_periapsis ).

// ô wikipedia, what's the dv for this change of radius?
local dv_hx_kerbin is BODY:OBT:VELOCITY:ORBIT:MAG * (sqrt((2*r2)/(r1 + r2))-1).

// ô wikipedia, how long will it take us?
local transfer_time to constant:pi * sqrt((((r1 + r2)^3)/(8*BODY:BODY:MU))).

// when we leave soi, we must be at dv_hx_kerbin m/s.
// with specific orbital energy (E = v²/2 - mu/r) wich is constant,
// we can find speed needed at current altitude
local r1 is SHIP:OBT:SEMIMAJORAXIS.
local r2 is BODY:SOIRADIUS.
local v2 is dv_hx_kerbin.
local mu to BODY:MU.
local ejection_vel is sqrt( (r1*(r2*v2^2 - 2 * mu) + 2*r2*mu ) / (r1*r2) ).

// as we are in mun orbit, we already have her velocity.
local delta_v to  abs(SHIP:OBT:VELOCITY:ORBIT:MAG-ejection_vel).

// let's add our precious velocity to our current velocity speed
local vel_vector is SHIP:VELOCITY:ORBIT:VEC.
set vel_vector:MAG to (vel_vector:MAG + delta_v).
//  and we keep our position vector
local ship_pos_orbit_vector is SHIP:Position - BODY:Position.
// these 2 vectors, with can have angular momentum magnitude
local angular_momentum_h is (vcrs(vel_vector,ship_pos_orbit_vector)):MAG.

//after burn, our energy will be:
local spec_energy is ((vel_vector:MAG^2)/2) - (BODY:MU/SHIP:OBT:SEMIMAJORAXIS).
// and our orbit will be eccentric
local ecc is sqrt(1 + ((2*spec_energy*angular_momentum_h^2)/BODY:MU^2)).

local launch_angle is arcsin(1/ecc). //why arcsin??

// rotation speed of mun around kerbin
local body_orbit_direction is BODY:ORBIT:VELOCITY:ORBIT:DIRECTION:YAW.
// rotation speed of ship around mun
local ship_orbit_direction is SHIP:ORBIT:VELOCITY:ORBIT:DIRECTION:YAW.

// launch point:
local launch_point_dir is (body_orbit_direction - 180 + launch_angle).
local node_eta is mod((360+ ship_orbit_direction - launch_point_dir),360)/360 * SHIP:OBT:PERIOD.

// Add node
local my_node to NODE(time:seconds + node_eta, 0, 0, delta_v).
ADD my_node.

// Fine tuning of dV.
// local lock current_peri to ORBITAT(SHIP,time+transfer_time):PERIAPSIS.
// until abs (current_peri - target_periapsis) < 300 {
// 	if current_peri < target_periapsis {
// 		set my_node:PROGRADE to my_node:PROGRADE - 0.05.
// 	} else {
// 		set my_node:PROGRADE to my_node:PROGRADE + 0.05.
// 	}
// }
