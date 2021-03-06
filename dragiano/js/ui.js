/*
 * This is a javascript file used for working with the instrument UI
 */


var Ui = {
  running: false,
  slines: [],
  audioCtx: new (window.AudioContext || window.webkitAudioContext),
  
  config: function() {
    return { surface: { width: $('body').width(),
                        height:  $(document).innerHeight() - $('.controls').innerHeight() - 10 },
             bars: { count: 12, width: 4 },
             freq: { lower: 65.40, upper: 1864.64 } }
  },

  makeBars: function(viewport) {
    var config = Ui.config();
    var grid = new Concrete.Layer();    
    var gridGap =  (config.surface.width / config.bars.count);

    grid.setSize(config.surface.width, config.surface.height);
    viewport.add(grid);

    for(var i = 0; i < config.bars.count; i++) {
      grid.scene.context.beginPath();
      grid.scene.context.strokeStyle = '#650000';
      grid.scene.context.lineWidth = config.bars.width;
      grid.scene.context.moveTo(gridGap * i, 0);
      grid.scene.context.lineTo(gridGap * i, config.surface.height);
      grid.scene.context.stroke();
      viewport.render();
    }

    return grid;
  },

  makeMarker: function(viewport, index) {
    var config = Ui.config();
    var marker = new Concrete.Layer();
    viewport.add(marker);

    var gridGap =  (config.surface.width / config.bars.count);
    marker.setSize(config.surface.width, config.surface.height);
    marker.scene.context.beginPath();
    marker.scene.context.strokeStyle = '#FF6C00';
    marker.scene.context.lineWidth = config.bars.width
    marker.scene.context.moveTo(gridGap * index, 0);
    marker.scene.context.lineTo(gridGap * index, config.surface.height);
    marker.scene.context.stroke();

    return marker;
  },

  advanceMarker: function() {
    var config = Ui.config();
    Ui.marker.index = (Ui.marker.index + 1) % config.bars.count;
    Ui.marker.layer.destroy();
    Ui.marker.layer = Ui.makeMarker(Ui.viewport, Ui.marker.index);
    Ui.viewport.render();
  },

  pack: function() {
    Ui.viewport = new Concrete.Viewport({
      width: Ui.config().surface.width,
      height: Ui.config().surface.height,
      container: $('.surface').get(0)
    });

    Ui.makeBars(Ui.viewport);
    Ui.marker = { index: 0, layer: Ui.makeMarker(Ui.viewport, 0), timer: null };

    return true;
  },

  press: function(coords) {
    var config = Ui.config();

    var hit = Ui.viewport.getIntersection(coords.x, coords.y);
    if(Ui.startPoint) {
      Ui.startPoint.layer.destroy();
      Ui.slines.push(Sline.setup(Ui.viewport, Ui.startPoint.coords, coords));
      Ui.viewport.render();
      Ui.startPoint = null;
    } else if(hit) {
      Ui.slines = Ui.slines.filter(sline => {
                                     if(hit == sline.key) {
                                       Sline.teardown(sline);
                                       return false;
                                     } else {
                                       return true;
                                     }
                                   });
      Ui.viewport.render();
    } else {
      Ui.startPoint = { layer:  new Concrete.Layer(), coords: coords };
      Ui.viewport.add(Ui.startPoint.layer);
      Ui.startPoint.layer.setSize(config.surface.width, config.surface.height);
      Ui.startPoint.layer.scene.context.fillStyle = '#00DD00';
      Ui.startPoint.layer.scene.context.fillRect(coords.x - 5, coords.y - 5, 10, 10);
      Ui.viewport.render();
    }

  },

  start: function() {
    var secPerBeat    = (60 / parseInt($('.bpm').val()));
    var millisPerBeat = secPerBeat * 1000;
    var config        = Ui.config();
    var gridGap       =  (config.surface.width / config.bars.count);
    Ui.running        = true;

    Ui.marker.timer = setInterval(() => {
                                    if(Ui.running) {
                                      var base = { t0: Ui.audioCtx.currentTime,
                                                   x0: Ui.marker.index * gridGap,
                                                   secPerPixel: secPerBeat / gridGap };
                                      Ui.slines.forEach(sline => {
                                                          Sline.schedule(Ui.marker.index * gridGap,
                                                                         (Ui.marker.index+1) * gridGap,
                                                                         sline,
                                                                         function(x) {
                                                                           return base.t0 + ((x - base.x0) * base.secPerPixel);
                                                                         });
                                                        });
                                      Ui.advanceMarker();
                                    }
                                  }, millisPerBeat);
    return true;
  },

  stop: function() {
    Ui.running = false;
    if(Ui.marker.timer) {
      clearInterval(Ui.marker.timer);
    }
  }

};

$(document).ready(function() {
  Ui.pack();
});

$(window).on('resize', Ui.pack);

$(document).on('click', '.surface', function(evt) {
  Ui.press({x: evt.pageX - $('.surface').offset().left, 
            y: evt.pageY - $('.surface').offset().top});
});

$(document).on('click', '.play', function() {
  if($(this).val() == 'Play') {
    Ui.start();
    $(this).val("Stop");
  } else {
    Ui.stop();
    $(this).val("Play");
  }
});

$(document).on('click', '.undo', function() {
  if(Ui.slines.length > 0) {
    Sline.teardown(Ui.slines.pop());
  }
  Ui.viewport.render();
});

$(document).on('click', '.clear', function() {
  while(Ui.slines.length > 0) {
    Sline.teardown(Ui.slines.pop());
  }
  Ui.viewport.render();
});
