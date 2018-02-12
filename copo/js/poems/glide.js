Audio.setup(function(ctx) {
  if(ctx.synths.length == 0) {
    ctx.tick = 0;
  } 

  if((ctx.tick % 3) == 0 && ctx.tick > 0) {
    ctx.width = 4;
    var adam = new Synth()
      .g(1, 0, ctx.width)
      .f({ value: Note.A, fadeTo: Note.C}, 0 , 1)
      .f({ value: Note.C, fadeTo: Note.D}, 1 , 1)
      .f({ value: Note.D, fadeTo: Note.C}, 2 , 2);
    ctx.synths = [ adam ];
    ctx.tick++;
  } else {
    ctx.width = 6;
    var adam = new Synth();
    for(var i = 0; i < ctx.width; i++) {
      adam.f({value: Note.C, fadeTo: Note.D, fadeOut: 0}, i, 3);
      adam.f({value: 0, fadeOut: .2}, i + .5, .5);
      adam.g(1, i, .25);
    }
    
    var brenda = new Synth();
    for(var i = 0; i < ctx.width; i++) {
      brenda.f({value: Note.octave(Note.C, -2), fadeTo: Note.D, fadeOut: .2}, i + .5, 1);
      brenda.f({value: 0}, i + 1, .5);
      brenda.g(1, i, 2);
    }
    
    var charlie = new Synth();
    for(var i = 0; i < ctx.width; i += (3 - (ctx.tick % 3))) {
      charlie.f({value: Note.C, fadeTo: Note.octave(Note.A, 2)}, i, .75);
      charlie.f({value: Note.A, fadeTo: Note.C}, i + .25, .125);
      charlie.f({value: Note.C}, i + 1, .2);
      charlie.g(.5, i, 1);
    }
    
    ctx.tick++;
    ctx.synths = [ adam, brenda, charlie ];
  }

  return ctx;

});
