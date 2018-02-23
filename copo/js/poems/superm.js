Audio.setup(function(ctx) {
  if(ctx.synths.length == 0) {
    ctx.tick = 0;
  }

  // Inspired from bandjs's example code:
  // https://github.com/meenie/band.js/tree/master/examples/mario-bros-overworld

  var t = 0;
  var synths = [];


  function schedule(duration, notes) {
    notes.forEach(n => synths.push(new Synth().g(1, t, duration).f(Note.parse(n), t, duration)));
    t += duration;
  }

  function q() { schedule(.25, Array.from(arguments));  }
  function h() { schedule(.5, Array.from(arguments));   }
  function w() { schedule(1, Array.from(arguments));   }

  // Right Hand
  t = 0;
  q('E5', 'F#4');
  q('E5', 'F#4');
  q();
  q('E5', 'F#4');

  q();
  q('C5', 'F#4');
  q('E5', 'F#4');
  q();

  q('G5', 'B4', 'G4');
  q();
  h();

  q('G4');
  q();
  h();

  q('C5', 'E4');
  q();
  q();
  q('G4', 'C4');


  q('C5', 'E4');
  q();
  q();
  q('G4', 'C4');

  h();
  q('E4', 'G3');
  q();

  q();
  q('A4', 'C4');
  q();
  q('B4', 'D4');

  q();
  q('Bb4', 'Db4');
  q('A4', 'C4');
  q();

  t = 0;
  q('D3');
  q('D3');
  q();
  q('D3');

  q();
  q('D3');
  q('D3');
  q();

  w();

  q('G3');
  q();
  h();

  q('G3');
  q();
  q();
  q('E3');


  h();
  q('C3');
  q();

  q();
  q('F3');
  q();
  q('G3');


  ctx.synths = synths;
  ctx.tick++;

  return ctx;
});
