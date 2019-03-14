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

function lineup_id($i) {
  return chr($i + 65);
}
?>
