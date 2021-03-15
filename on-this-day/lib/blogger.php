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

function blogger_posts_on($blog_id, $date, $year) {
  $c = new Google\Client();
  $c->setAccessToken($_SESSION['posts_credentials']);
  $blogger = new Google_Service_Blogger($c);

  $date = "$year-{$date['month']}-{$date['day']}";

  $start = gmdate(DateTimeInterface::RFC3339, strtotime("{$date}T00:00:00"));
  $end = gmdate(DateTimeInterface::RFC3339, strtotime("{$date}T23:59:59"));

  return $blogger->posts->listPosts($blog_id, [
    'startDate' => $start,
    'endDate' => $end
  ]);
  
}
