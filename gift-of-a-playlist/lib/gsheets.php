<?php
/*
 * A PHP file for working with google sheets
 */

function gsheet_doc_url_to_id($doc_url) {
  if(preg_match('|^.*/d/(.*?)/edit|', $doc_url, $matches)) {
    return $matches[1];
  } else if(preg_match('|^.*/d/e/(.*?)/pubhtml|', $doc_url, $matches)) {
    return $matches[1];
  } else {
    return false;
  }
}

function gsheet_sheet_map($doc_id) {
  $ch   = curl_init("https://spreadsheets.google.com/feeds/worksheets/$doc_id/public/full");
  curl_setopt($ch, CURLOPT_TIMEOUT, 6);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $xml  = curl_exec($ch);
  $feed = simplexml_load_string($xml);
  $map  = [];

  foreach($feed->entry as $entry) {
    if(preg_match('|^.*/public/full/(.*)|', $entry->id . "", $matches)) {
      $map[$matches[1]] = $entry->title . "";
    }
  }

  return $map;
}

function gsheet_playlist($doc_id, $sheet_id) {
  $ch   = curl_init("https://spreadsheets.google.com/feeds/list/$doc_id/$sheet_id/public/full");
  curl_setopt($ch, CURLOPT_TIMEOUT, 6);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $xml  = curl_exec($ch);
  $feed = simplexml_load_string($xml);
  $playlist  = [];

  foreach($feed->entry as $entry) {
    $ns = $entry->getNamespaces(true);
    $attrs = $entry->children($ns['gsx']);
    $playlist[] = [
      'youtube_id' => youtube_video_id($attrs->video . ""),
      'message' => $attrs->message . ""
    ];
  }

  return $playlist;
}

function youtube_video_id($url) {
  $params = [];
  parse_str(g(parse_url($url), 'query', ''), $params);

  if(preg_match('^|https://youtu.be/(.*)|', $url, $matches)) {
    return $matches[1];
  } else if(preg_match('|youtube.com/embed/(.*)|', $url, $matches)) {
    return $matches[1];
  } else if(($id = g($params, 'v'))) {
    return $id;
  } else {
    return false;
  }
}
?>
