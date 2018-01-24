/*
 * This is a javascript file to experiment with circle
 */

function circle(ctx) {
  var pic = new Drawing();
  var d = new Drawing();
  for(var i = 0; i < 4; i++) {
    var l = new Line();
    l.scale(10).rotate(90 * i);
    d.add(l);
  }
  for(var j = 0; j < 360; j += 5) {
    d.translate({x: Math.sin(j) * 100, y: Math.cos(j) * 100});
    pic.add(d.copy());
  }

  return { drawing: pic }
}

Painter.draw(circle);
