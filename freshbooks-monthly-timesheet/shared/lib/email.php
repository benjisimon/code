<?
/*
 * A warpper for easy sending of email
 */

require('Mail.php');
require('Mail/mime.php');

function xmail($to, $subject, $body) {
  $message = snippet(EMAIL_SHELL, array('body' => $body));
  $hdrs    = array('From' => EMAIL_FROM,
                   'Subject' => $subject);

  $mime = new Mail_mime(array('eol' => $crlf));
  $mime->setTXTBody(strip_tags($html));
  $mime->setHTMLBody($message);

  $body = $mime->get();
  $hdrs = $mime->headers($hdrs);

  $mail =& Mail::factory('mail');
  $mail->send($to, $hdrs, $body);
}
