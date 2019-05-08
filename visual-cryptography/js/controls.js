/*
 * This is a javascript file used for implementing the various control associated with our canvas
 */

$(document).ready(function() {

  function packUi() {
    var padding     = 20;
    var canvasWidth = Math.floor($(window).width() - (padding * 2));
    var canvasHeight = (Math.floor($(window).height() / 2) - (padding * 5));

    $('canvas').attr('width', canvasWidth);
    $('canvas').attr('height', canvasHeight);
    $('.page').width(canvasWidth + 2);
    $('.bounds').height((canvasHeight * 2) + 40).width(canvasWidth);
    $('.bounds').attr('expanded-height', $('.bounds').height());
  }


  function coinFlip() {
    return (Math.floor(Math.random() * 2) == 0);
  }

  function paintPixel(imageData, i) {
    imageData.data[i + 3] = 255;
  }

  var source = $('#source').get(0);
  var ctx = source.getContext ? source.getContext('2d') : null;

  var share1 =  $('#share-1').get(0);
  var share2 =  $('#share-2').get(0);
  var ctx1   = share1.getContext('2d');
  var ctx2   = share2.getContext('2d');

  packUi();
  
  $(document).on('click', '.reset', function() {
    $('#source').show();
    $('.bounds').hide().height($('.bounds').attr('expanded-height'));
    $('.decrypt').hide();
    $('.encrypt').show();

    ctx.clearRect(0, 0, source.width, source.height);
    ctx1.clearRect(0, 0, source.width, source.height);
    ctx2.clearRect(0, 0, source.width, source.height);
  });

  $(document).on('click', '.encrypt', function() {
    $('#source').hide();
    $('.bounds').show();

    ctx1.clearRect(0, 0, ctx1.width, ctx1.height);
    ctx2.clearRect(0, 0, ctx2.width, ctx2.height);


    var srcData = ctx.getImageData(0, 0, source.width, source.height);
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
    $('.bounds').animate({height: $('#share-1').height() + 4}, {duration: 5000});
    $('.decrypt').hide();
  });

});
