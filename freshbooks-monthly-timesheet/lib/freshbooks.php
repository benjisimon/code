<?
/*
 * A custom wrapper around the the freshbooks api over at:
 * https://github.com/rtconner/freshbooks-api/blob/master/README.md
 */

function fb_invoke($type, $verb, $args = array()) {
  $fb = new Freshbooks\FreshBooksApi(FB_DOMAIN, FB_KEY); 
  $fb->setMethod("$type.$verb");
  $fb->post($args);
  $fb->request();
  $type_plural = $type == 'time_entry' ? 'time_entries' : "{$type}s";

  if($fb->success()) {
    $rs = $fb->getResponse();
    switch($verb) {
      case 'list':
        $count = hop($rs, $type_plural, '@attributes', 'total');
        switch($count) {
          case 0: return A();
          case 1: return A(hop($rs, $type_plural, $type));
          default:  return hop($rs, $type_plural, $type);
        }
      default: return $rs;
    }
  } else {
    trigger_error("Freshbooks: $method failure: " . $fb->getError(), E_USER_ERROR);
  }
}

function fb_client_by_email($email) {
  $found = fb_invoke('client', 'list', array('email' => $email));
  return $found ? $found[0] : false;
}


function fb_projects_by_client($client) {
  $found = fb_invoke('project', 'list', array('client_id' => $client['client_id']));
  return $found;
}

function fb_time_entries_by_project($project) {
  return fb_invoke('time_entry', 'list', array('project_id' => $project['project_id']));
}

?>
