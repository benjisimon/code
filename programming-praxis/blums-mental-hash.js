/*
 * A JavaScript implmenetation of Blums Mental Hash
 * See:
 * http://programmingpraxis.com/2014/09/26/blums-mental-hash/
 * https://github.com/benjisimon/code/blob/master/programming-praxis/blums-mental-hash.scm
 */

var BMH = {};
(function() {
  var MAX_PASSWORD_LENGTH = 12;

  // XXX - Obviously, this shouldn't be hard coded here.  Not sure yet
  // where it belongs.
  var key = {
    f: {
     a: 2, b: 9, c: 7, d: 3, e: 9, f:4, g: 8, h:4, i: 1, j: 0, k: 3,
     l: 9, m: 2, n:3 , o:6, p: 2, q: 1, r: 3, s: 4, t: 7, u:4, v: 2,
     w: 1, x: 9, y: 0, z: 5, '0': 2, '1': 4, '2': 8, '3': 2, '4': 7,
     '5': 7, '6': 2, '7': 5, '8': 3, '9': 5, '.': 9, '-': 2
    },
    g: [ 6,3,4,1,2,0,8,5,9,7 ],
    h: [ 'Wa', 'Me', 'Vo', 'Nu', '-', 'Ze', 'Ni', 'Tu', '@', '3' ]
  };


  function init(text) {
    var seq = [];
    for(var i = 0; i < text.length && i < MAX_PASSWORD_LENGTH; i++) {
      seq.push(key.f[text[i]]);
    }
    return seq;
  }

  function step(x, y) {
    var needle = (x+y) % 10;
    for(var i = 0; i < key.g.length; i++) {
      if(needle == key.g[i]) {
        return key.g[(i+1) % key.g.length];
      }
    }
    alert("Failed to derive next step" + x + "," + y);
  }

  function humanify(result) {
    var password = "";
    for(var i = 0; i < result.length; i++) {
      password += (key.h[result[i]]);
    }
    return password;
  }


  BMH.hash = function(domain) {
    var seq = init(domain.length == 0 ? 'www.com' : domain);
    var result = [ step(seq[0], seq[seq.length-1]) ];
    for(var i = 1; i < seq.length; i++) {
      result.push(step(result[i-1], seq[i]));    
    }
    return humanify(result);
  }
})();

