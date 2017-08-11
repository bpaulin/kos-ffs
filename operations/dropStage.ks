// Ascent mission
{
  output("Loading dropStage mission", true).

  local curr_mission is lex(
    "sequence", list(
      "dropStage", dropStage@
    ),
    "events", lex(),
    "dependency", list()
  ).

  global dropStage_mission is {
    return curr_mission.
  }.

  function dropStage {
    parameter mission.

    local params is mission["get_data"]("dropStage").
    local maxStage is params[0].
    params:remove(0).
    mission["add_data"]("dropStage", params).

    if stage:number>maxStage {
      until stage:number=maxStage {
        stage.
        until stage:ready {
          wait 0.
        }
      }
    }

    mission["next"]().
  }
}
