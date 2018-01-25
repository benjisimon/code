Painter.animate(function(ctx) {
  if(ctx.drawing.isEmpty()) {
    ctx.tick = 4;
  } else if(ctx.tick > 100) {
    ctx.tick = 4;
  }
  var seg = (new Line().scale(5).rotate(90));

  var pic = new Drawing();

  for(var i = 0; i < ctx.tick; i++) {
    var s = (4 / ctx.tick) * 100;
    var d = (4 / ctx.tick) * 90;
    pic.add(seg.copy().scale(s).translate({x: 0, y: s}).translate({ x: s, y: 0}).rotate(i * d));
  }
  
  ctx.drawing = pic;
  ctx.tick++;
  return ctx;
});
