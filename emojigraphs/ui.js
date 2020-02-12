/*
 * This is a javascript file used for implementing our ui
 */

$(document).ready(function() {
  $('input[name=q]').autocomplete({
    source: "lookup.php"
  });
});
