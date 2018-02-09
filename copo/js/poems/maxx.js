Audio.setup(function(ctx) {
  if(ctx.tick === undefined) {
    ctx.tick = 0;
  }

  var note = Note.C;

  note += ((ctx.tick % 4) * 100);


  var alan = new Synth().f(Note.octave(note, -1), 0, ctx.width);
  for(var i = 1; i < ctx.width; i +=3) {
    alan.g({ value: .2, fadeIn: .2, fadeOut: .02 }, i, 1);
  }

  var bernie = new Synth().f(Note.octave(note, 0), 0, ctx.width);
  for(var i = 2; i < ctx.width; i += 1) {
    bernie.g({ value: .3, fadeIn: .01, fadeOut: .02 }, i, .25);
  }

  
  var charlie = new Synth().f(Note.octave(note, 1), 0, ctx.width);
  for(var i = 3; i < ctx.width; i += 3) {
    charlie.g({ value: .8, fadeIn: .03, fadeOut: .02 }, i, .125);
    charlie.g({ value: .8, fadeIn: .03, fadeOut: .02 }, i + .5, .125);
  }

  ctx.tick++;
  ctx.synths = [ alan, bernie, charlie ];
  return ctx;
});
