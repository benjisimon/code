<?php
/*
 * A PHP file for helping do the oauth2 dance with google photos
 */


use Google\Auth\Credentials\UserRefreshCredentials;
use Google\Auth\OAuth2;

  
// Inspired by:
// https://github.com/google/php-photoslibrary/blob/samples/src/common/common.php
//
function handle_oauth2() {
  $path = g($_SERVER, 'REQUEST_URI');
  $clientSecretJson = json_decode(
    file_get_contents(CREDENTIALS_JSON),
    true
  )['web'];
  $clientId = $clientSecretJson['client_id'];
  $clientSecret = $clientSecretJson['client_secret'];

  $oauth2 = new OAuth2([
    'clientId' => $clientId,
    'clientSecret' => $clientSecret,
    'authorizationUri' => 'https://accounts.google.com/o/oauth2/v2/auth',
    // Where to return the user to if they accept your request to access their account.
    // You must authorize this URI in the Google API Console.
    'redirectUri' => app_url(),
    'tokenCredentialUri' => 'https://www.googleapis.com/oauth2/v4/token',
    'scope' => ['https://www.googleapis.com/auth/photoslibrary.readonly']
  ]);

  if(g($_GET, 'code') == 'clear') {
    nuke_session();
    header("Location: " . app_url());
    exit();    
  } else if(g($_GET, 'code') == 'create') {
    $url = $oauth2->buildFullAuthorizationUri(['access_type' => 'offline']);
    header("Location: $url");
    exit();
  } else if(g($_GET, 'code')) {
    $oauth2->setCode($_GET['code']);
    $authToken = $oauth2->fetchAuthToken();
    $refreshToken = $authToken['access_token'];

    // The UserRefreshCredentials will use the refresh token to 'refresh' the credentials when
    // they expire.
    $_SESSION['credentials'] = new UserRefreshCredentials(
      $scopes,
      [
        'client_id' => $clientId,
        'client_secret' => $clientSecret,
        'refresh_token' => $refreshToken
      ]
    );
    header("Location: " . app_url());
    exit();
  } else if(g($_SESSION, 'credentials')) {
    return true;
  } else {
    return false;
  }
}
