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
    parameter MAXSTAGE.

    set curr_mission["maxstage"] to MAXSTAGE.

    return curr_mission.
  }.

  function dropStage {
    parameter mission.

    if stage:number>curr_mission["maxstage"] {
      output("droping stage", true).
      until stage:number=curr_mission["maxstage"] {
        stage.
        until stage:ready {
          wait 0.
        }
      }
    }

    mission["next"]().
  }
}
