declare parameter needNodes is true.
declare parameter needActions is false.

function warn {
  parameter msg.
  terminal:input:clear.
  print msg + ", press key to launch anyway (and die)".
  set ch to terminal:input:getchar().
}

if needNodes and not career:canmakenodes {
  warn("this mission needs nodes").
}

if needActions and not career:candoactions {
  warn("this mission needs actions").
}

global deployStatus is true.

switch to archive.

list files in scripts.
for file in scripts {
  if file:name:endswith(".ks") and not file:name:startswith("test") {
    compile file:name.
    local compiled is open(file:name:replace(".ks", ".ksm")).
    local copySize is min(file:size, compiled:size).
    if copysize>core:volume:freespace {
      set deployStatus to false.
      deletepath(compiled).
      break.
    }
    if file:size<compiled:size {
      copypath(file, core:volume).
      deletepath(compiled).
    }
    else {
      movepath(compiled, core:volume).
    }
  }
}

switch to core:volume.

if not deployStatus {
  warn("not enough free space on volume").
}
