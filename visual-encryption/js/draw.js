/*
 * This is a javascript file used for implementing basic canvas drawing
 */

$(document).ready(function() {
  var canvas = $('#canvas').get(0);
  var ctx = canvas.getContext ? canvas.getContext('2d') : null;
  if(ctx) {
    ctx.lineWidth = 20;
    ctx.lineCap   = 'round';
    ctx.fillStyle = '#000';
  }

  function drawLine(from, to) {
    if(ctx) {
      ctx.beginPath();
      ctx.moveTo(from.x, from.y);
      ctx.lineTo(to.x, to.y);
      ctx.stroke();
    }
  }

  var prev = { x: null, y: null };
  
  $(document).on('mousedown', '#canvas', function(evt) {
    prev.x = evt.offsetX;
    prev.y = evt.offsetY;
  });

  $(document).on('mousemove', '#canvas', function(evt) {
    if(evt.which == 1) {
      curr = { x: evt.offsetX, y: evt.offsetY };
      drawLine(prev, curr);
      prev = curr;
    }
  });
  
});
