<?php
/*
 * A PHP file for powering utility functions
 */

function snippet($_name, $_params = array()) {
  extract($_params);
  ob_start();
  require(__DIR__ . "/../snippets/$_name.php");
  $content = ob_get_clean();
  return $content;
}

function g($array, $key, $default = false) {
  return isset($array[$key]) ? $array[$key] : $default;
}

function files_in_dir($dirpath, $options = array()) {
  $dh = opendir($dirpath);
  $results = array();
  while(($f = readdir($dh)) !== false) {
    if(g($options, 'filter')) {
      if(call_user_func($options['filter'], $f)) {
        $results[] = $f;
      }
    } else {
      $results[] = $f;
    }
  }
  return $results;
}

?>