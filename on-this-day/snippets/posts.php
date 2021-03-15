<?php
/*
 * A PHP file for retrieving posts on a given day and year
 */
$blog_id = g($_GET, 'blog');
if(!$blog_id) {
  $blogs = blogger_all_user_blogs();
} else {
  $posts = blogger_posts_on($blog_id, $today, $year);
}
?>
<? if($blog_id) { ?>
  <? if($posts) { ?>
    <div class="posts">
      <? foreach($posts->items as $i => $p) { ?>
        <p>
          <a href="<?= $p->url ?>"><?= $p->title?></a>
        </p>
      <? } ?>
    </div>
  <? } else { ?>
    <p>
      Nothing published on this date
    </p>
  <? } ?>
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
