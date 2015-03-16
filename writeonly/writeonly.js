/*
 * Power our writeonly experiment
 */

(function(){
  var last = { word: '', char: '' };

  var root   = $('.writeonly').get(0);
  var prompt = root.childNodes[0];

  function insertChar(c) {
    var t = document.createTextNode(c);
    root.insertBefore(t, prompt);
    last.char = c;
    last.word += c;
  }

  function insertSpace() {
    insertChar(' ');
    last.word = '';
  }

  function insertBr(c) {
    var br = document.createElement('br');
    root.insertBefore(br, prompt);
    last.word = '';
    last.char = '';
  }

  function strikeLastWord() {
    if(last.word == '') {
      return;
    }
    var target = root.childNodes.length - 2;
    for(var i = 0; i < last.word.length; i++) {
      console.log(target);
      root.removeChild(root.childNodes[target-i]);
    }

    var t = document.createTextNode(last.word.substring(0, last.word.length -1));
    var s = document.createElement('s');
    s.appendChild(t);
    root.insertBefore(s, prompt);
    last.word = '';
    last.char = '';
  }

  function feedback(text) {
    $('.feedback').html(text);
  }

  function keypress(e) {
   if(e.ctrlKey || e.metaKey) {
     return;
   }
   e.preventDefault();
   if(e.key == 'Enter') {
     insertBr();
   } else if(e.key == ' ') {
     insertSpace();
   } else if(e.key == '-') {
     if(last.char == '-') {
       strikeLastWord();
     } else {
       insertChar('-');
     }
   } else if(e.keyCode == 0) {
     insertChar(e.key);
   } else {
     feedback("D'oh! No " + e.key + " allowed");
   }
  }
 

  $('.writeonly').keypress(keypress);
})();
