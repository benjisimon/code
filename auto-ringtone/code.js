/*
 * This is a javascript file used for powering our auto-ringtone page
 */

$(document).ready(function() {

  function go() {
    var input = $('input').val();
    var seed  = input.replace(/[^A-Za-z0-9]/, '').toUpperCase().substring(0, 3);
    var seed  = seed ? seed : 'UKN';
    $('.feedback').html("Playing ringtone for <u>"+ input + "</u>: " + seed);
  }
  

  $(document).on('keyup', 'input', function(evt) {
    if(evt.keyCode == 13) {
      go();
    }
    return false;
  });

  $('input').focus();

});
