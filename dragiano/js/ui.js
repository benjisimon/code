/*
 * This is a javascript file used for working with the instrument UI
 */


var Ui = {
  config: function() {
    return { surface: { width: $('body').width(),
                        height:  $(document).innerHeight() - $('.controls').innerHeight() - 10 },
             beats: 12l };
  },

  makeGrid: function(viewport) {
    var config = Ui.config();
    var grid = new Concrete.Layer();    
    var gridGap =  config.surface.width / config.beats;

    grid.setSize(config.surface.width, config.surface.height);
    viewport.add(grid);

    for(var i = 1; i < config.beats; i++) {
      grid.scene.context.beginPath();
      grid.scene.context.strokeStyle = '#850000';
      grid.scene.context.lineWidth = 4;
      grid.scene.context.moveTo(gridGap * i, 0);
      grid.scene.context.lineTo(gridGap * i, config.surface.height);
      grid.scene.context.stroke();
      viewport.render();
    }

    window.xx = grid;
    return grid;
  },

  pack: function() {
    Ui.viewport = new Concrete.Viewport({
      width: Ui.config().surface.width,
      height: Ui.config().surface.height,
      container: $('.surface').get(0)
    });

    Ui.makeGrid(Ui.viewport);

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
