<?php
/*
 * A PHP file for doing the work of sifting, pulling out useful stuff from the junk
 */

function sift($path) {
  $dom        = file_get_html($path);
  $body       = $dom->find(SIFT_CONTENT_EXPR, 0);

  $has_style  = $dom->find('*[style]');
  foreach($has_style as $elt) {
    $elt->style = null;
  }

  $has_link  = $dom->find('*[href]');
  foreach($has_link as $elt) {
    if(!preg_match('/^http/', $elt->href)) {
      $elt->href= SIFT_BASE_URL . $elt->href;
    }
  }

  $has_src  = $dom->find('*[src]');
  foreach($has_src as $elt) {
    if(!preg_match('/^http/', $elt->href)) {
      $elt->href= SIFT_BASE_URL . $elt->href;
    }
  }

  $a_tags  = $dom->find('a');
  foreach($a_tags as $a_tag) {
    if(trim(str_replace('&nbsp;', ' ', $a_tag->plaintext)) == '') {
      $a_tag->outertext = '';
    }
  }

  $content    =  $body->innertext;
  $scrubbed   = strip_tags($content, '<a><br>');
  $scrubbed   = preg_replace('|<br +[/]?>|', "\n", $scrubbed);
  $scrubbed   = str_replace('&nbsp;', ' ', $scrubbed);
  $scrubbed   = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n\n", $scrubbed);
  return $scrubbed;
}

?>