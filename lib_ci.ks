switch to archive.

list files in scripts.
for file in scripts {
  if file:name:endswith(".ks") {
    compile file:name.
    local compiled is open(file:name:replace(".ks", ".ksm")).
    copySize = min(file:size, compiled:size).
    if file.size>compiled.size {
      copypath(file, core:volume).
      deletepath(compiled).
    }
    else {
      movepath(file, core:volume).
    }
  }
}


// switch to core:volume.
// wait 2.
// sas on.
