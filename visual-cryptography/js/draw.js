/*
 * This is a javascript file used for implementing basic canvas drawing
 */

$(document).ready(function() {
  var canvas = $('#source').get(0);
  var ctx = canvas.getContext ? canvas.getContext('2d') : null;

  function drawLine(from, to) {
    if(ctx) {
      ctx.beginPath();
      ctx.lineWidth = 20;
      ctx.lineCap   = 'round';
      ctx.moveTo(from.x, from.y);
      ctx.lineTo(to.x, to.y);
      ctx.stroke();
    }
  }

  var prev = { x: null, y: null };
  
  $(document).on('touchstart mousedown', '#source', function(evt) {
    evt.preventDefault();
    prev.x = evt.clientX;
    prev.y = evt.clientY;
  });

  $(document).on('mousemove', '#source', function(evt) {
    if(evt.which == 1) {
      curr = { x: evt.clientX, y: evt.clientY };
      drawLine(prev, curr);
      prev = curr;
    }
  });
  
  $(document).on('touchmove', '#source', function(evt) {
    evt.preventDefault();
    var touch = evt.originalEvent.touches[0] || evt.originalEvent.changedTouches[0];

    var elm = $(this).offset();
    var x = touch.pageX - elm.left;
    var y = touch.pageY - elm.top;
    
    curr = { x: x, y: y };
    drawLine(prev, curr);
    prev = curr;
  });
  
});
