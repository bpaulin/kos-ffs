declare parameter needNodes is true.
declare parameter needActions is false.

CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.

if ship:status = "prelaunch" {
  runpath("0:/ksc/career", true, false).
}

until not hasnode {
  remove nextnode.
  wait 1.
}.

run once lib_message.
run once lib_math.
run once lib_io.
run once lib_utils.

set steeringmanager:pitchts to 5.
set steeringmanager:yawts to 5.
