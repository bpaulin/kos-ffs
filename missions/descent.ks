// Ascent mission
{
  output("Loading Descent mission", true).

  local curr_mission is lex(
    "sequence", list(
      "descent", descent@,
      "end_descent", end_descent@
    ),
    "events", lex(),
    "dependency", list()
  ).

  global descent_mission is {
    return curr_mission.
  }.

  function descent {
    parameter mission.

    sas off.
    set STEERINGMANAGER:PITCHPID:KD to 5.
    set STEERINGMANAGER:YAWPID:KD to 5.
    lock steering to retrograde.

    if ship:status="landed" or ship:status="splashed" {
      mission["next"]().
    }
  }

  function end_descent {
    parameter mission.

    sas on.
    unlock steering.

    mission["next"]().
  }
}
