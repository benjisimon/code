Audio.setup(function(ctx) {
  var left = [
    { type: 'frequency', value: Note.C, at: 0, duration: ctx.width }
  ];

  for(var i = 0; i < ctx.width; i += 2) {
    left.push({ type: 'gain', value: 1, at: i, duration: 1 });
  }

  var right = [ 
    { type: 'frequency', value: Note.A, at: 0, duration: ctx.width }
  ];

  for(var i = 0; i < (ctx.width * 4); i++) {
    right.push({ type: 'gain', value: .6, at: i, duration: .25 });
  }

  ctx.players = [ left, right ];
  
  return ctx;
});
