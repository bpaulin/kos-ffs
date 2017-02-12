clearscreen.

function uiConsole {
  parameter prefix.
  parameter msg.
  print "T+" + round(missiontime) + " " + prefix + ": " + msg.
}

function uiBanner {
  parameter prefix.
  parameter msg.
  uiConsole(prefix, msg).
  hudtext(msg, 10, 4, 24, GREEN, false).
}

function uiDebug {
  parameter msg.
  uiConsole("Debug", msg).
  hudtext(msg, 1, 3, 24, WHITE, false).
}
