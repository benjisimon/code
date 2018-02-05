Conductor.play(function(ctx) {
  var base = new Score();
  for(i = 1; i < 5; i++) {
    base.add(new Sound().frequency(100).gain((i * 10) / 2 / 100).duration(.5));
  }

  var fun = new Score();
  for(var i = 0; i < 10; i++) {
    var stack = new Stack();
    stack.add(new Sound().frequency(400).gain(.20).duration(.125));
    stack.add(new Sound().frequency(Math.sin(deg2rad(i * 50)) * 400).gain(.30).duration(.25));
    fun.add(stack);
  }

  var song = new Stack();
  song.add(base);
  song.add(fun);

  return { song: song };
});
