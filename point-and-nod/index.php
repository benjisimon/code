<?
/*
 * Inspired by:
 *  http://www.boredpanda.com/travel-shirt-iconspeak-world/?utm_source=facebook&utm_medium=link&utm_campaign=BPFacebook
 */
require_once('lib/siteconfig.php');
?>
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <?= snippet('layout/css', array('path' => 'css/style.css')); ?>
    <?= snippet('layout/css', array('path' => 'shared/css/font-awesome.min.css')); ?>
    <title>Point and Nod</title>
  </head>
  <body>
    <div class='icons'>
      <?= snippet('icons'); ?>
    </div>
    <?= snippet('layout/js', array('path' => 'shared/js/jquery-2.2.3.min.js')) ?>
    <?= snippet('layout/js', array('path' => 'js/ui.js')); ?>
  </body>
</html>
