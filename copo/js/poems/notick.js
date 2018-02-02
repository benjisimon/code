Conductor.play(function(ctx) {
  if(ctx.song.isEmpty()) {
    ctx.tick = 0;
  }
  
  var left = new Score();
  for(var i = 0; i < 4; i++) {
    left.add(new Sound().frequency(100).duration(.25));
    left.add(new Sound().frequency(0).duration(.25));
  }

  var right = new Score();
  var pattern = [350, 380, 400 ] ;
  for(var i = 0; i < 4; i++) {
    right.add(new Sound().frequency(pattern[i % pattern.length]).duration(.125));
    right.add(new Sound().frequency(0).duration(.125));
  }
  
  var mid = new Score();
  if(ctx.tick > 4) {
    mid.add(new Sound().frequency(120).duration(1));
  }

  ctx.tick = ctx.tick % 20;
  ctx.song = new Stack().add(left).add(right).add(mid);
  return ctx;
});
