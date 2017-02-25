// Ascent mission
{
  output("Loading Circularize mission", true).

  local curr_mission is lex(
    "sequence", list(
      "circularize", circularize@,
      "exec_circularize", exec_circularize@,
      "end_circularize", end_circularize@
    ),
    "events", lex(),
    "dependency", list(
      "libs/navigate.ks",
      "libs/node.ks"
    )
  ).

  global circularize_mission is {
    return curr_mission.
  }.

  function circularize {
    parameter mission.

    if orbit:eccentricity>0.001 {
      add navigate_lib["circularize"]().
      wait 1.
      mission["next"]().
    }
    else {
      mission["switch_to"]("end_circularize").
    }
  }

  function exec_circularize {
    parameter mission.

    node_lib["exec"]().

    mission["next"]().
  }

  function end_circularize {
    parameter mission.

    mission["next"]().
  }
}
