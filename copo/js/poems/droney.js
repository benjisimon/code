Audio.setup(function(ctx) {
  ctx.tick = ctx.tick ? ctx.tick : 0;
  
  var adam = [
    { type: 'frequency', value: Note.octave(Note.D, -2), at: 0, duration: ctx.width },
  ];

  for(var i = 0; i < ctx.width; i++) {
    adam.push({ type: 'gain', value: 1, at: i, duration: .25 });
  }

  var brenda =  [
    { type: 'frequency', value: Note.E, at: 0, duration: ctx.width }
  ];

  for(var i = 0; i < ctx.width; i += 2) {
    brenda.push({ type: 'gain', value: { value: .4, fadeIn: .02, fadeOut: 2 } , at: i, duration: .5 });
  }


  var charlie =  [
    { type: 'frequency', value: Note.octave(Note.F, 2), at: 0, duration: ctx.width }
  ];

  for(var i = 0; i < ctx.width; i += 4) {
    charlie.push({ type: 'gain', value: { value: .2, fadeIn: .01, fadeOut: .001 } , at: i, duration: .25 });
  }


  ctx.bpm    = 120 + ((ctx.tick % 6) * 20);
  ctx.players = [ adam, brenda, charlie ];
  ctx.tick++;
  
  return ctx;
});
