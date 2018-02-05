Conductor.play(function(ctx) {
  if(ctx.song.isEmpty()) {
    ctx.tick = 0;
  }
  
  var left = new Score();
  left.add(new Sound().frequency(Note.C).duration(2).g(((10 - ctx.tick) / 10) * 100));

  var right = new Score();
  var pattern = [Note.C, Note.A, Note.D, Note.G ] ;
  for(var i = 0; i < 4; i++) {
    var stack = new Stack();
    for(j = 0; j < i; j++) {
      stack.add(new Sound().f(pattern[i]).d(.25));
    }
    right.add(stack.g( (ctx.tick / 10) * 100));
    right.add(new Sound().frequency(0).duration(.125));
  }

  ctx.tick = (ctx.tick + 1) % 10;
  ctx.song = new Stack().add(left).add(right);
  return ctx;
});
