<?php
/*
 * A PHP file for being a generic redirect handler for auth2 requests
 */
require_once(__DIR__ . '/vendor/autoload.php');
define('PRIVATE_DIR', '/var/www/private/oauth2handler');

$app_name = preg_replace('|.*oauth2handler/|', '', $_SERVER['REQUEST_URI']);
$app_name = preg_replace('|[?].*|', '', $app_name);
if(!file_exists(PRIVATE_DIR . "/$app_name.json")) {
  echo "Unknown app: $app_name. Bye.";
  exit();
}

if(!isset($_GET['code'])) {
  echo "Invalid url request. Bye";
  exit();
}

$redirect_uri = "https://{$_SERVER['SERVER_NAME']}/oauth2handler/$app_name";

$client = new Google\Client();
$client->setAuthConfig(PRIVATE_DIR . "/$app_name.json");
$client->setRedirectUri($redirect_uri);
$client->setAccessType('offline');

foreach(explode(" ", $_GET['scope']) as $scope) {
  $client->addScope(trim($scope));
}

$token = $client->fetchAccessTokenWithAuthCode($_GET['code']);
echo "<pre>" . json_encode($token, JSON_PRETTY_PRINT) . "</pre>";
