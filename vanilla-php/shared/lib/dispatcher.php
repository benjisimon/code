<?php
/*
 * A PHP file for implementing our dispatching capability
 */


function dispatch() {
  $request = g($_SERVER, 'REQUEST_URI');
  if(strpos($request, '..') !== false) {
    header("HTTP/1.0 400 Invalid Request");
    exit();
  }

  if(defined('APP_BASE_URI')) {
    $request = substr($request, strlen(APP_BASE_URI));
  }
  
  $args  = A();
  $parts = explode("/", $request);
  while($parts) {
    $f = __DIR__ . "/../../pages/$request";
    if(is_dir($f)) {
      $f = "$f/home.php";
    } else {
      $f = "$f.php";
    }
    if(file_exists($f)) {
      $_ARGS = $args;
      require($f);
      return $f;
    } else {
      $args[] = array_pop($parts);
      $request = implode('/', $parts);
    }
  }

  require(__DIR__ . '/../../pages/404.php');
  return false;
}

function app_url($path, $params = array()) {
  return ('http://' . 
          g($_SERVER, 'SERVER_NAME') . 
          (defined('APP_BASE_URI') ? APP_BASE_URI : '/') .
          $path .
          ($params ? '?'.http_build_query($params) : ''));
                                                
}


?>
