Audio.setup(function(ctx) {

  function chord(notes, octave, startAt, duration) {
    return notes.map(n => new Synth()
                     .g({ value: 1, fadeOut: .5}, startAt + (rand(1, 25) / 100), duration)
                     .f({ value: Note.octave(n, octave), fadeOut: 1 }, startAt, duration + 1));
  }
  ctx.synths = [];
  for(var i = 0; i < ctx.width ; i += 4) {
    chord([Note.C, Note.E, Note.G], 1, i, .25).forEach(s => ctx.synths.push(s));
    chord([Note.C, Note.E, Note.G, Note.B, Note.Bf], -2, i + 2, 1).forEach(s => ctx.synths.push(s));
  }
  return ctx;
});
