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
$projects = fb_projects_by_client($client);
?>
<? foreach($projects as $p) { ?>
  <? $entries = fb_time_entries_by_project($p); ?>
  <? foreach($entries as $e) { ?>
    <li><?= $e['date'] ?> <?= $e['hours'] ?>hrs: <?= $e['notes'] ?></li> 
  <? } ?>
<? } ?>

