<?php
/*
 * A PHP file for highlighting the code of a poem
 */
$source = file_get_contents(__DIR__ . "/../../js/poems/$poem.js");

?>
<pre id="code" class="hidden">
<div class="inner"><?= htmlentities($source) ?></div>
</pre>
