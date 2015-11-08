<?
/*
 * Spit out a timesheet for  a given client
 */
require_once('lib/siteconfig.php');

$token = g($_GET, 't');
$email = token_to_email($token);
if(!$email) {
  die("Access denied");
}
$from   = date('Y-m-01', time());
$to     = date('Y-m-d', time());
$client = fb_client_by_email($email);
$entries = fb_time_entries_by_client($client,
                                     array('filter' => array('date_from' => $from,
                                                             'date_to'   => $to)));
$total   = array_reduce($entries,
                        function($carry, $item) {
                          return $carry + $item['hours'];
                        }, 0);
?>
<p>
 Total Hours for <?= fmt_date($from) ?> - <?= fmt_date($to) ?>: <?= $total ?>
</p>

<ul>
  <? foreach($entries as $e) { ?>
    <li><?= fmt_date($e['date']) ?> <?= fmt_hours($e['hours']) ?>: <?= $e['notes'] ?></li> 
  <? } ?>
</ul>
