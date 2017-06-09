<?
/*
 * Spit out a timesheet for  a given client
 */
require_once('lib/siteconfig.php');

$debug  = g($_GET, 'debug') == 'on';
$from   = date('Y-m-01', time());
$to     = date('Y-m-d', time());
$month  = date('F Y', time());
$target = g($_GET, 'client');

foreach(all_customers() as $c) {
  if($target && $target != $c['name']) {
    continue;
  }
  $client = fb_client_by_email($c['client_email']);
  $entries = fb_time_entries_by_client($client,
                                       array('filter' => array('date_from' => $from,
                                                             'date_to'   => $to)));
  if(!$entries) {
    continue;
  }

  $html    = snippet('emails/digest', array('customer' => $c,
                                            'entries'  => $entries,
                                            'client'   => $client,
                                            'from'     => $from,
                                            'to'       => $to));
    
  $subject = "[Ideas2Executables] Hours Summary for $month as of " . fmt_date($to);

  if($debug) {
    var_dump(array('to' => $c['to'],
                   'subject' => $subject,
                   'body'    => $html));
  } else {
    xmail($c['to'], $subject, $html);
  }
}
?>
