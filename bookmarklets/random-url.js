/*
 * This is a javascript file used for implementing the random url bookmarklet
 */



$(document).on('keyup', '#urls', function() {
  function build(text) {
    var urls = text.trim().split(/\n/);
    var bookmarklet = "javascript:(function(){U=[";

    for(var i = 0; i < urls.length; i++) {
      if(urls[i].trim()) {
        bookmarklet += "'" + urls[i].trim() + "'";
        if((i + 1) < urls.length) {
          bookmarklet += ",";
        }
      }
    }

    bookmarklet += "];window.location = U[Math.floor(Math.random()*U.length)]})()";
    
    $('#output').val(bookmarklet);
  }



  build($(this).val());
});
