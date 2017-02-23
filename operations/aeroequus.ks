// Rescue mission script
// Ken Cummins (madlemur)
//   based on work by
// Kevin Gisi
// http://youtube.com/gisikw

{
  downloadForMission(lex(
    "launch", "Missions/launch_mission.ks"
  )).

  run_mission(list(
    launch_mission(80000, 90)
  )).
}
