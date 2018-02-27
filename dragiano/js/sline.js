/*
 * This is a javascript file used for implementing a SoundLine - a sline.
 */

var Sline = {

  setup: function(viewport, startCoords, endCoords) {
    if(startCoords.x > endCoords.x) {
      var swapCoords = endCoords;
      startCoords = endCoords;
      endCoords   = swapCoords;
    }

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
  },

  teardown: function(sline) {
    sline.layer.destroy();
    if(sline.nodes) {
      sline.nodes.oscillator.stop();
    }
  },

  schedule: function(leftX, rightX, sline, at) {
    if(sline.startCoords.x >= leftX && sline.startCoords.x <= rightX) {
        var oscillatorNode = Ui.audioCtx.createOscillator();
        var gainNode       = Ui.audioCtx.createGain();

        oscillatorNode.connect(gainNode);
        gainNode.connect(Ui.audioCtx.destination);
        oscillatorNode.frequency.value = Sline.yToFreq(sline.startCoords.y);
        oscillatorNode.start(at(sline.startCoords.x));
        oscillatorNode.frequency.linearRampToValueAtTime(Sline.yToFreq(sline.endCoords.y), at(sline.endCoords.x));
        oscillatorNode.stop(at(sline.endCoords.x) + .01);
        gainNode.gain.setTargetAtTime(0, at(sline.endCoords.x) + 0.001, 0.015)
        gainNode.gain.value            = 1;
        sline.nodes = { gain: gainNode, oscillator: oscillatorNode };
        return sline;
    }
  },

  yToFreq: function(y) {
    var config = Ui.config();
    var percent = y / config.surface.height;
    return config.freq.upper - ((config.freq.upper - config.freq.lower) * percent);
  }

}
