/*
 * This is a javascript file used for powering our auto-ringtone page
 */

$(document).ready(function() {

  function textToCode(text) {
    var code      = "";
    var letters   = text.toUpperCase().split("");
    var encoder   = { 
      A: '.-',         B: '-...',       C: '-.-.',
      D: '-..',        E: '.',          F: '..-.',
      G: '--.',        H: '....',       I: '..',
      J: '.---',       K: '-.-',        L: '.-..',
      M: '--',         N: '-.',         O: '---',
      P: '.--.',       Q: '--.-',       R: '.-.',
      S: '...',        T: '-',          U: '..-',
      V: '...-',       W: '.--',        X: '-..-',
      Y: '-.--',       Z: '--..'
    };

    for(var i = 0; i < letters.length; i ++) {
      var c = letters[i];
      var e = encoder[c];
      if(e) {
        if(code != "") {
          code += " ";
        }
        code += e;
      }
    }

    return code;
  }
  

  function play(code) {
    var ctx = new (window.AudioContext || window.webkitAudioContext)();
    var osc = ctx.createOscillator();  
    osc.type = "sine";
    osc.frequency.value = 523;
    
    var gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);


    var tick = .25

    var clock = 0;
    for(var i = 0; i < code.length; i++) {
      var c = code[i];
      console.log('x', c, clock);
      if(c == ' ') {
        clock += (tick * 3);
      } else {
        var duration = tick * (c == '.' ? 1 : 3);
        gain.gain.linearRampToValueAtTime(1, ctx.currentTime + clock + duration);
        gain.gain.linearRampToValueAtTime(0, ctx.currentTime + clock + duration + tick);
        clock += tick;
      }
    }
    osc.start();
    osc.stop(ctx.currentTime + clock);
  }


  function go() {
    var input = $('input').val();
    var seed  = input.replace(/[^A-Za-z]/, '').toUpperCase().substring(0, 3);
    var seed  = seed ? seed : 'UKN';
    var code  = textToCode(seed);
    $('.feedback').html("Playing ringtone for <u>"+ input + "</u>: " + seed + " &raquo; <u>" + code + "</u>");
    play(code);
  }
  

  $(document).on('keyup', 'input', function(evt) {
    if(evt.keyCode == 13) {
      go();
    }
    return false;
  });

  $('input').focus();

});
