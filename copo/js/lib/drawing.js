/*
 * This is a javascript file used for working with drawing
 */

/*
 * ************************************************************************
 * Lines
 */

function Line() {
  this.start = { x: 0, y: 0 };
  this.end   = { x: 1, y: 0 };
}

Line.prototype.scale = function(mag) {
  this.start = { x: this.start.x * mag, y: this.start.y * mag };
  this.end   = { x: this.end.x * mag, y: this.end.y * mag };
  return this;
}

Line.prototype.translate = function(offset) {
  this.start = { x: this.start.x + offset.x, y: this.start.y + offset.y };
  this.end   = { x: this.end.x + offset.x, y: this.end.y + offset.y };
  return this;
}

// Mrs. Buck would not be impressed that I have to Google this.
// http://www.felixeve.co.uk/how-to-rotate-a-point-around-an-origin-with-javascript/
Line.prototype.rotate = function(degrees) {
  var rads = degrees * Math.PI / 180.0;
  this.start = { x: Math.cos(rads) * this.start.x - Math.sin(rads) * this.start.y,
                 y: Math.sin(rads) * this.start.x + Math.cos(rads) * this.start.y };

  this.end = { x: Math.cos(rads) * this.end.x - Math.sin(rads) * this.end.y,
               y: Math.sin(rads) * this.end.x + Math.cos(rads) * this.end.y };

  return this;
}

Line.prototype.copy = function() {
  var dup   = new Line();
  dup.start = { x: this.start.x, y: this.start.y };
  dup.end   = { x: this.end.x, y: this.end.y };
  return dup;
}

Line.prototype.drawInto = function(space) {
  space.stroke(this.start, this.end);
}

/*
 * ************************************************************************
 * Drawings. A drawing can contain lines and other drawings. 
 */

function Drawing() {
  this.parts = [];
}

Drawing.prototype.add = function(part) {
  this.parts.push(part);
}

Drawing.prototype.each = function(fn) {
  var results = [];
  for(var i = 0; i < this.parts.length; i++) {
    results.push(fn(this.parts[i]));
  }
  return results;
}

Drawing.prototype.scale = function(mag) {
  this.each(function(p) { p.scale(mag); });
  return this;
}

Drawing.prototype.translate = function(offset) {
  this.each(function(p) { p.translate(offset); });
  return this;
}

Drawing.prototype.rotate = function(degrees) {
  this.each(function(p) { p.rotate(degrees); });
  return this;
}

Drawing.prototype.copy = function() {
  return this.each(function(p) { return p.copy(); });
}

Drawing.prototype.drawInto = function(space) {
  this.each(function(p) { p.drawInto(space); });
}

/*
 * ************************************************************************
 * Do the translation from drawings and such to a canvas
 */
var Painter = {

  draw: function(canvas, generator) {
    if(canvas.getContext) {
      var oo = { x: canvas.scrollWidth / 2,
                 y: canvas.scrollHeight / 2 };
      var ctx = canvas.getContext('2d');
      var space = {
        stroke: function(start, end) {
          ctx.beginPath();
          ctx.moveTo(start.x + oo.x, oo.y - start.y);
          ctx.lineTo(end.x + oo.x, oo.y - end.y);
          ctx.stroke();
        }
      };
      generator().drawInto(space);
    } else {
      throw new Error("Canvas has no context to draw into");
    }
  }

};