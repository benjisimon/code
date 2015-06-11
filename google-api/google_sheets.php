<?php
/*
 * A PHP file for working with Google Sheets. Leverages
 * google_auth.php for google authentication.
 */
require_once(__DIR__ . '/google_auth.php');

class GoogleSheets {

  public $auth;

  function __construct($ctx) {
    $ctx['scope'] = 'https://spreadsheets.google.com/feeds https://docs.google.com/feeds';
    $this->auth = new GoogleAuth($ctx);
  }

  /*
   * Iterate through every row in the document / worksheet. If callback
   * returns an array, then we assume it's an update to our document
   * and the new values will saved in the row.
   */
  function walk($doc_id, $worksheet_name, $callback) {
    $auth = $this->auth;
    $this->reduce($doc_id, $worksheet_name,
                  function($carry, $item, $entry) use ($callback, $auth, $doc_id){
                    $answer = call_user_func($callback, $item);
                    if(is_array($answer)) {
                      $ns = $entry->getNamespaces(true);
                      $update = <<<EOF
                         <entry xmlns="http://www.w3.org/2005/Atom"
                                xmlns:gsx="http://schemas.google.com/spreadsheets/2006/extended">
                           <id>{$entry->id}</id>
EOF;

                      foreach($answer as $k => $v) {
                        $update .= <<<EOF
                          <gsx:$k><![CDATA[$v]]></gsx:$k>

EOF;
                      }
                      $update .= <<<EOF
                         </entry>
EOF;
                      $entry->registerXPathNamespace('a', 'http://www.w3.org/2005/Atom');
                      $link = $entry->xpath('./a:link[@rel="edit"]');
                      if(!$link) {
                        trigger_error("No edit access has been granted to $doc_id", E_USER_ERROR);
                        return false;
                      }
                      $update_url = $link[0]['href'] . "";
                      $auth->curl('PUT', $update_url, $update, 'raw');
                    }
                  }, false);
  }

  /*
   * Classic map function.  Callback takes in the row, and an array of results of these functions
   * a returned
   */
  function map($doc_id, $worksheet_name, $callback) {
    return $this->reduce($doc_id, $worksheet_name,
                         function($carry, $item, $entry) use ($callback) {
                            $answer = call_user_func($callback, $item);
                            return array_merge($carry, array($answer));
                         }, array());
  }

  /*
   * General purpose iterator. like array_reduce(...) but the arguments include both
   * the spreadsheet data as well as the underlying XML feed entry.
   */
  function reduce($doc_id, $worksheet_name, $callback, $initial) {
    $ws_id = $this->worksheet_id($doc_id, $worksheet_name);

    $feed = $this->auth->curl('GET',
                              "https://spreadsheets.google.com/feeds/list/{$doc_id}/{$ws_id}/private/full",
                              array(), 'xml');

    $results = $initial;
    $ns = $feed->getNamespaces(true);
    foreach($feed->entry as $e) {
      $item = (array)$e->children($ns['gsx']);
      $results = call_user_func($callback, $results, $item, $e);
    }
    
    return $results;
  }

  /*
   * Sort of like map(), but just return back our list of records.
   */
  function rows($doc_id, $worksheet_name) {
    return $this->map($doc_id, $worksheet_name, function($r) { return $r; });
  }

  // Private Stuff ************************************************************************
  
  private function worksheet_id($doc_id, $worksheet_name) {
    $feed = $this->auth->curl('GET',
                                  "https://spreadsheets.google.com/feeds/worksheets/{$doc_id}/private/full",
                                  array(), 'xml');
    foreach($feed->entry as $entry) {
      if($entry->title . "" == $worksheet_name) {
        return preg_replace('|^.*/|', '', $entry->id . "");
      }
    }

    return false;
  }

}

?>