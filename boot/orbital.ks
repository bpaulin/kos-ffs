if ship:status = "prelaunch" {
  switch to archive.

  list files in scripts.
  // for file in list("lib_ui", "mission_suborbital", "ascent", "descent") {
  for file in scripts {
    if file:name:endswith(".ks") {
      copypath(file, core:volume).
    }
  }
}

switch to core:volume.
wait 2.

run mission_orbital.
