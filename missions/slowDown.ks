{
  output("Loading SlowDown mission", true).

  local curr_mission is lex(
    "sequence", list(
      "slowdown", slowdown@,
      "exec_slowdown", exec_slowdown@,
      "end_slowdown", end_slowdown@
    ),
    "events", lex(),
    "dependency", list(
      "libs/navigate.ks",
      "libs/node.ks"
    )
  ).

  global slowDown_mission is {
    parameter REENTER_ALTITUDE.
    set curr_mission["reenter_altitude"] to REENTER_ALTITUDE.
    return curr_mission.
  }.

  function slowdown {
    parameter mission.

    navigate_lib["slowDown"](80000, 40000).
    // node_lib["exec"]().

    mission["next"]().
  }

  function exec_slowdown {
    parameter mission.

    node_lib["exec"]().

    mission["next"]().
  }

  function end_slowdown {
    parameter mission.

    mission["next"]().
  }
}
