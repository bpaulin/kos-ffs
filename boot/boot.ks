// boot script

clearscreen.

{
  // get internal name for log and operation
  local tempName is ship:name.
  local sName is "".
  from {local i is 0.} until i = tempName:length step {set i to i + 1.} do {
    if(tempName[i] = " ") {
      set sName to sName + "_".
    } else {
      set sName to sName + tempName[i].
    }
    wait 0.001.
  }
  log "" to sName + ".log.np2".

  local s is stack().
  local d is lex().
  global import is {
    parameter n.
    s:push(n).
    if not exists("1:/"+n)
      copypath("0:/"+n,"1:/"+n).
    runpath("1:/"+n).
    return d[n].
  }.

  global export is {
    parameter v.
    set d[s:pop()] to v.
  }.

  // download file from archive to core ----------------------------------------
  global download is {
    parameter archiveFile.      // filename on archive
    parameter localFile.        // filename on core
    parameter keepfile is true. // delete file from archive

    // exit without connection
    if not homeconnection:isconnected return false.
    // exit if file doesn't exist
    if not archive:exists(archiveFile) return false.

    // replace local file
    if core:volume:exists(localFile) core:volume:delete(localFile).
    copypath("0:" + archiveFile, localFile).

    // delete archive file
    if not keepfile archive:delete(archiveFile).

    return true.
  }.//download -----------------------------------------------------------------

  // download files for a mission ----------------------------------------------
  global downloadForMission is {
    parameter missionfiles. // lex, every file needed

    // add mission runner
    missionfiles:add("runner", "libs/mission_runner.ks").

    // download
    for file in missionfiles:values {
      download(file, file).
      runpath("1:" + file).
    }
  }.//downloadForMission -------------------------------------------------------

  // logging -------------------------------------------------------------------
  global output is {
    parameter text. // text to log
    parameter toConsole is false. // print to console

    // print to console if requested
    if toConsole print text.

    // set log line
    set logStr to "[" + time:hour + ":" + time:minute + ":" + floor(time:second) + "] " + text.

    // erase log if full
    if core:volume:freespace < logStr:length {
      core:volume:delete(sName + ".log.np2").
      log "[" + time:calendar + "] new file" to sName + ".log.np2".
    }

    // write in log
    log logStr to sName + ".log.np2".

    // @todo store in archive
  }.//output -------------------------------------------------------------------

  // boot function -------------------------------------------------------------
  local boot is {
    // get current mission
    if not core:volume:exists("mission.ks") and homeconnection:isconnected {
      print "downloading mission".
      download("mission/" + sName + ".ks", "mission.ks")
      wait 1.
    }

    set ship:control:pilotmainthrottle to 0.

    output("executing mission", true).
    RUNPATH("1:mission.ks").
    output("mission execution complete", true).
    wait 1.
    reboot.
  }.//boot ---------------------------------------------------------------------

  boot().
}
