/*
 * This is a javascript file used for implementing our ui
 */

$(document).ready(function() {
  $('input[name=q]').autocomplete({
    source: "lookup.php",
    html: true,
    select: function(event, ui) {
      var emoji = ui.item.value;
      $("<span></span>").html(emoji).appendTo('.board');
      $(this).val('');
      return false;
    }
  });
});
