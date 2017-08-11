{
  output("Loading Catch mission", true).

  local curr_mission is lex(
    "sequence", list(
      "catch", catch@,
      "catch_peri", catch_peri@,
      "catch_exec_peri", catch_exec_peri@,
      "catch_circ", catch_circ@,
      "catch_exec_circ", catch_exec_circ@,
      "end_catch", end_catch@
    ),
    "events", lex(),
    "dependency", list(
      "libs/navigate.ks",
      "libs/node.ks"
    )
  ).

  global catch_mission is {
    parameter MIN_PERIAPSIS.
    set curr_mission["min_periapsis"] to MIN_PERIAPSIS.
    return curr_mission.
  }.

  function catch {
    parameter mission.

    mission["next"]().
  }

  function catch_peri {
    parameter mission.

    mission["next"]().
  }

  function catch_exec_peri {
    parameter mission.

    mission["next"]().
  }

  function catch_circ {
    parameter mission.

    add navigate_lib["circularize"]().

    mission["next"]().
  }

  function catch_exec_circ {
    parameter mission.

    node_lib["exec"]().

    mission["next"]().
  }

  function end_catch {
    parameter mission.

    mission["next"]().
  }
}
