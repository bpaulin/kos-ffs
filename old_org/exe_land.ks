
run once lib_utils.

local touchdownSpeed is 1.

sas off.
gear on.
local tset is 1.
lock steering to retrograde.
// wait until vang(ship:facing:vector, retrograde) < 2.
lock throttle to tset.
wait until ship:groundspeed<2.
lock steering to ship:SRFRETROGRADE.

until ship:status="landed" {
	// print round(verticalspeed) + " " + round(alt:radar).
	if alt:radar<15 {
		lock steering to UP.
	}
	if verticalspeed>=0{
		set tset to 0.
	}
	else {
		if abs(verticalspeed)>alt:radar/10 or abs(verticalspeed)>100{
			set tset to 1.
		}
		else {
			set tset to 0.
		}
	}
	wait 0.01.
}
