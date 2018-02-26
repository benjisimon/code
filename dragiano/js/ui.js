/*
 * This is a javascript file used for working with the instrument UI
 */


var Ui = {
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

  makeMarker: function(viewport) {
    var config = Ui.config();
    var marker = new Concrete.Layer();
    viewport.add(marker);

    marker.setSize(config.bars.width, config.surface.height);
    marker.scene.context.beginPath();
    marker.scene.context.strokeStyle = '#FF6C00';
    marker.scene.context.lineWidth = config.bars.width
    marker.scene.context.moveTo(0, 0);
    marker.scene.context.lineTo(0, config.surface.height);
    marker.scene.context.stroke();
    viewport.render();

    return marker;
  },

  pack: function() {
    Ui.viewport = new Concrete.Viewport({
      width: Ui.config().surface.width,
      height: Ui.config().surface.height,
      container: $('.surface').get(0)
    });

    Ui.makeBars(Ui.viewport);
    Ui.makeMarker(Ui.viewport);

    return true;
  },

  start: function() {
    
    },

  stop: function() {

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
