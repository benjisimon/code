Audio.setup(function(ctx) {

  function cmaj(synths, t, duration, octave, fuzz) {
    var x = rand(1, fuzz) / 1000;
    var y = rand(1, fuzz) / 1000;
    var z = rand(Note.C, Note.C + fuzz);
    synths.push(new Synth().g(.6, t, duration).f({value: Note.octave(Note.C, octave), fadeIn: x }, t, duration));
    synths.push(new Synth().g(.6, t, duration).f({value: Note.octave(Note.E, octave), fadeOut: y}, t, duration));
    synths.push(new Synth().g(.6, t, duration).f({value: Note.octave(Note.G, octave), fadeTo: z }, t, duration));
    
  }


  var synths = [];
  for(var i = 0;i <  ctx.width; i += 2) {
    cmaj(synths, i, .25, i % 4, 0);
    cmaj(synths, i + .25, .25, i % 4, 400);
    cmaj(synths, i + .75, .25, (i+2) % 5, 800);


    if((i % 4) == 0) {
      synths.push(new Synth().g(1, i, 2).f({ value: Note.octave(Note.D, -2), fadeTo: Note.octave(Note.C,- 2) },
                                           i, 2));
    }

  }

  ctx.synths = synths;
  return ctx;

});
