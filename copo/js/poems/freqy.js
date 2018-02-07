Audio.setup(function(ctx) {
  var scale = [Note.C, Note.D, Note.E, Note.F, Note.G, Note.A, Note.B, Note.C ];
  ctx.width = scale.length;

  var adam = new Synth().gain(.5, 0, ctx.width);

  scale.forEach(function(n, i) {
    adam.f({ value: n, fadeIn: 0.01, fadeOut: .1 },  i, .5);
  });

  var brenda = new Synth().f(Note.F, 0, ctx.width);
  for(var i = 0; i < ctx.width; i++) {
    brenda.gain((i / ctx.width) * .8, i, .5 );
  }

  var charlie = new Synth().f(Note.octave(Note.C, 3), 0, ctx.width);
  for(var i = 0; i < ctx.width; i += 2) {
    charlie.gain({ value: .2, fadeIn: .01, fadeOut: .001 }, i, .25);
    charlie.gain({ value: .2, fadeIn: .01, fadeOut: .001 }, i + .5, .25);
  }

  ctx.synths = [ adam, brenda, charlie ];

  return ctx;
});
