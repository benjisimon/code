/*
 * This is a javascript file used for powering our UI
 */

$(document).ready(function() {
  $(document).on('click', 'input', function() {
    var root = $(this).closest('.entry');
    $(root).find('.placeholder').hide();
    $(root).find('.video').show();
  });
});
