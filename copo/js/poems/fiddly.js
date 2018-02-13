Audio.setup(function(ctx) {
  
  var top = new Synth();
  var mid = new Synth();
  var bot = new Synth();
  
  var n = function(i) {
    return Note.SCALE_12[i % Note.SCALE_12.length];
  }

  for(var i = 0; i < ctx.width; i++) {
    top.f({ value: n(0), fadeOut: .2}, i, .1).g(.75, i, 1);
    mid.f({ value: n(2), fadeOut: .3}, i, .5).g(.5, i, 1);
    bot.f({ value: n(5), fadeOut: 1 }, i, .25).g(.5, i, 1);
  }

  var adam  = new Synth();
  var barb  = new Synth();
  for(var i = 0; i < ctx.width; i += 4) {
    adam.f(Note.octave(Note.A, 2), i, .5).g(2, i, .2);
    barb.f(Note.octave(Note.G, 2), i + 1, .5).g(2, i+ 1, .2);
  }

  var charlie = new Synth();
  for(var i = ctx.width / 2; i < ctx.width; i += 2) {
    charlie.f(Note.A, i, .25).g(1, i, .25);
  }

  ctx.synths = [ top, mid, bot, adam, barb, charlie ];
  return ctx;
});
