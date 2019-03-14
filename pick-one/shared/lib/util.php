<?php
/*
 * A PHP file for holding into utilities
 */

function g($array, $key, $default = false) {
  return isset($array[$key]) ? $array[$key] : $default;
}

function app_url($path = '', $params = []) {
  return "http://{$_SERVER['SERVER_NAME']}/pick-one/$path" . 
         ($params ? '?' . http_build_query($params, false, '&') : '');
}

function resource_url($path = '', $params = []) {
  $ver = filemtime(__DIR__ . "/../../$path");
  return app_url($path, ['ver' => $ver] + $params);
}

function snippet($_name, $_params = array()) {
  ob_start();
  extract($_params);
  require(__DIR__ . "/../../snippets/{$_name}.php");
  return ob_get_clean();
}


$_snippet_stack = [];
global $_snippet_stack;
function start_snippet($name, $params = array()) {
  global $_snippet_stack;

  array_push($_snippet_stack, array('name' => $name, 'params' => $params));
  ob_start();
}

function end_snippet() {
  global $_snippet_stack;
  
  $body = ob_get_clean();
  $snippet = array_pop($_snippet_stack);
  return snippet($snippet['name'], $snippet['params'] + array('body' => $body));
}

?>
