/*
 * This is a javascript file used for implementing the rendering of the map
 * and other code.
 */

function renderMap(points) {
  var padding = 20;
  var size = Math.min($('.map').width() - 52, $('.map').height() - 12);

  $('canvas').attr('width', size);
  $('canvas').attr('height', size);

  var styles = [
    'rgb(200, 0, 0)',
    'rgb(0, 200, 0)',
    'rgb(0, 0, 200)',
    'rgb(200, 200, 0)',
    'rgb(200, 0, 200)',
    'rgb(0, 200, 200)'
  ]

  var ctx = $('canvas').get(0).getContext('2d');


  var bounds = {
    width: size - (padding * 2),
    height: size - (padding * 2),
    padding: padding
  };

  function posn(p) {
    var xPerc = (p.x / p.max_x);
    var yPerc = (p.y / p.max_y);

    var x = Math.round(bounds.width * xPerc) + bounds.padding;
    var y = bounds.height - Math.round(bounds.height * yPerc) + bounds.padding;

    console.log(p, [xPerc, yPerc,] , [x, y], bounds);

    return { x: x, y: y };
  }

  ctx.font = "12px Arial";
  ctx.beginPath();

  var points = points.map(p => {
    p.posn = posn(p);
    return p;
  });

  points.forEach(function(p, i) {
    ctx.fillStyle = styles[i % styles.length];
    ctx.strokeStyle = styles[i % styles.length];

    if(i > 0) {
      ctx.beginPath();
      ctx.moveTo(points[i-1].posn.x, points[i-1].posn.y);
      ctx.lineTo(p.posn.x, p.posn.y);
      ctx.stroke();
    } 

    ctx.beginPath();

    ctx.fillText("#" + i + ": " + p.notes, p.posn.x + 2, p.posn.y - 5);
    ctx.arc(p.posn.x, p.posn.y, 4, 0, Math.PI * 2, true);
    ctx.fill();
  });
}
