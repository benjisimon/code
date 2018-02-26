/*
 * This is a javascript file used for working with the instrument UI
 */


var Ui = {
  running: false,
  
  config: function() {
    return { surface: { width: $('body').width(),
                        height:  $(document).innerHeight() - $('.controls').innerHeight() - 10 },
             bars: { count: 12, width: 4 }
      };
  },

  makeBars: function(viewport) {
    var config = Ui.config();
    var grid = new Concrete.Layer();    
    var gridGap =  (config.surface.width / config.bars.count);

    grid.setSize(config.surface.width, config.surface.height);
    viewport.add(grid);

    for(var i = 0; i < config.bars.count; i++) {
      grid.scene.context.beginPath();
      grid.scene.context.strokeStyle = '#850000';
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

  start: function() {
    var millisPerBeat = (60 / parseInt($('.bpm').val())) * 1000;
    Ui.running = true;
    Ui.marker.timer = setInterval(() => {
                                    if(Ui.running) {
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

$(document).on('click', '.go', function() {
  if($(this).val() == 'Go') {
    Ui.start();
    $(this).val("Stop");
  } else {
    Ui.stop();
    $(this).val("Go");
  }
});
