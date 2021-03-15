<?php
/*
 * A PHP file for retrieving posts on a given day and year
 */
$blog = g($_GET, 'blog');
if(!$blog) {
  $blogs = blogger_all_user_blogs();
} else {
  // XXX - get posts
  $posts = false;
}
?>
<? if($blog) { ?>
  <p>
    Would get posts for <? var_dump($today); ?> on <?= $year ?>.
  </p>
<? } else { ?>
  <p>
    Select a blog:
  </p>

  <ul>
    <? foreach($blogs as $b) { ?>
      <li>
        <a href="<?= app_url("", ['subject' => 'posts', 'blog' => $b->id])?>"><?= $b->url?></a>
      </li>
    <? } ?>
  </ul>
<? } ?>
