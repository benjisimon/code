<?php
/*
 * A PHP file for implementing a simple navbar
 */
$pages = array(
  'info/time'                => 'Current Time',
  'info/temperature'         => 'Temperature',
  'info/gravitational-force' => 'Gravitational Force'
);
?>
<ul>
  <? foreach($pages as $uri => $label) { ?>
    <li>
      <a href="<?= app_url($uri) ?>"><?= $label ?></a>
    </li>
  <? } ?>
  <div class="clear"></div>
</ul>
