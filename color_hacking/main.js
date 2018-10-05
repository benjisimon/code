/*
 * This is a javascript file used for implementing color related functions
 */

function cpack(c) {
  var p = index => {
    var x = Math.round(c[index]* 255).toString(16)
    return x.length == 1 ? "0" + x : x;
  };

  return c.slice ? c : ('#' + p('r') + p('g') + p('b')).toUpperCase();
}

function cunpack(c) {
  if(c.r) {
    return c;
  }
  var c = c.replace(' ', '');
  var r = c.substring(1, 3);
  var g = c.substring(3, 5);
  var b = c.substring(5);

  var p = x => Number.parseInt(x, 16) / 255;
  
  return { r: p(r), g: p(g), b: p(b) };
}

function cfold(start, end, steps, init, fn) {
  var start = cunpack(start);
  var end   = cunpack(end);

  var incr = {
    r: (end.r - start.r) / (steps-1),
    g: (end.g - start.g) / (steps-1),
    b: (end.b - start.b) / (steps-1)
  };

  var carry = init;
  var color = start;
  for(i = 0; i < steps; i++) {
    carry = fn(carry, color);
    color = { r: color.r + incr.r,
              g: color.g + incr.g,
              b: color.b + incr.b };
  }

  return carry;
}

var show = 6;
var canvas = document.getElementById('canvas');
var line = 0;


if(show == 0) {
  var html = cfold("#00 00 00", "#FF FF FF", 100, "",
                   (html, color) => {
                     return html + "<div style='height: 5px; background-color: " + cpack(color) + "'>" + cpack(color) + ":" + (++line) + "</div>\n";
                   });
}

if(show == 1) {
  var html = cfold("#00 00 AA", "#FF AA 00", 100, "",
                   (html, color) => {
                     return html + "<div style='height: 3px; background-color: " + cpack(color) + "'></div>\n";
                   });
}

if(show == 2) {
  var data = cfold("#00 00 AA", "#FF AA 00", 100, [],
                   (all, color) => {
                     all.push(color);
                     return all;
                   });
  var html = '';
  var i    = 0;

  function tick() {
    canvas.innerHTML = "<div style='height: 100px; background-color: " + cpack(data[i]) + "'></div>";
    i = (i+1) % 100;
  }


  setInterval(tick, 200);
}

if(show == 3) {
  var html = cfold("#00 FF 11", "#33 55 FF", 1000, '',
                   (html, color) => {
                     html += ("<div style='height: 20px; width: 20px; float: left; " +
                              "background-color: " + cpack(color) + "'></div>");
                     return html;
                   });
}

if(show == 4) {
  var html = cfold("#00 FF 30", "#FF 00 40", 1000, '',
                   (html, color) => {
                     html += ("<div style='height: 20px; width: 20px; float: left; " +
                              "background-color: " + cpack(color) + "'></div>");
                     return html;
                   });
}

if(show == 5) {
  var html = cfold("#00 55 22", "#FF 88 36", 1000, '',
                   (html, color) => {
                     html += ("<div style='height: 20px; width: 20px; float: left; " +
                              "background-color: " + cpack(color) + "'></div>");
                     return html;
                   });
}


if(show == 6) {
  var i = 0;
  var text = "Hello World!".split('');
  var html = cfold("#00 AA FF", "#FF 88 FF", text.length, '',
                   (html, color) => {
                     var t = text.shift();
                     var tc = { r: 1 - color.r,
                                g: 1 - color.g,
                                b: 1 - color.b };
                     html += ("<div style='text-align: center; width: 75px; font-size: 70px; float: left; " +
                              "background-color: " + cpack(color) + "; color: " + cpack(tc) + "'>" + t + "</div>");
                     return html;
                   });
}


canvas.innerHTML = html;

