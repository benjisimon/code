<?php
/*
 * Implement a concept like Artist Pages as described in the Artist's Way.
 *
 * Goal is to write to fill a particular amount of space with text. Do this 
 * frequently enough, and your brain gets a workout/outlet.
 *
 * This implements our sign-in page.
 */
require_once('lib/siteconfig.php');
?>
<!DOCTYPE>
<html>
  <head>
    <title>Just Write. Seriously. What are you doing? Just Write.</title>
    <link rel="Stylesheet" type="text/css" 
          href="css/layout.css?ver=<?= filemtime(__DIR__ . '/css/layout.css') ?>"/>

    <link href="https://fonts.googleapis.com/css?family=Merienda" rel="stylesheet">
  </head>

  <body>


    <div class="sign-in">
      <h1>Just Write</h1>

      <div class="g-signin2" data-width="300" data-onsuccess="onSignIn"></div>
    </div>

    <div class="editor hidden">
      <div class="auth-info"></div>
      <textarea></textarea>
      <input type="button" value="Just Write." class="save" disabled="true"/>
    </div>
    
    <meta name="google-signin-client_id" content="1032759647828-rfam6ogeaemq890t3pmuv319td9j2tt2.apps.googleusercontent.com"/>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script
			src="https://code.jquery.com/jquery-3.3.1.min.js"
			     integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
			crossorigin="anonymous"></script>
    <script type="text/javascript" src="js/ui.js?ver=<?= filemtime(__DIR__ . '/js/ui.js') ?>"></script>
  </body>
</html>
