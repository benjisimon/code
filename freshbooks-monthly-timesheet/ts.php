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
$client = fb_client_by_email($email);
$entries = fb_time_entries_by_client($client);
$total   = array_reduce($entries,
                        function($carry, $item) {
                          return $carry + $item['hours'];
                        }, 0);
?>
<p>
 Total Hours for the Month: <?= $total ?>
</p>

<ul>
  <? foreach($entries as $e) { ?>
    <li><?= fmt_date($e['date']) ?> <?= fmt_hours($e['hours']) ?>: <?= $e['notes'] ?></li> 
  <? } ?>
</ul>
