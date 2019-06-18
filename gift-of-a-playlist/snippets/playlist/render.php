<?php
/*
 * A PHP file for rendering a given playlist
 */


?>
<? foreach($playlist as $entry) { ?>
  <div class="entry">
    <p><?= $entry['message'] ?></p>
    
    <iframe width="560" height="315" src="https://www.youtube.com/embed/<?= $entry['youtube_id']?>" frameborder="0" allowfullscreen></iframe>
  </div>
<? } ?>
