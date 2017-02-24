// Ascent mission
{
  output("Loading Ascent mission", true).

  local curr_mission is lex(
    "sequence", list(
      "launch", launch@,
      "vertical", vertical@,
      "turn", turn@,
      "end_ascent", end_ascent@
    ),
    "events", lex(),
    "dependency", list(
      "libs/event.ks"
    )
  ).

  global ascent_mission is {
    parameter TARGET_ALTITUDE is 80000.
    parameter TARGET_HEADING is 90.
    set curr_mission["target_altitude"] to TARGET_ALTITUDE.
    set curr_mission["target_heading"] to TARGET_HEADING.
    return curr_mission.
  }.

  function launch {
    parameter mission.

    if ship:status <> "PRELAUNCH" {
      mission["switch_to"]("end_ascent").
      return true.
    }

    set ship:control:pilotmainthrottle to 0.

    lock throttle to 1.
    lock steering to heading(curr_mission["target_heading"],90).

    mission["add_event"]("staging", event_lib["staging"]).
    output("vertical ascent", true).
    mission["next"]().
  }

  function vertical {
    parameter mission.

    if verticalSpeed>=75 {
      output("gravity turn", true).
      mission["next"]().
    }
  }

  function turn {
    parameter mission.

    lock steering to heading(curr_mission["target_heading"],90-90*(altitude/body:atm:height * 0.85)^(0.75)).

    if apoapsis>=curr_mission["target_altitude"] {
      output("end ascent", true).
      mission["next"]().
    }
  }

  function end_ascent {
    parameter mission.

    lock throttle to 0.
    lock steering to heading(curr_mission["target_heading"],0).

    mission["remove_event"]("staging").
    mission["next"]().
  }
}
