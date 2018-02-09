/*
 * This is a javascript file used for being an alternative implementation of the music
 * API.  I want to leave music alone for historic purposes, but I'd like to offer
 * an alterantive API.
 */

function SynthEvent(type, value, at, duration) {
  this.type     = type;
  this.value    = value;
  this.at       = at;
  this.duration = duration;
}

SynthEvent.prototype.copy = function() {
  return new SynthEvent(this.type, this.value, this.at, this.duration);
}


function Synth() {
  this.events = [];
}

Synth.prototype.gain = function(value, at, duration) {
  this.events.push(new SynthEvent('gain', value, at, duration));
  return this;
}

Synth.prototype.frequency = function(value, at, duration) {
  this.events.push(new SynthEvent('frequency', value, at, duration));
  return this;
}

Synth.prototype.f = Synth.prototype.frequency;
Synth.prototype.g = Synth.prototype.gain;

Synth.prototype.copy = function() {
  var copy = new Synth();
  copy.events = this.events.map(e => e.copy());
  return copy;
}

var Audio = {

  play: function(ctx, generator) {
    if(Audio.status == 'playing') {
      ctx = generator(ctx);
      Audio.playback(ctx);
      var playAgainAt = (60 / ctx.bpm) * ctx.width * 1000;
      setTimeout(function() {
        Audio.play(ctx, generator);
      }, playAgainAt);
    }
  },

  playback: function(ctx) {
    var audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    var epoch    = audioCtx.currentTime;
    var at       = function(beatIndex) {
      return epoch + ((beatIndex * 60) / ctx.bpm);
    };

    var oscillators = ctx.synths.map(function(synth) {
        var oscillatorNode = audioCtx.createOscillator();
        var gainNode       = audioCtx.createGain();
        oscillatorNode.connect(gainNode);
        gainNode.connect(audioCtx.destination);
        oscillatorNode.frequency.value = 0;
        gainNode.gain.value            = 0;
        
        synth.events.forEach(function(evt) {
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
    var defaultFactor  = 1/3 * (secPerDuration / 20);

    evt.value      = (isNaN(parseFloat(evt.value)) ? 
                      evt.value  : { value: evt.value, fadeIn: defaultFactor, fadeOut:  defaultFactor });

    node.setTargetAtTime(evt.value.value, at(evt.at), evt.value.fadeIn);
    node.setTargetAtTime(0.0001, at(evt.at + evt.duration), evt.value.fadeOut);
  },

  setup: function(generator) {
    if($('#play-music').length == 0) {
      $('#poem').append('<input id="play-music" type="button" action="play" value="Listen!"/>');
      $('#play-music').click(function() {
        if($(this).attr('action') == 'play') {
          $(this).attr('action', 'stop').val("Stop");
          Audio.status = 'playing';
          var ctx = { synths: [], width: 12, bpm: 120 };
          Audio.play(ctx, generator);
        } else {
          Audio.status = 'stop';
          $(this).attr('action', 'play').val("Listen!");        
        }
      });
    }
  }
      
};