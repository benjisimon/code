<?php
/*
 * A PHP file for rendering a given playlist
 */


?>
<? foreach($playlist as $entry) { ?>
  <div class="entry">
    <p><?= $entry['message'] ?></p>

    <div class="video-container video" style="display: none">
      <iframe width="560" height="315" src="https://www.youtube.com/embed/<?= $entry['youtube_id']?>" frameborder="0" allowfullscreen></iframe>
    </div>

    <div class="video-container placeholder">
      <div class="cover">
        <input type="button" value="Reveal!" />
      </div>
    </div>
  </div>
<? } ?>
