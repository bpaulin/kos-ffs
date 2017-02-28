{
	global navigate_lib is lex (
		"circularize", circularize@,
		"set_peri", set_peri@,
		"set_apo", set_apo@,
		"hohmann_rdv", hohmann_rdv@,
		"hohmann_return", hohmann_return@,
		"set_peri_delay", set_peri_delay@,
		"slowDown", slowDown@
	).

	function circularize{
		if obt:transition = "ESCAPE" or eta:periapsis < eta:apoapsis {
		  return set_apo(obt:periapsis).
		} else {
		  return set_peri(obt:apoapsis).
		}
	}

	function set_peri{
		parameter altWanted.

		local nd is node(
		  time:seconds + eta:apoapsis,
		  0,
		  0,
		  dVtoChangePeriapsisAtApoapsis(
		    ship:body,
		    ship:orbit:periapsis,
		    ship:orbit:apoapsis,
		    altWanted
		  )
		).

		return nd.
	}

	function set_apo{
		parameter altWanted.

		local nd is node(
		  time:seconds + eta:periapsis,
		  0,
		  0,
		  dVtoChangeApoapsisAtPeriapsis(
		    ship:body,
		    ship:orbit:periapsis,
		    ship:orbit:apoapsis,
		    altWanted
		  )
		).

		return nd.
	}

	function hohmann_rdv{
	  parameter transferTo.
		parameter margin is 0.

	  local r1 is ship:orbit:semiMajorAxis.
	  local r2 is transferTo:orbit:semiMajorAxis- margin.
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


	  return node(time:seconds+dt,0,0,dV)..
	}

	function hohmann_return{
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
		return NODE(time:seconds + node_eta, 0, 0, delta_v).
	}

	function set_peri_delay {
		// wanted periapsis, in km
		declare parameter wantedPeriapsis.
		// wanted delay before node, in s
		declare parameter delay.

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
		}		//
		// Set right dV
		//
		set meanDV to (maxDV+minDV)/2.
		set nd:prograde to burnDirection*meanDV.
	}

	function slowDown{
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
				maxParking
			).

			//to reenter
			set dv2 to dVtoChangePeriapsisAtApoapsis(
				ship:body,
				ship:orbit:periapsis,
				maxParking,
				periEnter
			).

			if (abs(dv1)+abs(dv2)<=availableDv) {
				set foundMax to true.
			}
			else {
				set minParking to maxParking.
				set maxParking to maxParking*2.
			}
		}
		output("apoapsis is between " + minParking + " and " + maxParking,true).

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
				meanParking
			).

			//to reenter
			set dv2 to dVtoChangePeriapsisAtApoapsis(
				ship:body,
				ship:orbit:periapsis,
				meanParking,
				periEnter
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
			periEnter,
			maxParking,
			periEnter
		).

		output("apoapsis: " + round(maxParking) + " km",true).
		output("deltaV to decrease apoapsis: " + round(dv1) + " m/s",true).
		output("deltaV to reenter: " + round(dv2) + " m/s",true).
		output("velocity at periapsis is " + round(Vperi) + " m/s",true).

		////////////////////////////////////////////////////////////////////////////////
		// execute nodes
		// @todo abort if velocity is too high
		////////////////////////////////////////////////////////////////////////////////
		local nd1 is node(time:seconds + eta:periapsis, 0, 0, dv1).
		add nd1.
		// local nd2 is node(time:seconds + min(eta:apoapsis, eta:periapsis), 0, 0, dv2).
		// add nd2.
	}



	////////////////////////////////////////////////////////////////////////////////
	// get deltaV needed to change apoapsis at periapsis
	////////////////////////////////////////////////////////////////////////////////
	function dVtoChangeApoapsisAtPeriapsis {
	  parameter orbitAround. // body
	  parameter orbitPeri. // periapsis
	  parameter orbitApo. // apoapsis
	  parameter newApo. // new apoapsis

	  local v0 is orbitVelocityAt(
	    orbitAround,
	    orbitPeri,
	    orbitApo,
	    orbitPeri
	  ).

	  local v1 is orbitVelocityAt(
	    orbitAround,
	    orbitPeri,
	    newApo,
	    orbitPeri
	  ).

	  return v1-v0.
	}

	////////////////////////////////////////////////////////////////////////////////
	// get deltaV needed to change periapsis at apoapsis
	////////////////////////////////////////////////////////////////////////////////
	function dVtoChangePeriapsisAtApoapsis {
	  parameter orbitAround. // body
	  parameter orbitPeri. // periapsis
	  parameter orbitApo. // apoapsis
	  parameter newPeri. // new periapsis

	  local v0 is orbitVelocityAt(
	    orbitAround,
	    orbitPeri,
	    orbitApo,
	    orbitApo
	  ).

	  local v1 is orbitVelocityAt(
	    orbitAround,
	    newPeri,
	    orbitApo,
	    orbitApo
	  ).

	  return v1-v0.
	}

	////////////////////////////////////////////////////////////////////////////////
	// get velocity for an orbit at a precise altitude
	////////////////////////////////////////////////////////////////////////////////
	function orbitVelocityAt {
	  parameter orbitAround. // body
	  parameter orbitPeri. // periapsis
	  parameter orbitApo. // apoapsis
	  parameter orbitAlt. // altitude

	  local orbitSma is (orbitAround:radius*2 + orbitPeri + orbitApo) / 2.
	  local realAlt is orbitAround:radius + orbitAlt.

	  return sqrt(orbitAround:mu * (2/realAlt -1/orbitSma)).
	}

	////////////////////////////////////////////////////////////////////////////////
	// deltaV for the current stage
	////////////////////////////////////////////////////////////////////////////////
	function stageDeltaV {
	  if maxthrust=0 {
	    return 0.
	  }
	  list engines in my_engines.
	  local eisp is 0.
	  for eng in my_engines {
	    if eng:ignition {
	      set eIsp to eIsp + eng:maxthrust / maxthrust * eng:isp.
	    }
	  }
	  local surfaceGravity is kerbin:mu / kerbin:radius^2.
	  local ve is eIsp * surfaceGravity.

	  local m0 is ship:mass.

	  local resLex is Stage:Resourceslex.
	  local LfA is resLex["LiquidFuel"]:amount.
	  local LfD is resLex["LiquidFuel"]:density.
	  local LfM is LfA*LfD.
	  local OxA is resLex["Oxidizer"]:amount.
	  local OxD is resLex["Oxidizer"]:density.
	  local OxM is OxA*OxD.

	  set m1 to m0-LfM-OxM.

	  return floor(ve*ln(m0/m1)).
	}

}
