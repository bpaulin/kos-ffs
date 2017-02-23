// Rescue mission script
// Ken Cummins (madlemur)
//   based on work by
// Kevin Gisi
// http://youtube.com/gisikw

{
  local missionfiles is lex(
    "launch", "Missions/launch_mission.ks"
  ).

  for file in missionfiles:values {
    download(file, file).
    runpath("1:" + file).
  }

  local missions is list().
  missions:add(launch_mission(80000, 90)).

  local dependency is uniqueSet(
    "libs/mission_runner.ks"
  ).
  local mission_sequence is list().
  local mission_events is lex().

  for mission in missions {
    for lib in mission["dependency"] {
      dependency:add(lib).
    }
    for seq in mission["sequence"]
      mission_sequence:add(seq).
    if mission["events"]:length > 0
      for evt in mission["events"]:keys
        mission_events:add(evt, mission["events"][evt]).
  }
  for file in dependency {
    download(file, file).
    runpath("1:" + file).
  }
  mission_sequence:add("mission_complete").
  mission_sequence:add({ parameter mission. hudtext("Mission script completed.", 5, 2, 25, white, true). mission["terminate"](). }).

  run_mission(mission_sequence, mission_events).
}
