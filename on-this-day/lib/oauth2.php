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
  $subject = g($_GET, 'subject');

  if(g($_GET, 'code') == 'clear') {
    nuke_session();
    header("Location: " . app_url());
    exit();    
  } else if(!$subject) {
    return false;
  } else {
    return call_user_func("handle_{$subject}_oauth2");
  }

}

function handle_posts_oauth2() {
  $client = new Google\Client();
  $client->setAuthConfig(CREDENTIALS_JSON);
  $client->setRedirectUri(app_url('', ['subject' => 'posts']));
  $client->addScope("https://www.googleapis.com/auth/blogger.readonly");


  if(g($_GET, 'code') == 'create') {
    $url = $client->createAuthUrl();
    header("Location: $url");
    exit();
  } else if(g($_GET, 'code')) {
    $_SESSION['posts_credentials'] = $client->fetchAccessTokenWithAuthCode($_GET['code']);
    header("Location: " . app_url('', ['subject' => $subject]));
    exit();
  } else if(($c = g($_SESSION, "posts_credentials"))) {
    $client->setAccessToken($c);
    if ($client->isAccessTokenExpired()) {
      return false;
    } else {
      return true;
    }
  } else {
    return false;
  }
}


function handle_photos_oauth2() {
  $subject = 'pics';
  $scopes = [
    'pics' => ['https://www.googleapis.com/auth/photoslibrary.readonly'],
    'posts' => ['https://www.googleapis.com/auth/blogger']
  ];

  
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

  if(g($_GET, 'code') == 'create') {
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
  } else if(($c = g($_SESSION, "${subject}_credentials"))) {
    try {
      $auth_token = $c->fetchAuthToken();
    } catch(Exception $ex) {
      return false;
    }
    
    return true;
  } else {
    return false;
  }
}
