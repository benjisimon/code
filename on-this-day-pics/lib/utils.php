<?php
/*
 * A PHP file for implementing utilities
 */

function g($array, $key, $default = false) {
  return array_key_exists($key, $array) ? $array[$key] : $default;
}

function app_url($path = '', $params = []) {
  return "https://{$_SERVER['SERVER_NAME']}/on-this-day-pics/$path" .
         ($params ? '?' . http_build_query($params) : '');
}


function nuke_session() {
  $params = session_get_cookie_params();
  setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
  );
  session_destroy();
}
