<?php
/*
 * A PHP file for being our top level access to the 'pick-one' app
 */
require_once(__DIR__ . '/lib/siteconfig.php');

$subject = g($_GET, 's');
$lineup = make_lineup($subject);

start_snippet('shell');
?>
<? if($lineup) { ?>
  <div class="instructions">
    Click on the images below to zoom in.
  </div>

  <div class="previews">
    <? foreach($lineup as $i => $name) { ?>
      <div class="frame">
        <div class="id"><?= lineup_id($subject, $name) ?></div>
        <a href="<?= lineup_view_href($subject, $name)?>">
          <img src="<?= lineup_img_src($subject, $name) ?>"/>
        </a>
      </div>
    <? } ?>
  </div>
<? } else {  ?>
  <h1>Access Denied [<?= g($_GET, 's')?>].</h1>
<? } ?>

<?= end_snippet() ?>
