<?php
/*
 * A PHP file for providing general utilities
 */

function g($array, $key, $default = false) {
  return array_key_exists($key, $array) ? $array[$key] : $default;
}



function snippet($_name, $_params = array()) {
  ob_start();
  extract($_params);
  require(__DIR__ . "/../snippets/{$_name}.php");
  $content = ob_get_clean();
  return $content;
}

?>
