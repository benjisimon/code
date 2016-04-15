<?
/*
 * PHP utilities
 */

function g($array, $key, $default = false) {
  return isset($array[$key]) ? $array[$key] : $default;
}

function A() {
  $array = func_get_args();
  return $array;
}


function snippet($_name, $_vars = array()) {
  ob_start();
  extract($_vars);
  require(__DIR__ . "/../../snippets/$_name.php");
  return ob_get_clean();
}

?>
