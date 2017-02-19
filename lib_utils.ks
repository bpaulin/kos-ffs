run once lib_math.
run once lib_message.

function dropStageTo {
  declare parameter maxStage.

  until stage:number=maxStage {
    debugMessage(stageDeltaV() + " m/s left in stage #" + stage:number).
    stage.
    until stage:ready {
      wait 0.
    }
  }
}

function burnStaging {
  declare parameter maxStage.

  if stage:number > maxStage {
    if maxthrust = 0 {
      debugMessage("no thrust, stage #" + stage:number).
      stage.
    }
    SET numOut to 0.
    LIST ENGINES IN engines.
    FOR eng IN engines
    {
      IF eng:FLAMEOUT
      {
        SET numOut TO numOut + 1.
      }
    }
    if numOut > 0 {
      debugMessage("flameout, stage #" + stage:number).
      stage.
    }
  }
}
