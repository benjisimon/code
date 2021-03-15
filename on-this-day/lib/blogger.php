<?php
/*
 * A PHP file for helping with blog stuff.
 */

function blogger_all_user_blogs() {
  $c = new Google\Client();
  $c->setAccessToken($_SESSION['posts_credentials']);
  $blogger = new Google_Service_Blogger($c);

  return $blogger->blogs->listByUser('self');
}
