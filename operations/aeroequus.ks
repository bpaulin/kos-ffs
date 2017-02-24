// Rescue mission script
// Ken Cummins (madlemur)
//   based on work by
// Kevin Gisi
// http://youtube.com/gisikw

{
  downloadForMission(lex(
    "ascent", "Missions/ascent.ks"
  )).

  run_mission(list(
    ascent_mission(80000, 90)
  )).
}
