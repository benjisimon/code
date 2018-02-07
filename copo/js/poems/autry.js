Audio.setup(function(ctx) {
  var left = new Synth().f(Note.C, 0, ctx.width);
  for(var i = 0; i < ctx.width; i += 1) {
    left.gain(1, i, .80);
  }

  var right = new Synth().f(Note.A, 0, ctx.width);

  for(var i = 0; i < (ctx.width * 4); i += 3) {
    right.gain(.6, i, .25);
  }

  ctx.bpm     = ctx.bpm > 300 ? 120 : (ctx.bpm + 50);
  ctx.synths = [ left, right ];

  return ctx;
});
