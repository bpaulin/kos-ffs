// Ascent mission
{
  output("Loading Ascent mission", true).

  local curr_mission is lex(
    "sequence", list(
      "launch", launch@,
      "vertical", vertical@,
      "turn", turn@,
      "coasting", coasting@,
      "end_ascent", end_ascent@
    ),
    "events", lex(),
    "dependency", list(
      "libs/event.ks"
    )
  ).

  global ascent_mission is {
    parameter TARGET_ALTITUDE is body:atm:height+10000.
    parameter TARGET_HEADING is 90.
    set curr_mission["target_altitude"] to TARGET_ALTITUDE.
    set curr_mission["target_heading"] to TARGET_HEADING.
    return curr_mission.
  }.

  function launch {
    parameter mission.

    wait 2.
    if ship:status <> "PRELAUNCH" and ship:status <> "LANDED" {
      mission["switch_to"]("end_ascent").
      return true.
    }

    set ship:control:pilotmainthrottle to 0.

    lock throttle to 1.
    lock steering to heading(curr_mission["target_heading"],90).

    mission["add_event"]("staging", event_lib["staging"]).
    mission["next"]().
  }

  function vertical {
    parameter mission.

    if verticalSpeed>=75 {
      mission["next"]().
    }
  }

  function turn {
    parameter mission.

        lock steering to heading(curr_mission["target_heading"],90-sqrt((90^2)*(altitude)/body:atm:height)).
    // lock steering to heading(curr_mission["target_heading"],90-90*(altitude/body:atm:height * 0.85)^(0.75)).

    if apoapsis>=curr_mission["target_altitude"] {
      mission["next"]().
    }
  }

  function coasting {
    parameter mission.

    mission["remove_event"]("staging").
    // lock steering to heading(curr_mission["target_heading"],0).

    if apoapsis>=curr_mission["target_altitude"] {
      lock throttle to 0.
    }
    else {
      lock throttle to 0.5.
    }

    if altitude>=body:atm:height {
      mission["next"]().
    }
  }

  function end_ascent {
    parameter mission.

    lock throttle to 0.
    unlock steering.

    mission["next"]().
  }
}
