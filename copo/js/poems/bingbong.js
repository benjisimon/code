Conductor.play(function(ctx) {
  var left = new Score();
  for(var f = 100; f < 800; f += 100) {
    left.add(new Sound().frequency(f));
    left.add(new Sound().frequency(0).duration('/', 2));
  }

  var right = new Score();
  for(var i = 0; i < 9; i++) {
    right.add(new Sound().frequency(200).duration(.25));
    right.add(new Sound().frequency(0).duration(.5));
    right.add(new Sound().frequency(400).duration(.25));
  }
  
  return { score: new Stack().add(left).add(right) };
});
