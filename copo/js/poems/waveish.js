Painter.animate(function(ctx) {
  if(ctx.drawing.isEmpty()) {
    ctx.tick = 0;
  }
  var w    = 20;
  var mark = new Drawing();
  mark.add((new Line())
           .scale(w)
           .translate({x: -1 * w * .5, y: 0}));

  mark.add((new Line())
           .scale(w)
           .translate({x: -1 * w * .5, y: 0}).rotate(90));

  var pic = new Drawing();
  for(i = 0; i < 100; i++) {
    pic.add(mark.copy()
            .translate({ x: i * (w * 1.2), 
                         y: Math.sin(i * deg2rad(ctx.tick % 360)) * 10 })
            .translate({ x: -500, y: 0 }));
  }
  
  ctx.tick++;
  ctx.drawing = pic;
  return ctx;
});


