<?php
/*
 * A PHP file for promting for sheet selection
 */
$sheets = gsheet_sheet_map($doc_id);
?>
<div class="prompt">
  <p>
    Select a sheet within the document:
  </p>

  <ul>
    <? foreach($sheets as $sheet_id => $title) { ?>
      <li>
        <a href="index.php?d=<?= $doc_id?>&s=<?= $sheet_id?>"><?= $title ?></a>
      </li>
    <? } ?>
  </ul>
</div>
