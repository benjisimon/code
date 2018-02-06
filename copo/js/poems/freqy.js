Audio.setup(function(ctx) {
  var scale = [Note.C, Note.D, Note.E, Note.F, Note.G, Note.A, Note.B, Note.C ];
  ctx.width = scale.length;

  var adam = [ 
    { type: 'gain', value: .5, at: 0, duration: ctx.width }
  ];

  scale.forEach(function(n, i) {
    adam.push({type: 'frequency', value: { value: n, fadeIn: 0.01, fadeOut: .1 }, 
               at: i, duration: .5 });
  });

  var brenda = [
    { type: 'frequency', value: Note.octave(Note.F), duration: ctx.width, at: 0 }
  ];
  for(var i = 0; i < ctx.width; i++) {
    brenda.push({type: 'gain', value: (i / ctx.width) * .8, at: i, duration: .5 });
  }


  var charlie = [
    { type: 'frequency', value: Note.octave(Note.C, 3), duration: ctx.width, at: 0 }
  ];
  for(var i = 0; i < ctx.width; i += 2) {
    charlie.push({type: 'gain', value: { value: .2, fadeIn: .01, fadeOut: .001 }, at: i, duration: .25 });
    charlie.push({type: 'gain', value: { value: .2, fadeIn: .001, fadeOut: .01 }, at: i + .5, duration: .25 });
  }

  ctx.players = [ adam, brenda, charlie ];

  return ctx;
});
