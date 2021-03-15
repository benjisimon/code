<?php
/*
 * A PHP file for loading our site's configuration
 */

date_default_timezone_set('America/New_York');
define('CREDENTIALS_JSON', '/var/www/private/on-this-day-pics.credentials.json');

require_once(__DIR__ . '/vendor/autoload.php');
require_once(__DIR__ . '/utils.php');
require_once(__DIR__ . '/oauth2.php');
require_once(__DIR__ . '/photos.php');
require_once(__DIR__ . '/blogger.php');

session_start();
