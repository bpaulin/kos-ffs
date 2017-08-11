{
  output("Loading Moon Return mission", true).

  local curr_mission is lex(
    "sequence", list(
      "moonReturn", moonReturn@,
      "exec_return", exec_return@,
      "coasting", coasting@,
      "increase_peri", increase_peri@,
      "end_return", end_return@
    ),
    "events", lex(),
    "dependency", list(
      "libs/navigate.ks",
      "libs/node.ks"
    )
  ).

  global moonReturn_mission is {
    return curr_mission.
  }.

  function moonReturn {
    parameter mission.

    add navigate_lib["hohmann_return"]().

    mission["next"]().
  }

  function exec_return {
    parameter mission.

    node_lib["exec"]().
    warpto(time:seconds + ship:orbit:nextpatcheta).

    mission["next"]().
  }

  function coasting {
    parameter mission.

    if ship:body=kerbin {
      mission["next"]().
    }
  }

  function increase_peri {
    parameter mission.

    if periapsis<80000{
      navigate_lib["set_peri_delay"](90000,60).
      node_lib["exec"]().
    }

    mission["next"]().
  }

  function end_return {
    parameter mission.

    mission["next"]().
  }
}
