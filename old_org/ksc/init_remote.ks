declare parameter needNodes is true.
declare parameter needActions is false.

CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
wait 2.

switch to archive.

if ship:status = "prelaunch" {
  runpath("0:/ksc/career", true, false).
}

until not hasnode { remove nextnode. }.

run once lib_message.
run once lib_math.
run once lib_io.
run once lib_utils.
