// Rescue mission script
// Ken Cummins (madlemur)
//   based on work by
// Kevin Gisi
// http://youtube.com/gisikw

{
  downloadForMission(lex(
    "ascent", "Missions/ascent.ks",
    "dropStage", "Missions/dropStage.ks",
    "circularize", "Missions/circularize.ks",
    "dropStage", "Missions/dropStage.ks",
    "moonTransfer", "Missions/moonTransfer.ks",
    "catch", "Missions/catch.ks",
    "moonReturn", "Missions/moonReturn.ks",
    "slowDown", "Missions/slowDown.ks",
    "reenter", "Missions/reenter.ks",
    "dropStage", "Missions/dropStage.ks",
    "descent", "Missions/descent.ks"
  )).

  run_mission(
    list(
      ascent_mission(80000, 90),
      dropStage_mission(),
      circularize_mission(),
      dropStage_mission(),
      moonTransfer_mission(Mun),
      catch_mission(15000),
      moonReturn_mission(),
      slowDown_mission(25000),
      reenter_mission(35000),
      dropStage_mission(),
      descent_mission()
    ),
    false,
    lex(
      "dropStage", list(4,2,0)
    )
  ).
}
