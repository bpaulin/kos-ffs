local wantedDistance is 100.

// sas off.

// relative velocity (prograde mark on navball).
lock Rvel to (ship:velocity:orbit - target:velocity:orbit).
// target heading ( target mark on navball)
lock Theading to lookdirup(target:position, ship:facing:upvector):forevector.
// print vel:mag.
// lock velR to vdot(vel, target:position:normalized) * target:position:normalized.
// lock velT to vel - velR.


// lock steering to 2*Theading-Rvel.
until false {
CLEARVECDRAWS().
SET targetPrograde TO VECDRAW(
      V(0,0,0),
      Theading:normalized*4,
      RGB(1,0,0),
      "target mark",
      1.0,
      TRUE,
      0.2
    ).
SET shipprograde TO VECDRAW(
      V(0,0,0),
      Rvel:normalized*4,
      RGB(0,1,0),
      "prograde mark",
      1.0,
      TRUE,
      0.2
    ).
SET test1 TO VECDRAW(
      V(0,0,0),
      (Theading:normalized-Rvel:normalized)*4,
      RGB(0,0,1),
      "test1",
      1.0,
      TRUE,
      0.2
    ).
wait 1.
}
// wait 12.

print vang(ship:prograde:forevector, lookdirup(target:position, ship:facing:upvector):forevector).
// lock dot to vdot(target:position, velR).
// lock velToTgt to vel:mag*dot/abs(dot).
// lock distance to (ship:position - target:position):mag.
//
// print vang(ship:prograde:forevector, lookdirup(target:position, ship:facing:upvector):forevector).
//
//   if dot<0 {
//     print "wrong way".
//     // on s'eloigne de la cible
//     lock steering to lookdirup(target:position, ship:facing:upvector).
//     wait until vang(ship:facing:vector, lookdirup(target:position, ship:facing:upvector):forevector) < 1.
//     print "facing ok".
//     lock throttle to 0.5.
//     wait until dot>0 and vel:mag>10.
//     lock throttle to 0.
//   }
//
//   if (vel:mag<10) {
//     print "increase velocity".
//     // on s'eloigne de la cible
//     lock steering to lookdirup(target:position, ship:facing:upvector).
//     wait until vang(ship:facing:vector, lookdirup(target:position, ship:facing:upvector):forevector) < 1.
//     print "facing ok".
//       print vel:mag.
//     lock throttle to 0.5.
//     wait until vel:mag>10.
//     lock throttle to 0.
//   }
//
//

sas on.
//
// print velR:mag.

//      lock steering to -target:facing.
// until false {

// }
// sas off.
//
// until distance<=wantedDistance {
//   lock throttle to 0.
//   if dot<0 {
//     print "wrong way".
//    // on s'eloigne de la cible
//    lock steering to lookdirup(target:position, ship:facing:upvector).
//    wait until vang(ship:facing:vector, lookdirup(target:position, ship:facing:upvector):forevector) < 2.
//    lock throttle to 1.
//   }
//   else {
//     if abs(velToTgt)>max(10, distance/10) {
//       print "too fast".
//       // on s'approche trop vite
//       lock steering to lookdirup(-target:position, ship:facing:upvector).
//       wait until vang(ship:facing:vector, lookdirup(-target:position, ship:facing:upvector):forevector) < 2.
//         lock throttle to 1.
//     }
//     else {
//       print "not fast enough".
//       //on s'approche pas assez vite
//       lock steering to lookdirup(target:position, ship:facing:upvector).
//       wait until vang(ship:facing:vector, lookdirup(target:position, ship:facing:upvector):forevector) < 2.
//         lock throttle to 1.
//     }
//   }
//   wait 1.
// }


// // going toward the target
// lock steering to lookdirup(target:position, ship:facing:upvector).
// // accelerate til 10% distance.
// print velToTgt.
// until abs(velToTgt)>max(50, distance/10) {
//   lock throttle to 1.
//   wait 0.1.
// }
// lock throttle to 0.

// print velToTgt.
// until distance<=100 {
//   // lock steering to lookdirup(-velR:normalized, ship:facing:upvector).
//   lock steering to lookdirup(-target:position, ship:facing:upvector).
//   // print distance.
//   // print velToTgt.
//   // until abs(velToTgt)>(distance/10) {
//   //   // lock throttle to 0.1.
//   //   // print velToTgt.
//   //   // print distance.
//   //   // wait 1.
//   // }
//   // lock throttle to 0.
//   // wait 1.
//
// }

// until false {
//   // if dot<0 {
//   //   print -1*vel:mag.
//   // }
//   // else {
//     print vel:mag.
//   // }
//   wait 1.
// }
// if dot < 0 {
//   lock steering to lookdirup(-velR:normalized, ship:facing:upvector).
//   wait until vdot(-velR:normalized, ship:facing:forevector) >= 0.9.
//   unlock steering.
//   lock throttle to 1.
//   wait until dot > 0.
//   set throttle to 0.
//   sas off.
// }


