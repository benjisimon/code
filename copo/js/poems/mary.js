Conductor.play(function(ctx) {
  var E = 329.628;
  var D = 293.665;
  var C = 440;
  var G = 391.995;

  if(ctx.song.isEmpty()) {
    ctx.tick = 0;
  }

  var mary = [E,D,C,D,E,E,E,
              D,D,D,E,G,G,
              E,D,C,D,E,E,E,
              E,D,D,E,D,C];
  
  var left = new Score();
  for(var i = 0; i < mary.length; i++) {
    left.add(new Sound().frequency(mary[i]).duration(.25).gain((((ctx.tick % 4)+1) / 5) * 100));
    left.add(new Sound().frequency(0).duration(.25));
  }

  ctx.song = new Stack().add(left);
  ctx.tick++;
  return ctx;
});
