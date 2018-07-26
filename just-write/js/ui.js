/*
 * This is a javascript file used for implementing our Just Write word counting UI thingy.
 */

var GOAL_COUNT = 500;

function onSignIn(googleUser) {
  var profile = googleUser.getBasicProfile();
  $('.auth-info').html("Welcome " + profile.getName() + ". <a href='#' class='sign-out'>(Sign Out)</a>");
  $('.sign-in').hide();
  $('.editor').css({display: 'flex'});
  $('input[name=email]').val(profile.getEmail());
}

$(document).on('click', 'a.sign-out', function() {
  var auth2 = gapi.auth2.getAuthInstance();
  auth2.signOut().then(function () {
    location.reload();
  });
  return false;
});

$(document).on('keyup', 'textarea', function() {
  var text = $(this).val();
  var count = text.trim().split(/\s+/).length;
  var left  = Math.max(GOAL_COUNT - count, 0);
  var disabled = true;
  if(count >= GOAL_COUNT) {
    var label = "Whoo, you did it! " + count + " words. You're a rock star! Press Me to save your work.";
    var disabled = false;
  } else if(count > (GOAL_COUNT*.75)) {
    var label = "You're so close. Only " +  left + " words left.";
  } else if(count > (GOAL_COUNT*.5)) {
    var label = "Now you're cooking. " +  left + " words left.";
  } else if(count > (GOAL_COUNT*.25)) {
    var label = "Great job, you're picking up speed.  " +  left + " words left.";
  } else if(count > 0) {
    var label = "Keep typing, you got this. " +  left + " words left.";
  } else {
    var label = "Just Write.";
  }
  $('.save').val(label).prop('disabled', disabled);
});