sas on.
// unlock dot.
// function dockMatchVelocity {
//   parameter residual.
//
//   set residual to max(0.2, residual).
//
//   // Don't let unbalanced RCS mess with our velocity
//   rcs off.
//   sas off.
//
//   local matchStation is 0.
//   if target:name:contains("docking") {
//     set matchStation to target:ship.
//   } else {
//     set matchStation to target.
//   }
//
//   local matchAccel is ship:maxthrust/ship:mass.
//   lock matchVel to (ship:velocity:orbit - matchStation:velocity:orbit).
//
//   // Point away from relative velocity vector
//   lock steering to lookdirup(-matchVel:normalized, ship:facing:upvector).
//   wait until vdot(-matchVel:normalized, ship:facing:forevector) >= 0.99.
//
//   // Cancel velocity
//   lock throttle to min(matchVel:mag / matchAccel, 1.0).
//
//   wait until matchVel:z <= 0 and matchVel:mag <= residual and (residual = 0 or matchVel:mag > residual * 0.8).
//
//   unlock throttle.
//   set ship:control:pilotmainthrottle to 0.
//
//   // TODO use RCS to cancel remaining dv
//
//   unlock matchVel.
//
//   lock steering to lookdirup(matchStation:position, ship:facing:upvector).
//   wait until vdot(matchStation:position, ship:facing:forevector) >= 0.99.
//
//   unlock steering.
//   sas on.
// }
// lock dTgt to (ship:position-target:position):mag.
// // lock Vtgt to
//
// print dTgt.
// lock Vtgt to (ship:velocity:orbit-target:velocity:orbit):mag.
// // lock Vtgt to
// print vdot(ship:velocity:orbit,target:velocity:orbit).
// print Vtgt.
//
//
// // run once lib_dock.
// // run once lib_ui.
//
// local accel is ship:maxthrust/ship:mass.
// lock vel to (ship:velocity:orbit - target:velocity:orbit).
// lock velR to vdot(vel, target:position:normalized) * target:position:normalized.
// lock velT to vel - velR.
//
// // Don't let unbalanced RCS mess with our velocity
// rcs off.
// sas off.
//
// // if target:position:mag > 5000 or vel:mag > 25 {
// //   run node_vel_tgt.
// //   local crit is 2 * vel:mag / accel.
// //   if nextnode:eta > crit {
// //     run warp(nextnode:eta - crit).
// //   }
// //
// //   if target:position:mag / vel:mag < 30 { // Nearby target; come to a stop first
// //     lock steering to lookdirup(-vel:normalized, ship:facing:upvector).
// //     wait until vdot(-vel:normalized, ship:facing:forevector) >= 0.95.
// //
// //     // uiBanner("Maneuver", "Match velocity").
// //     lock throttle to min(vel:mag / accel, 1.0).
// //     wait until vel:mag < 0.5.
// //     set throttle to 0.
// //   } else if velT:mag > 1 { // Far-away target; cancel transverse velocity first
// //     lock steering to lookdirup(-velT:normalized, ship:facing:upvector).
// //     wait until vdot(-velT:normalized, ship:facing:forevector) >= 0.99.
// //
// //     // uiBanner("Maneuver", "Match transverse velocity").
// //     lock throttle to min(velT:mag / accel, 1.0).
// //     wait until velT:mag < 0.5.
// //     set throttle to 0.
// //   }
// // }
//
// // uiBanner("Maneuver", "Begin approach").
// lock dot to vdot(target:position, velR).
// if dot < 0 {
//   lock steering to lookdirup(-velR:normalized, ship:facing:upvector).
//   wait until vdot(-velR:normalized, ship:facing:forevector) >= 0.9.
//   unlock steering.
//   lock throttle to 1.
//   wait until dot > 0.
//   set throttle to 0.
//   sas off.
// }
// unlock dot.
//
// lock steering to lookdirup(velR:normalized, ship:facing:upvector).
// wait until vdot(velR:normalized, ship:facing:forevector) >= 0.9.
//
// local t0 is time:seconds.
// lock throttle to 1.
// wait until target:position:mag / velR:mag < (time:seconds - t0 + 5) or vel:mag > 100.
// set throttle to 0.
// local dt is time:seconds - t0.
//
// lock steering to lookdirup(-velR:normalized, ship:facing:upvector).
// wait until vdot(-velR:normalized, ship:facing:forevector) >= 0.99.
// local stopDistance is 0.5 * accel * (vel:mag / accel)^2.
// local dt is (target:position:mag - stopDistance - 10) / vel:mag.
// // run warp(dt).
//
// dockMatchVelocity(max(1.0, min(10.0, target:position:mag / 60.0))).
//
// unlock velR.
// unlock velT.
// unlock vel.
//
// sas on.
