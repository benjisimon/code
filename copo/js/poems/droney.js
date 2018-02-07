Audio.setup(function(ctx) {
  ctx.tick = ctx.tick ? ctx.tick : 0;
  
  var adam    = new Synth().f(Note.octave(Note.D, -2), 0, ctx.width);
  var brenda  = new Synth().f(Note.E, 0, ctx.width);
  var charlie = new Synth().f(Note.octave(Note.F, 2), 0, ctx.width);

  for(var i = 0; i < ctx.width; i++) {
    adam.gain(1, i, .25);
  }

  for(var i = 0; i < ctx.width; i += 2) {
    brenda.gain({ value: .4, fadeIn: .02, fadeOut: 2 } , i, .5);
  }


  for(var i = 0; i < ctx.width; i += 4) {
    charlie.gain({ value: .2, fadeIn: .01, fadeOut: .001 }, i, .25);
  }


  ctx.bpm    = 120 + ((ctx.tick % 6) * 20);
  ctx.synths = [ adam, brenda, charlie ];
  ctx.tick++;
  
  return ctx;
});
