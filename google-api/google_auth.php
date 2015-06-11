<?php
/*
 * A PHP file for implementing Google API OAUTH Access. A PHP version of my simple
 * Google API access discussed here:
 *  http://www.blogbyben.com/2015/03/gdget-inching-towards-more-linux.html
 */

class GoogleAuth {

  private $ctx;

  function __construct($ctx) {
    $this->ctx = $ctx;
  }

  /*
   * Call this function to get a URL you can visit to start the entire
   * auth process.
   */
  function start_auth() {
    $params = array('scope'         => $this->ctx['scope'],
                    'redirect_uri'  => 'urn:ietf:wg:oauth:2.0:oob',
                    'response_type' => 'code',
                    'client_id'     => $this->ctx['client_id']);

    $response = $this->curl("GET", "https://accounts.google.com/o/oauth2/auth", $params, 'headers');
    return $response['Location'];
  }

  /*
   * Once the user has visited the URL at start_auth, they can use
   * this function to complete the auth procedure.
   *
   * the one parameter provided is the code shown as a result of the start_auth URL.
   */
  function complete_auth($code) {
    $params = array('client_id'     => $this->ctx['client_id'],
                    'client_secret' => $this->ctx['client_secret'],
                    'code'          => $code,
                    'grant_type'    => 'authorization_code',
                    'redirect_uri'  => 'urn:ietf:wg:oauth:2.0:oob');

    $response = $this->curl('POST', 'https://www.googleapis.com/oauth2/v3/token', $params, 'json');
    $this->save_auth($response);
    return $response;
  }

  /*
   * Once you've gone through the auth process you can call this function as 
   * as you want to get a valid authentication header. This function
   * will refresh the token as needed automatically.
   */
  function auth_token() {
    $auth = json_decode(file_get_contents($this->ctx['auth_file']));
    $age  = time() - filemtime($this->ctx['auth_file']);

    if($age > $auth->expires_in) {
      $this->auth_refresh($auth);
      return $this->auth_token();
    } else {
      return $auth->access_token;
    }
  }

  // -- Private Stuff Below --
  
  private function auth_refresh($auth) {
    $params = array('client_id'     => $this->ctx['client_id'],
                    'client_secret' => $this->ctx['client_secret'],
                    'grant_type'    => 'refresh_token',
                    'refresh_token' => $auth->refresh_token);

    $response = $this->curl('POST', 'https://www.googleapis.com/oauth2/v3/token', $params, 'json');
    $this->save_auth($response);
    return true;
  }

  private function save_auth($response) {
    if(isset($response->error)) {
      trigger_error($response->error_description, E_USER_ERROR);
    } else {
      if(file_put_contents($this->ctx['auth_file'], json_encode($response)) === false) {
        trigger_error("Failed to save ctx: {$this->ctx['auth_file']}", E_USER_ERROR);
      } else {
        return true;
      }
    }
  }

  /*
   * This doesn't really belong here. But I'm trying to make this all stand alone,
   * so I'm stashing this curl util function here.
   */
  function curl($method, $url, $params, $fmt) {
    $qs               = is_array($params) ? http_build_query($params, false, '&') : $params;
    $outgoing_headers = array();

    if($method == 'GET' && $params) {
      $url .= "?$qs";
    }

    $is_auth_url = strpos($url, 'googleapis.com/oauth2') !== false || strpos($url, 'accounts.google.com') !== false;
    
    $ch = curl_init($url);

    if(!$is_auth_url) {
      $outgoing_headers[] = "Authorization: Bearer " . $this->auth_token();
    }
    
    if($method == 'POST') {
      curl_setopt($ch, CURLOPT_POST, true);
      curl_setopt($ch, CURLOPT_POSTFIELDS, $qs);
    } else if($method == 'PUT') {
      curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
      curl_setopt($ch, CURLOPT_POSTFIELDS, $qs);
      $outgoing_headers[] = ("Content-Type: application/atom+xml");
    }
    
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    if(in_array($fmt, array('raw', 'headers'))) {
      curl_setopt($ch, CURLOPT_HEADER, true);
    }

    curl_setopt($ch, CURLOPT_HTTPHEADER, $outgoing_headers);

    $response = curl_exec($ch);
    $info     = curl_getinfo($ch);
    $errno    = curl_errno($ch);
    $error    = curl_error($ch);

    if($errno) {
      trigger_error("$method failed: $url: " . $error, E_USER_ERROR);
    }

    switch($fmt) {
      case 'json':
        return json_decode($response);
      case 'xml':
        return new SimpleXMLElement($response);
      case 'headers':
        $headers = array();
        $lines   = explode("\r\n", $response);
        foreach($lines as $line) {
          if($line == '') {
            return $headers;
          }
          if(preg_match('/^(.*?): (.*)/', $line, $matches)) {
            $headers[$matches[1]] = trim($matches[2]);
          }
        }
      case 'raw':
        return $response;
      default:
        return $response;
    }
  }
}

?>