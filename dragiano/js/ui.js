/*
 * This is a javascript file used for working with the instrument UI
 */


var Ui = {
  pack: function() {
    $('canvas').attr('width', 10).attr('width', $('body').width());
    $('canvas').attr('height', 10).attr('height', $(document).innerHeight() - $('.controls').innerHeight() - 10);

    return true;
  }

};

$(document).ready(function() {
  Ui.pack();

});

$(window).on('resize', Ui.pack);

$(document).on('click', '.go', function() {
  return false;
});
