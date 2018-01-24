// Like bursty, but keep the animations around
Painter.animate(function(ctx) {
  var pic = ctx.drawing;
  if(ctx.drawing.isEmpty() || ctx.history.length > 10) {
    ctx.tick = 0;
    ctx.history = [];
    ctx.current = new Drawing();
  } else if((ctx.tick % 360) == 0) {
    var randOffset = { x: rand(-250, 250),
                       y: rand(-250, 250) };
    ctx.history.push(ctx.current
                     .scale(.2)
                     .translate(randOffset));
    ctx.current = new Drawing();
  }
  ctx.tick += 15;

  ctx.current.add(new Line()
                  .scale(rand(1, 250))
                  .rotate(rand(1, 360)));

  ctx.drawing = new Drawing();
  for(var i = 0; i < ctx.history.length; i++) {
    ctx.drawing.add(ctx.history[i]);
  }
  ctx.drawing.add(ctx.current);
  return ctx;
});
