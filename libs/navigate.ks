{
	global navigate_lib is lex (
		"circularize", circularize@,
		"set_peri", set_peri@,
		"set_apo", set_apo@
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
}
