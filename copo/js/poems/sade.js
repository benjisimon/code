Painter.animate(function(ctx) {
  if(ctx.drawing.isEmpty()) {
    ctx.tick = 0;
  }
  var pic = new Drawing();
  for(var i = 0; i < 50; i++) {
    pic.add(new Line()
            .scale(20)
            .rotate((i * 10) + (ctx.tick*10))
            .translate({ x: i * 10, y: 0}));
  }
  pic.translate({ x: -250, y: 0 });
  ctx.tick++;
  ctx.drawing = pic;
  return ctx;
});
