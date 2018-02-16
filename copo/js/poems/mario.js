Conductor.play(function(ctx) {  
  var song = new Stack();
  
  var notes = [ Note.C, Note.G, Note.octave(Note.C, -1), Note.A, Note.G ];

  for(i = 0; i < 5; i++) {
    song.add(new Score()
             .add(new Sound().d(i).f(0))
             .add(new Sound().d(5-i).f(notes[i])));
  }


  ctx.song = song;
  ctx.bpm = 80;
  return ctx;
});
