// Ascent mission
{
  output("Loading Re-Enter mission", true).

  local curr_mission is lex(
    "sequence", list(
      "reenter", reenter@,
      "exec_reenter", exec_reenter@,
      "coasting", coasting@,
      "end_reenter", end_reenter@
    ),
    "events", lex(),
    "dependency", list(
      "libs/navigate.ks",
      "libs/node.ks"
    )
  ).

  global reenter_mission is {
    parameter TARGET_ALTITUDE.
    set curr_mission["target_altitude"] to TARGET_ALTITUDE.
    return curr_mission.
  }.

  function reenter {
    parameter mission.

    if periapsis>curr_mission["target_altitude"] {
      add navigate_lib["set_peri"](curr_mission["target_altitude"]).
      wait 1.
      mission["next"]().
    }
    else {
      mission["switch_to"]("end_reenter").
    }
  }

  function exec_reenter {
    parameter mission.

    node_lib["exec"]().

    mission["next"]().
  }

  function coasting {
    parameter mission.

    if altitude<=body:atm:height {
      mission["next"]().
    }
  }

  function end_reenter {
    parameter mission.

    mission["next"]().
  }
}
