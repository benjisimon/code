Audio.setup(function(ctx) {
  var left = [
    { type: 'frequency', value: Note.C, at: 0, duration: ctx.width }
  ];

  for(var i = 0; i < ctx.width; i += 1) {
    left.push({ type: 'gain', value: 1, at: i, duration: .80 });
  }

  var right = [ 
    { type: 'frequency', value: Note.A, at: 0, duration: ctx.width }
  ];

  for(var i = 0; i < (ctx.width * 4); i += 3) {
    right.push({ type: 'gain', value: .6, at: i, duration: .25 });
  }

  ctx.bpm     = ctx.bpm > 300 ? 120 : (ctx.bpm + 50);
  ctx.players = [ left, right ];
  
  console.log(ctx);
  return ctx;
});
