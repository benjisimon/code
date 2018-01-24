Painter.animate(function(ctx) {
  if(ctx.drawing.isEmpty()) {
    ctx.gen = 0;
  } else if(ctx.gen > 10) {
    ctx.gen = 0;
    ctx.drawing = new Drawing();
  }
  
  var tri = new Drawing();
  tri.add(new Line().scale(10));

  tri.add(new Line().scale(10)
          .rotate(90));

  tri.add(new Line().scale(15)
          .rotate(135).translate({x: 10, y: 0}));

  ctx.drawing
    .rotate(ctx.gen * 20)
    .scale(Math.sin(deg2rad(ctx.gen * 15))* 2)
    .add(tri);

  ctx.gen++;
  return ctx;
});
