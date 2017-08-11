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
    "reenter", "Missions/reenter.ks",
    "descent", "Missions/descent.ks"
  )).

  run_mission(
    list(
      ascent_mission(80000, 90),
      dropStage_mission(),
      circularize_mission(),
      reenter_mission(35000),
      dropStage_mission(),
      descent_mission()
    ),
    false,
    lex(
      "dropStage", list(2,0)
    )
  ).
}
