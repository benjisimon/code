/*
 * This is a javascript file used for implementing the various control associated with our canvas
 */

$(document).ready(function() {
  var canvas = $('#canvas').get(0);
  var ctx = canvas.getContext ? canvas.getContext('2d') : null;
  
  $(document).on('click', '.reset', function() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  });

});
