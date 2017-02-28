{
  output("Loading Moon Transfer mission", true).

  local curr_mission is lex(
    "sequence", list(
      "hohmann", hohmann@,
      "exec_hohmann", exec_hohmann@,
      "end_transfer", end_transfer@
    ),
    "events", lex(),
    "dependency", list(
      "libs/navigate.ks",
      "libs/node.ks"
    )
  ).

  global moonTransfer_mission is {
    parameter TARGET_GOAL.
    set curr_mission["target_goal"] to TARGET_GOAL.
    return curr_mission.
  }.

  function hohmann {
    parameter mission.

    add navigate_lib["hohmann_rdv"](curr_mission["target_goal"], curr_mission["target_goal"]:soiradius/3).

    mission["next"]().
  }

  function exec_hohmann {
    parameter mission.

    node_lib["exec"]().
    warpto(time:seconds + ship:orbit:nextpatcheta).

    mission["next"]().
  }

  function end_transfer {
    parameter mission.

    if ship:body=curr_mission["target_goal"] {
      mission["next"]().
    }
  }
}
