Painter.animate(function(ctx) {
  var pic = ctx.drawing;
  if(ctx.drawing.isEmpty()) {
    ctx.tick = 0;
  } else if((ctx.tick % 360) == 0) {
    pic = new Drawing();
  }
  ctx.tick++;

  pic.add(new Line()
          .scale(Math.floor(Math.random() * 250))
          .rotate(Math.floor(Math.random() * 360)));

  ctx.drawing = pic;
  return ctx;
});
