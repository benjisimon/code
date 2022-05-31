<?php
/*
 * A PHP file for working with bit.ly, the URL shortener service
 */

function bitly_shrink($long_url) {
  $found = bitly_cache_get($long_url);

  if($found) {
    return $found;
  }

  $body = [
    'long_url' => $long_url,
    'domain' => 'bit.ly',
    'group_guid' => BITLY_DEFAULT_GROUP_GUID
  ];

  $ch = curl_init("https://api-ssl.bitly.com/v4/shorten");
  curl_setopt($ch, CURLOPT_POST, true);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_TIMEOUT, 10);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body));
  curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Authorization: Bearer ' . BITLY_ACCESS_TOKEN
  ]);

  $response = curl_exec($ch);
  $info = curl_getinfo($ch);
  if($info['http_code'] < 200 && $info['http_code'] > 299) {
    throw new Exception("Bitly was a no go ({$info['http_code']}): " . $response);
  }

  $details = json_decode($response, true);
  $short_url = $details['link'];
  bitly_cache_put($long_url, $short_url);
  return $short_url;
}

function bitly_cache_file() {
  return __DIR__ . "/.bitly.cache";
}

$_bitly_cache = null;
function bitly_cache_get($long_url) {
  global $_bitly_cache;
  if($_bitly_cache == null) {
    if(filesize(bitly_cache_file()) == 0) {
      $_bitly_cache = [];
    } else {
      $_bitly_cache = json_decode(file_get_contents(bitly_cache_file()), true);
    }
  }

  return g($_bitly_cache, $long_url);
}

$_bitly_cache = null;
function bitly_cache_put($long_url, $short_url) {
  global $_bitly_cache;

  $_bitly_cache[$long_url] = $short_url;
  file_put_contents(bitly_cache_file(), json_encode($_bitly_cache));
}
