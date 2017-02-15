parameter missionGoal.

set target to missionGoal.

run node_hohmann.
run node.

warpto(time:seconds + eta:transition + 1).
// mun
warpto(time:seconds + eta:transition + 1).
// kerbin
