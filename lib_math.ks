////////////////////////////////////////////////////////////////////////////////
// deltaV for the current stage
////////////////////////////////////////////////////////////////////////////////
function stageDeltaV {
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
