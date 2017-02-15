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

print stageDeltaV().
// list parts in partsL.
// for eng in partsL {
//   print eng:title.
//   print eng:stage.
//   // print eng:AVAILABLETHRUST.
//   print "---".
// }
