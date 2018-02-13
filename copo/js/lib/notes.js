/*
 * This is a javascript file used for working with note frequency values
 */
var Note = {};

(function() {
  Note.C = 261.626;
  Note.D = 293.664;
  Note.E = 329.628;
  Note.F = 349.228;
  Note.G = 391.995;
  Note.A = 440;
  Note.B = 493.883;
  Note.Cs = 277.18;
  Note.Df = 277.18;	
  Note.Ds = 311.13;
  Note.Ef = 311.13;	
  Note.Fs = 369.99;
  Note.Gf = 369.99;	
  Note.Gs = 415.3;
  Note.Af = 415.3;	
  Note.As = 466.16;
  Note.Bf = 466.16;	

  Note.SCALE_12 = [ 
    Note.C, Note.Cs, 
    Note.D, Note.Ds,
    Note.E,
    Note.F, Note.Fs,
    Note.G, Note.Gs,
    Note.A, Note.As,
    Note.B
  ];

  Note.SCALE_7 = [ 
    Note.C,
    Note.D,
    Note.E,
    Note.F,
    Note.G,
    Note.A,
    Note.B
  ];

  Note.octave = function(value, offset) {
    var val = value;
    for(var i = 0; i < Math.abs(offset); i++) {
      val = (offset > 0 ? val * 2 : val / 2);
    }
    return val;
  };

})();

