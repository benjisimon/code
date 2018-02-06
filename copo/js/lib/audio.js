/*
 * This is a javascript file used for being an alternative implementation of the music
 * API.  I want to leave music alone for historic purposes, but I'd like to offer
 * an alterantive API.
 */

var Audio = {

  play: function(generator) {
    var ctx = { players: [], tick: 0, width: 12, bpm: 120 }

    ctx = generator(ctx);
    Audio.playback(ctx);

  },

  playback: function(ctx) {
    var audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    var epoch    = audioCtx.currentTime;
    var at       = function(beatIndex) {
      return epoch + ((beatIndex * 60) / ctx.bpm);
    };

    var oscillators = ctx.players.map(function(player) {
        var oscillatorNode = audioCtx.createOscillator();
        var gainNode       = audioCtx.createGain();
        oscillatorNode.connect(gainNode);
        gainNode.connect(audioCtx.destination);
        oscillatorNode.frequency.value = 0;
        gainNode.gain.value            = 0;
        
        player.forEach(function(evt) {
          switch(evt.type) {
          case 'frequency':
            Audio.scheduleChange(oscillatorNode.frequency, evt, at, ctx);
            break;
          case 'gain':
            Audio.scheduleChange(gainNode.gain, evt, at, ctx);
            break;
          default:
            throw new Error("Unknown oscillator event type: ", evt);
          }
        });

        return oscillatorNode;
      });

    oscillators.forEach(function(osc) {
      osc.start(epoch);
    });
  },

  scheduleChange: function(node, evt, at, ctx) {
    var secPerDuration = (60 / ctx.bpm) * evt.duration;
    var buildAt  = 1/3 * (secPerDuration / 20);
    console.log("ZZ", evt, buildAt, secPerDuration);
    node.setTargetAtTime(evt.value, at(evt.at), buildAt);
    node.setTargetAtTime(0.0001, at(evt.at + evt.duration), buildAt);
  },

  setup: function(generator) {
    if($('#play-music').length == 0) {
      $('#poem').append('<input id="play-music" type="button" action="play" value="Listen!"/>');
      $('#play-music').click(function() {
        if($(this).attr('action') == 'play') {
          $(this).attr('action', 'stop').val("Stop");
          Audio.status = 'playing';
          Audio.play(generator);
        } else {
          Audio.status = 'stop';
          $(this).attr('action', 'play').val("Listen!");        
        }
      });
    }
  }
      
};
