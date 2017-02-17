declare parameter needNodes is true.
declare parameter needActions is false.

function warn {
  parameter msg.
  terminal:input:clear.
  print msg + ", press key to launch anyway (and die)".
  set ch to terminal:input:getchar().
}

if needNodes and not career():canmakenodes {
  warn("this mission needs nodes").
}

if needActions and not career():candoactions {
  warn("this mission needs actions").
}
