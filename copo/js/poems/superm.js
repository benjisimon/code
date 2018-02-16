Audio.setup(function(ctx) {
  if(ctx.synths.length == 0) {
    ctx.tick = 0;
  }

  var seq = [
    'E'    ,'E'    ,'E'    ,'C'    ,'E'    ,'G'    ,'G'    ,
    'C'    ,'G'    ,'E'    ,'A'    ,'B'    ,'As'   ,'A'    ,'G'    ,
    'E'    ,'G'    ,'A'    ,'F'    ,'G'    ,'E'    ,'C'    ,
    'D'    ,'B'    ,'C'    ,'G'    ,'E'    ,'A'    ,'B'    ,'As'    ,'A'    ,'G'    ,
    'E'    ,'G'    ,'A'    ,'F'    ,'G'    ,'E'    ,'C'    ,'D'    ,'B',
    'G'    ,'Fs'   ,'F'    ,'Ds'   ,'E'    ,'A'    ,'A'    ,'C'    ,'A'    , 
    'C'    ,'D'    ,'G'    ,'Fs'   ,'F'    ,'Ds'   ,'E'    ,'C'    ,
    'C'    ,'C'    ,'G'    ,'Fs'   ,'F'    ,'Ds'   ,'E'    ,'A'    ,'A'    ,'C'    ,
    'A'    ,'C'    ,'D'    ,'G'    ,'Fs'   ,'F'    ,'Ds'   ,'E'    ,'A'    ,
    'A'    ,'C'    ,'A'    ,'C'    ,'D'    ,'Cs'   ,'D'    ,'C'    ,'C'    ,'C'    ,
    'C'    ,'C'    ,'D'    ,'E'    ,'C'    ,'A'    ,'G'    ,'C'    ,'C'    ,'C'    ,
    'D'    ,'E'    ,'C'    ,'C'    ,'C'    ,'C'    ,'D'    ,'E'    ,'C'    ,'A'    ,
    'G'    ,'E'    ,'E'    ,'E'    ,'C'    ,'E'    ,'G'
  ];
  
  
  var notes = seq.slice(ctx.tick % ctx.width,
                        Math.min(ctx.tick + ctx.width, ctx.width));

  notes.forEach((n, i) => {
                  var freq = Note.octave(Note[n]);
                  ctx.synths.push(new Synth()
                                  .f({ value: freq }, i + .25, 1)
                                  .g({ value: 1, fadeOut: .5, fadeIn: .5 }, i, .75));
                });
  
  ctx.tick++;

  return ctx;
});
