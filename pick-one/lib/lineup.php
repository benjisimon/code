<?php
/*
 * A PHP file for generating a lineup.
 */

function make_lineup($subject) {
  $dir = __DIR__ . "/../subjects/$subject";
  if(!$subject || !preg_match('/^[a-z0-9-]+$/', $subject) || !is_dir($dir)) {
    return [];
  } else {
    $dh = opendir($dir);
    $names = [];
    while($name = readdir($dh)) {
      if(preg_match('/[.](png|jpg|gif)$/', strtolower($name))) {
        $names[] = $name;
      }
    }
    sort($names);
    return $names;
  }
}

function lineup_img_src($subject, $name) {
  return resource_url("subjects/$subject/$name");
}


function lineup_view_href($subject, $name) {
  return resource_url("view.php", ['s' => $subject, 'n' => $name]);
}

function lineup_id($subject, $name) {
  $i = array_search($name, make_lineup($subject));
  return chr($i + 65);
}
?>
