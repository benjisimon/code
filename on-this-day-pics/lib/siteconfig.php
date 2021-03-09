<?php
/*
 * A PHP file for loading our site's configuration
 */

define('CREDENTIALS_JSON', '/var/www/private/on-this-day-pics.credentials.json');

require_once(__DIR__ . '/vendor/autoload.php');
require_once(__DIR__ . '/utils.php');
require_once(__DIR__ . '/oauth2.php');
require_once(__DIR__ . '/photos.php');

session_start();
