Audio.setup(function(ctx) {
  if(ctx.synths.length == 0) {
    ctx.tick = 0;
  }

  var top = new Synth().g(.30, 0, ctx.width);
  var mid = new Synth().g(1, 0, ctx.width);
  var bot = new Synth().g(1, 0, ctx.width);

  for(var i = 0; i < ctx.width; i++) {
    top.f({ value: Note.C }, i, .5);

    if((i % 2 == 0) && i > 0) {
      mid.f({ value: Note.E }, i, .75);
    }

    if((i % 3 == 0) && i > 0) {
      bot.f({ value: Note.G }, i, 1);
    }
  }

  ctx.synths = [ top, mid, bot ];
  ctx.bpm    = 180;
  ctx.tick++;
  return ctx;
});
