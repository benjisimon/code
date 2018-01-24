/*
 * This is a javascript file used for implementing our simple ui
 */

$(document).ready(function() {
  $('#show-code').click(function() {
    if($('#code').hasClass('hidden')) {
      $('#code').removeClass('hidden');
      $('#canvas').addClass('hidden');
      $(this).text("Hide Code");
    } else {
      $('#code').addClass('hidden');
      $('#canvas').removeClass('hidden');
      $(this).text("Show Code");
    }
    return false;
  });
});

