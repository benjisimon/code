/*
 * This is a javascript file used for implementing the simplest possible drawing
 */

var helloworld = function() {
  var d = new Drawing();
  for(var i = 0; i < 360; i += 45) {
    var l = new Line();
    l.scale(i + 1).rotate(i + 1);
    d.add(l);
  }
  return d;
};

Painter.draw(helloworld);
