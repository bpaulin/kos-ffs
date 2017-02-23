clearscreen.

{
  local deleteOnFinish is false.
  local backupOps is false.
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

  // checks if the requested file exists on the KSC disk
  // checks if there is enough room to copy a file from the archive to the vessel
  // will remove the log file if the space it frees will allow the transfer
  // also accounts for wether the transfer file has a local copy that will be replaced
  global download is {
    parameter archiveFile, localFile, keepfile is true.
    if not homeconnection:isconnected return false.
    if not archive:exists(archiveFile) return false.
    if core:volume:exists(localFile) core:volume:delete(localFile).
    copypath("0:" + archiveFile, localFile).
    if not keepfile
      archive:delete(archiveFile).
    return true.
  }.

  // for logging data, with various considerations
  global output is {
    parameter text.
    parameter toConsole is false.

    // print to console if requested
    if toConsole print text.

    // log the new data to the file if it will fit
    // otherwise delete the log to start anew
    set logStr to "[" + time:hour + ":" + time:minute + ":" + floor(time:second) + "] " + text.
    if core:volume:freespace > logStr:length {
      log logStr to sName + ".log.np2".
    } else {
      core:volume:delete(sName + ".log.np2").
      log "[" + time:calendar + "] new file" to sName + ".log.np2".
      log logStr to sName + ".log.np2".
    }

    // store a copy on KSC hard drives if we are in contact
    // otherwise save and copy over as soon as we are back in contact
    if homeconnection:isconnected {
      if not archive:exists(sName + ".log.np2") archive:create(sName + ".log.np2").
      if logList:length {
        for entry in logList archive:open(sName + ".log.np2"):writeln(entry).
        set logList to list().
      }
      archive:open(sName + ".log.np2"):writeln(logStr).
    } else {
      if core:volume:freespace > logStr:length {
        logList:add(logStr).
      } else {
        core:volume:delete(sName + ".log.np2").
        logList:add("[" + time:calendar + "] new file").
        logList:add(logStr).
      }
    }
  }.

  local boot is {
    // check if we have new instructions stored in event of comm loss
    if core:volume:exists("backup.op.ks") and not (homeconnection:isconnected or controlconnection:isconnected) {
      core:volume:delete("operations.ks").
      movepath("backup.op.ks", "operations.ks").
      print "KSC connection lost. Stored operations file loaded".
    } else {

      // check for connection to KSC for archive volume access if no instructions stored
      if not (homeconnection:isconnected or controlconnection:isconnected) {
        print "waiting for KSC link...".
        wait until homeconnection:isconnected.
      }

      print "KSC link established, fetching operations...".
      wait homeconnection:delay.

      // check for a new bootscript
      // destroy the log if needed to make room, but only if it'll make room
      if download(sName + ".boot.ks", "boot.ks", false) {
        print "new boot file received".
        wait 2.
        reboot.
      }

      // check for new operations
      // destroy the log if needed to make room, but only if it'll make room
      if download("operations/" + sName + ".ks", "operations.ks", false) print "new operations file received".
    }


    // ///////////////////
    // do any boot stuff
    // ///////////////////
    set ship:control:pilotmainthrottle to 0.

    // date stamp the log
    // won't output to archive copy until first ouput() call
    set logList to list().
    set logStr to "[" + time:calendar + "] boot up".
    log logStr to sName + ".log.np2".
    logList:add(logStr).


    // store new instructions while a current operations program is running
    // if we lose connection before a new script is uploaded, this will run
    // running ops should check backupOps flag and call download(shipName + ".bop.ks.", "backup.op.ks").
    when homeconnection:isconnected and archive:exists(sName + ".bop.ks.") then {
      set backupOps to true.
      if homeconnection:isconnected preserve.
    }

    // run operations?
    if not core:volume:exists("operations.ks") and homeconnection:isconnected {
      print "waiting to receive operations...".
      until download("operations/" + sName + ".ks", "operations.ks") {
        if not homeconnection:isconnected {
          if not core:volume:exists("backup.op.ks") {
            print "KSC connection lost, awaiting connection...".
            wait until homeconnection:isconnected.
            reboot.
          } else {
            if core:volume:exists("operations.ks") core:volume:delete("operations.ks").
            movepath("backup.op.ks", "operations.ks").
            print "KSC connection lost. Stored operations file loaded".
            break.
          }
        }
        wait 1.
      }
    }
    output("executing operations", true).
    RUNPATH("1:operations.ks").
    if deleteOnFinish deletepath("1:operations.ks").
    output("operations execution complete", true).
    wait 2.
    reboot.
  }.

  boot().
}
