function dropStageTo {
  declare parameter maxStage.

  until stage:number=maxStage {
    stage.
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
