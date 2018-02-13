/*
 * This is a javascript file used for implementing a music composition environment
 * that's similar to drawing.js
 */

function Sound() {
  this.values = {
    frequency: 261.626,
    gain:      1,
    duration:  1
  };
}

function Stack() {
  this.items = [];
}

function Score() {
  this.items = [];
}

Conductor = {};

(function() {
  function accessor(prop) {
    return function() {
      if(arguments.length == 0) {
        return this.values[prop];
      } else if(arguments.length == 1) {
        this.values[prop] = arguments[0];
        return this;
      } else {
        switch(arguments[0]) {
        case '=':
          this.values[prop] = arguments[1];
          break;
        case '+':
          this.values[prop] += arguments[1];
          break;
        case '-':
          this.values[prop] -= arguments[1];
          break;
        case '*':
          this.values[prop] *= arguments[1];
          break;
        case '/':
          this.values[prop] /= arguments[1];
          break;
        default:
          throw new Error("Unknown operator: " + arguments[0]);
        }
        return this;
      }
    }
  }

  function maxReduce(carry, f) { 
    return Math.max(carry, f); 
  }

  function sumReduce(carry, f) {
    return carry + f;
  }

  Sound.prototype.frequency = accessor('frequency');
  Sound.prototype.gain = accessor('gain');
  Sound.prototype.duration = accessor('duration');
 
  Sound.prototype.copy = function() {
    var s       = new Sound();
    s.frequency(this.frequency);
    s.gain(this.gain);
    s.duration(this.duration);
  }

  Sound.prototype.schedule = function(t, scribe) {
    scribe.schedule(t, 
                    this.values.frequency,
                    this.values.gain,
                    this.values.duration);
    return t + this.values.duration;
  }


  function itemAccessor(prop, reduceFn) {
   return function() {
     if(arguments.length == 0) {
       return this.items.map(item => item[prop]()).reduce(reduceFn, 0);
     } else {
       for(var i = 0; i < this.items.length; i++) {
         this.items[i][prop].apply(this.items[i], arguments);
       }
     }
     return this;
   }
  }

  function itemCopy(generator) {
    return function() {
      var copy = generator();
      copy.items = [];
      for(var i = 0; i < this.items.length; i++) {
        copy.items.push(this.items[i]);
      }
      return copy;
    }
  }

  function itemAdd() {
    return function(x) {
      this.items.push(x);
      return this;
    }
  }

  function itemIsEmpty() {
    return function() {
      return this.items.length == 0;
    }
  }


  
  Stack.prototype.frequency = itemAccessor('frequency', maxReduce);
  Stack.prototype.gain      = itemAccessor('gain', maxReduce);
  Stack.prototype.duration  = itemAccessor('duration', maxReduce);
  Stack.prototype.copy      = itemCopy(() => new Stack());
  Stack.prototype.add       = itemAdd();
  Stack.prototype.isEmpty   = itemIsEmpty();
  Stack.prototype.schedule  = function(t, scheduler) {
    var nextT = t;
    for(var i = 0; i < this.items.length; i++) {
      nextT = Math.max(nextT, this.items[i].schedule(t, scheduler));
    }
    return nextT;
  };

  Score.prototype.frequency = itemAccessor('frequency', sumReduce);
  Score.prototype.gain      = itemAccessor('gain', sumReduce);
  Score.prototype.duration  = itemAccessor('duration', sumReduce);
  Score.prototype.copy      = itemCopy(() => new Score());
  Score.prototype.add       = itemAdd();
  Score.prototype.isEmpty   = itemIsEmpty();
  Score.prototype.schedule  = function(t, scheduler) {
    for(var i = 0; i < this.items.length; i++) {
      t = this.items[i].schedule(t, scheduler);
    }
    return t;
  };

  Conductor.init = function() {
    if($('#play-music').length == 0) {
      $('#poem').append('<input id="play-music" type="button" action="play" value="Listen!"/>');
    }
  }

  Conductor.play = function(generator) {
    Conductor.init();
    var audioCtx = new (window.AudioContext || window.webkitAudioContext)();


    $('#play-music').click(function() {
      if($(this).attr('action') == 'play') {
        $(this).attr('action', 'stop').val("Stop");
        Conductor.status = 'playing';
        Conductor.setup(audioCtx, generator, { song: new Score() });
      } else {
        Conductor.status = 'stop';
        $(this).attr('action', 'play').val("Listen!");        
        
      }
    });
  };

  Conductor.setup = function(audioCtx, generator, ctx) {
    var ctx   = generator(ctx);
    var end   = ctx.song.schedule(audioCtx.currentTime, { schedule: function(t, frequency, gain, duration) {
      if(frequency > 0 && gain > 0 && duration > 0 && Conductor.status == 'playing') {
        var oscillatorNode = audioCtx.createOscillator();
        var gainNode       = audioCtx.createGain();
        oscillatorNode.connect(gainNode);
        gainNode.connect(audioCtx.destination);
        oscillatorNode.frequency.value = frequency;
        gainNode.gain.value = gain;
        oscillatorNode.start(t);
        gainNode.gain.exponentialRampToValueAtTime(gainNode.gain.value, t + Math.min(.001, duration / 32));
        gainNode.gain.exponentialRampToValueAtTime(0.0001, t + duration + 0.03);
        oscillatorNode.stop(t + duration + 3);
      }
    }});

    setTimeout(function() {
      if(Conductor.status == 'playing') {
        Conductor.setup(audioCtx, generator, ctx);
      }
    }, (end - audioCtx.currentTime) * 1000)
  }

  new Stack(); new Score(); new Sound();

  [Sound.prototype, Score.prototype, Stack.prototype ].forEach(function(p) {
    p.f = p.frequency;
    p.g = p.gain;
    p.d = p.duration;
  });

})();
