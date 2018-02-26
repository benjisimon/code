/*
 * This is a javascript file used for implementing a SoundLine - a sline.
 */

var Sline = {

  setup: function(viewport, startCoords, endCoords) {
    var config = Ui.config();
    var layer = new Concrete.Layer();
    layer.setSize(config.surface.width, config.surface.height);
    viewport.add(layer);
    
    var sctx = layer.scene.context;
    sctx.beginPath();
    sctx.strokeStyle = '#0000DD';
    sctx.lineWidth = 4;
    sctx.moveTo(startCoords.x, startCoords.y);
    sctx.lineTo(endCoords.x, endCoords.y);
    sctx.stroke();

    return {
      layer: layer,
      startCoords: startCoords,
      endCoords: endCoords
    };
  }

}
