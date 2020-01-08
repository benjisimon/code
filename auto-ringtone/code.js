/*
 * This is a javascript file used for powering our auto-ringtone page
 */

$(document).ready(function() {

  var tick = 120;;

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

    return code.split('');
  }

  // Inspired by:
  // https://modernweb.com/audio-synthesis-in-javascript/
  function tone(units) {
    var ctx = new (window.AudioContext || window.webkitAudioContext)();
    var osc = ctx.createOscillator();  
    var duration = units * tick;
    var attack = 1;
    var gain = ctx.createGain();
    
    gain.connect(ctx.destination);
    gain.gain.setValueAtTime(0, ctx.currentTime);
    gain.gain.linearRampToValueAtTime(1, ctx.currentTime + (attack / 1000));
    gain.gain.linearRampToValueAtTime(0, ctx.currentTime + (duration / 1000));

    osc.type = "sine";
    osc.frequency.value = units == 1 ? 440.000 : 880.0000;
    osc.connect(gain);

    osc.start();
    setTimeout(() => {
      osc.stop();
      osc.disconnect(gain);
      gain.disconnect(ctx.destination);
    }, duration);
  }

  function play(code) {
    if(code.length > 0) {
      var c = code.shift();
      if(c == ' ') {
        var snooze = tick;
      } else {
        var units = (c == '.' ? 1 : 3)
        var snooze = tick * units;
        tone(units);
      }
      snooze += tick;
      setTimeout(() => {
        play(code);
      }, snooze);
    }
  }


  function go() {
    var input = $('input').val();
    var seed  = input.replace(/[^A-Za-z]/, '').toUpperCase().substring(0, 6);
    var seed  = seed ? seed : 'UKN';
    var code  = textToCode(seed);
    $('.feedback').html("Playing ringtone for <u>"+ input + "</u>: " + seed + " &raquo; <u>" + code.join('') + "</u>");
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
