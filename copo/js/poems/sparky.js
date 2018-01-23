/*
 * This is a javascript file to experiment with animation
 */

function sparky() {
  var pic = new Drawing();
  var d = new Drawing();
  for(var i = 0; i < 4; i++) {
    var l = new Line();
    l.scale(10).rotate(90 * i);
    d.add(l);
  }
  var fudge = (Math.cos(now())) * 10;
  for(var j = 0; j < 360; j += 5) {
    d.translate({x: Math.sin(j) * 100 + fudge, y: Math.cos(j) * 100 + fudge}).rotate(fudge);
    pic.add(d.copy());
  }

  return pic;
}

Painter.animate(sparky);
