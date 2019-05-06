/*
 * This is a javascript file used for implementing the various control associated with our canvas
 */

$(document).ready(function() {

  function coinFlip() {
    return (Math.floor(Math.random() * 2) == 0);
  }

  function paintPixel(imageData, i) {
    imageData.data[i + 3] = 255;
  }

  var source = $('#source').get(0);
  var ctx = source.getContext ? source.getContext('2d') : null;
  
  $(document).on('click', '.reset', function() {
    $('#source').show();
    $('#share-1').hide();
    $('#share-2').hide();
    $('.decrypt').hide();
    $('.encrypt').show();

    ctx.clearRect(0, 0, source.width, source.height);
  });

  $(document).on('click', '.encrypt', function() {
    $('#source').hide();
    $('#share-1').show();
    $('#share-2').show();

    var share1 =  $('#share-1').get(0);
    var share2 =  $('#share-2').get(0);
    var ctx1   = share1.getContext('2d');
    var ctx2   = share2.getContext('2d');

    ctx1.clearRect(0, 0, ctx1.width, ctx1.height);
    ctx2.clearRect(0, 0, ctx2.width, ctx2.height);


    var srcData = ctx.getImageData(0, 0, source.width, source.height);
    console.log(ctx1);
    var share1Data = ctx1.getImageData(0, 0, share1.width, share1.height);
    var share2Data = ctx2.getImageData(0, 0, share2.width, share2.height);

    for(var x = 0; x < srcData.width; x += 2) {
      for(var y = 0; y < srcData.height; y++) {
        var i = ((y * srcData.width * 4) + (x * 4));
        var isBlack = srcData.data[i+3] == 255;
        if(isBlack) {
          if(coinFlip()) {
            paintPixel(share1Data, i);
            paintPixel(share2Data, i + 4);
          } else {
            paintPixel(share1Data, i + 4);
            paintPixel(share2Data, i);
          }
        } else {
          if(coinFlip()) {
            paintPixel(share1Data, i);
            paintPixel(share2Data, i);
          } else {
            paintPixel(share1Data, i + 4);
            paintPixel(share2Data, i + 4);
          }
        }
      }
    }

    ctx1.putImageData(share1Data, 0, 0);
    ctx2.putImageData(share2Data, 0, 0);

    $('.encrypt').hide();
    $('.decrypt').show();

  });

  $(document).on('click', '.decrypt', function() {
  });

});
