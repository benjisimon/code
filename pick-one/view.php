<?php
/*
 * A PHP file for showing a particular photo in the lineup
 */
require_once(__DIR__ . '/lib/siteconfig.php');

$subject = g($_GET, 's');
$lineup  = make_lineup($subject);
$name = g($_GET, 'n');

start_snippet('shell');
?>
<? if(in_array($name, $lineup)) { ?>
  <div class="info">
    <a href="javascript:history.back()">&#8656; Back to all</a>
    This is choice <b><?= lineup_id($subject, $name) ?></b>.
  </div>

  <div class="view">
    <img src="<?= lineup_img_src($subject, $name); ?>"/>
  </div>
<? } else { ?>
  <h1>
    Access Denied 
    ([<?= $subject ?>], [<?= $name ?>])
  </h1>
<? } ?>

<?= end_snippet() ?>
