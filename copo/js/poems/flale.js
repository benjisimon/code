Conductor.play(function(ctx) {
  ctx.tick = ctx.tick == undefined ? 0 : ctx.tick % 5;
  var scale = new Score();
  var C=261.63, D=293.664, E=329.628, F=349.228, G=391.995, A=440, B=493.883;
  var notes = [C, D, E, F, G, A, B ];
  var notes = notes.slice(Math.min((ctx.tick % notes.length), (ctx.tick % notes.length) + 3),
                          Math.max((ctx.tick % notes.length), (ctx.tick % notes.length) + 3));
  var d = .3;

  var song = new Stack();
  var base = new Score();
  for(var i = 0; i < ctx.tick; i++) {
    var layer = new Score();
    layer.add(new Sound().frequency(0).duration(d * i));
    notes.forEach(n => layer.add(new Sound().frequency(n / Math.pow(2,i)).duration(d)).add(new Sound().frequency(0).duration(d)));
    song.add(layer);
    base.add(new Sound().frequency(C / Math.pow(2, 3)).duration(.4));
  }
  song.add(base);

  ctx.tick++;
  ctx.song = song;
  return ctx;
});
