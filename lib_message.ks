declare global verbose is 1.

function errorMessage {
  parameter msg.
  print "T+" + round(missiontime) + " ERROR " + msg.
  hudtext(msg, 10, 4, 24, RED, false).
}

function missionMessage {
  parameter msg.
  print "T+" + round(missiontime) + " " + msg.
  hudtext(msg, 10, 4, 24, GREEN, false).
}

function detailMessage {
  parameter prefix.
  parameter msg.
  if verbose>=1 {
    set msg to prefix + ": " + msg.
    print msg.
    hudtext(msg, 10, 4, 24, WHITE, false).
  }
}

function warningMessage {
  parameter msg.
  if verbose>=1 {
    print msg.
    hudtext(msg, 10, 4, 36, YELLOW, false).
  }
}

function debugMessage {
  parameter msg.
  if verbose>=2 {
    print msg.
    hudtext(msg, 1, 3, 24, WHITE, false).
  }
}
