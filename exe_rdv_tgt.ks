run once lib_message.
run once lib_node.

declare global verbose is verboseDetails.

until not hasnode {
  remove nextnode.
  wait 0.1.
}.

if abs(ship:orbit:inclination-target:orbit:inclination)>0.1 {
  detailMessage("Rendezvous",
    "matching planes from " + round(ship:orbit:inclination,3) +
    " to " + round(target:orbit:inclination,3)
  ).
  run node_match_inclination(target).
  run exe_node.
}

detailMessage("Rendezvous",  "transfer phasing orbit").

local nodesTransfer is nodesTransferHohman(target).
local phasingOrbits is nodesTransfer[0]:eta/orbit:period.
if phasingOrbits>5 {
  local axisRatio is (1 + 1.25 / 5)^(2/3).
  local smaPhasing is orbit:semiMajorAxis * axisRatio.
  circularizeAt(smaPhasing-body:radius).
  set nodesTransfer to nodesTransferHohman(target).
  set phasingOrbits to nodesTransfer[0]:eta/orbit:period.
}
print "phasing is " + round(phasingOrbits, 2) + " orbits away".

for mnv in nodesTransfer {
  add mnv.
}
run exe_node.
run exe_node.
