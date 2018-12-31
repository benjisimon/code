<?php
/*
 * A PHP file for working with curl
 */

function curl_get($url, $params, $options = []) {
  $ttl = g($options, 'ttl', 0);
  $cache_file = CURL_CACHE_DIR . "/" . md5($url . serialize($params)) . '.json';

  if(file_exists($cache_file) && ((time() - filemtime($cache_file)) < $ttl)) {
    $body = file_get_contents($cache_file);
    return json_decode($body, true);
  }
  
  $fd = fopen($cache_file, "w");
  $ch = curl_init($url . ($params ? ('?' . http_build_query($params, false, '&')) : ''));
  curl_setopt($ch, CURLOPT_TIMEOUT, g($options, 'timeout', 4));
  curl_setopt($ch, CURLOPT_FILE, $fd);
  curl_exec($ch);

  $info = curl_getinfo($ch);

  if($info['http_code'] == 200) {
    $body = file_get_contents($cache_file);
    return json_decode($body, true);
  } else {
    unlink($cache_file);
    return $ch;
  }
}

?>
