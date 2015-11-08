<?
/*
 * Spit out a timesheet for  a given client
 */
require_once('lib/siteconfig.php');

$from   = date('Y-m-01', time());
$to     = date('Y-m-d', time());

foreach(all_customers() as $c) {
  $client = fb_client_by_email($c['client_email']);
  $entries = fb_time_entries_by_client($client,
                                       array('filter' => array('date_from' => $from,
                                                             'date_to'   => $to)));
  $total   = array_reduce($entries,
                          function($carry, $item) {
                            return $carry + $item['hours'];
                          }, 0);
  $html    = snippet('emails/digest', array('customer' => $c,
                                            'entries'  => $entries,
                                            'client'   => $client,
                                            'from'     => $from,
                                            'to'       => $to));
  echo $html;
}
?>
