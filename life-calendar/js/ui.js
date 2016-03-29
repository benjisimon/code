/*
 * Implement the life-calendar's UI. What little there is of it.
 */

function refresh() {
  $('.w').removeClass('f').removeClass('p');
  var dob   = $('#dob').val();
  var epoch = moment(dob, "MM/DD/YYYY");
  var now   = moment();
  if(epoch.isValid()) {
    var weeks = 90 * 52;
    for(var w = 0; w < weeks; w++) {
      var x = epoch.clone().add(w, "weeks");
      $('.w' + w).addClass(x.isAfter(now) ? 'f' : 'p');
    }

  }
  return false;
}

$('input[type=button]').click(refresh);
$('form').submit(refresh);
