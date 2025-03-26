<?php
// Database configuration
define('DB_NAME', getenv('MYSQL_DATABASE'));
define('DB_USER', getenv('MYSQL_USER'));
define('DB_PASSWORD', getenv('MYSQL_PASSWORD'));
define('DB_HOST', 'mariadb');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Enable debug mode
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
@ini_set('display_errors', 1);

define ( 'WP_MEMORY_LIMIT', '256M' );

// Table prefix
$table_prefix = 'wp_';

// URLs configuration, determine if site is being
// accessed over HTTPS or HTTP
if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') {
    $protocol = "https://";
} else {
    $protocol = "http://";
}

// Ensure that WordPress generates the correct URLs for the site.
$server_name = isset($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] : 'localhost';
define('WP_HOME', $protocol . $server_name);
define('WP_SITEURL', $protocol . $server_name);

/*
If the site is accessed via https://example.com, the following will happen:

$_SERVER['HTTPS'] will be 'on', so $protocol will be set to "https://".
$_SERVER['SERVER_NAME'] will be 'example.com', so $server_name will be set to 'example.com'.
WP_HOME and WP_SITEURL will both be set to "https://example.com".
*/

// Ensure all admin pages are accessed over HTTPS
define('FORCE_SSL_ADMIN', true);

// Check protocol header used by client
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
    $_SERVER['HTTPS']='on';

// Show PHP errors
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Absolute path to the WordPress directory.
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

// Sets up WordPress vars and included files.
require_once(ABSPATH . 'wp-settings.php');
