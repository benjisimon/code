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
  $scopes = [
    'pics' => ['https://www.googleapis.com/auth/photoslibrary.readonly'],
    'posts' => ['https://www.googleapis.com/auth/blogger']
  ];

  $subject = g($_GET, 'subject');

  if(!$subject) {
    return false;
  }
  
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
    'redirectUri' => app_url('', ['subject' => $subject]),
    'tokenCredentialUri' => 'https://www.googleapis.com/oauth2/v4/token',
    'scope' => g($scopes, $subject)
  ]);

  if(g($_GET, 'code') == 'clear') {
    nuke_session();
    header("Location: " . app_url());
    exit();    
  } else if(g($_GET, 'code') == 'create') {
    $url = $oauth2->buildFullAuthorizationUri();
    header("Location: $url");
    exit();
  } else if(g($_GET, 'code')) {
    $oauth2->setCode($_GET['code']);
    $authToken = $oauth2->fetchAuthToken();
    $refreshToken = $authToken['access_token'];

    // The UserRefreshCredentials will use the refresh token to 'refresh' the credentials when
    // they expire.
    $_SESSION["{$subject}_credentials"] = new UserRefreshCredentials(
      g($scopes, $subject),
      [
        'client_id' => $clientId,
        'client_secret' => $clientSecret,
        'refresh_token' => $refreshToken
      ]
    );
    header("Location: " . app_url('', ['subject' => $subject]));
    exit();
  } else if(g($_SESSION, "${subject}_credentials")) {
    return true;
  } else {
    return false;
  }
}
