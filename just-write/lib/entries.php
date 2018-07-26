<?php
/*
 * A PHP file for working with our writing entries. An entry is text and e-mail address to
 * associate the text with.
 */

define('ENTRY_SEND_AFTER', 60*60*24*7);

function new_entry($email, $content) {
  $s = the_storage();
  $s->insert()->in('entries')->set(['email' => $email, 
                                    'content' => $content, 
                                    'created' => time(),
                                    'id' => md5($email . $content . time())])->execute();
}

function entries_send($email) {
  $s = the_storage();
  $entries = $s->read()->in('entries')
           ->where('email', '=', $email)
           ->where('created', '<', time() - ENTRY_SEND_AFTER)
           ->get();

  $sent = 0;
  foreach($entries as $e) {
    $composed = date('c', $e['created']);
    $ok = mail($email, "[JustWrite] Your " . date('F, nS', $e['created']) . " JustWrite Entry",
               "Composed: $composed\n\n" . $e['content'] . "\n\n--JustWrite");
    $sent += ($ok ? 1 : 0);
    if($ok) {
      $s->delete()->in('entries')->where('id', '=', $e['id'])->execute();
    }
  }

  return $sent;
}


?>