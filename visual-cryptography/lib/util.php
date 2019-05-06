<?php
/*
 * A PHP file for implementing utilities
 */

function g($array, $key, $default = false) {
  return array_key_exists($array, $key) ? $array[$key] : $default;
}

function app_url($path = '', $params = []) {
  $host = $_SERVER['SERVER_NAME'];

  return "http://$host/visual-cryptography/$path" . ($params ? '?'. http_build_query($params, false, '&') : '');
}

function resource_url($path, $params = []) {
  $version = filemtime(__DIR__ . "/../$path");
  return app_url($path, ['ver' => $version] + $params);
}

?>
