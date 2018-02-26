/*
 * This is a javascript file used for implementing a SoundLine - a sline.
 */

var Sline = {

  setup: function(viewport, startCoords, endCoords) {
    var config = Ui.config();
    var layer = new Concrete.Layer();
    var key   = [startCoords.x, startCoords.y, endCoords.x, endCoords.y ].join(':');
    layer.setSize(config.surface.width, config.surface.height);
    viewport.add(layer);
    
    var sctx = layer.scene.context;
    sctx.beginPath();
    sctx.strokeStyle = '#0000DD';
    sctx.lineWidth = 4;
    sctx.moveTo(startCoords.x, startCoords.y);
    sctx.lineTo(endCoords.x, endCoords.y);
    sctx.stroke();

    var hctx = layer.hit.context;
    hctx.beginPath();
    hctx.moveTo(startCoords.x, startCoords.y);
    hctx.lineTo(endCoords.x, endCoords.y);
    hctx.lineStyle = layer.hit.getColorFromKey(key);
    hctx.lineWidth = 4;
    hctx.stroke();

    return {
      key: key,
      layer: layer,
      startCoords: startCoords,
      endCoords: endCoords
    };
  }

}
