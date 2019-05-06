/*
 * This is a javascript file used for implementing the various control associated with our canvas
 */

$(document).ready(function() {
  var canvas = $('#canvas').get(0);
  var ctx = canvas.getContext ? canvas.getContext('2d') : null;
  
  $(document).on('click', '.reset', function() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  });

  $(document).on('click', '.encrypt', function() {
    var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    console.log(imageData.data);
    for(var i = 0; i < imageData.data.length; i += 4) {
      var r = imageData.data[i];
      var g = imageData.data[i+1];
      var b = imageData.data[i+2];
      var a = imageData.data[i+3];

      if(a == 0) {
        continue;
      }

      if(a == 255 & (r == g == b == 0)) {
        var x  = i % canvas.width;
        var y  = Math.floor(i / 4 / canvas.width);
        console.log(x, y);
      }

    }
  });

});
