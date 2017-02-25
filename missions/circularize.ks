// Ascent mission
{
  output("Loading Circularize mission", true).

  local curr_mission is lex(
    "sequence", list(
      "circularize", circularize@,
      "exec_node", exec_node@,
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
      output("exec_node", true).
      mission["next"]().
    }
    else {
      mission["switch_to"]("end_circularize").
    }
  }

  function exec_node {
    parameter mission.

    node_lib["exec"]().

    output("end_circularize", true).
    mission["next"]().
  }

  function end_circularize {
    parameter mission.

    mission["next"]().
  }
}
