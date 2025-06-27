<?php
define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'root');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: '');
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'localhost');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

define('AUTH_KEY',         getenv('WORDPRESS_AUTH_KEY') ?: 'put your unique phrase here');
define('SECURE_AUTH_KEY',  getenv('WORDPRESS_SECURE_AUTH_KEY') ?: 'put your unique phrase here');
define('LOGGED_IN_KEY',    getenv('WORDPRESS_LOGGED_IN_KEY') ?: 'put your unique phrase here');
define('NONCE_KEY',        getenv('WORDPRESS_NONCE_KEY') ?: 'put your unique phrase here');
define('AUTH_SALT',        getenv('WORDPRESS_AUTH_SALT') ?: 'put your unique phrase here');
define('SECURE_AUTH_SALT', getenv('WORDPRESS_SECURE_AUTH_SALT') ?: 'put your unique phrase here');
define('LOGGED_IN_SALT',   getenv('WORDPRESS_LOGGED_IN_SALT') ?: 'put your unique phrase here');
define('NONCE_SALT',       getenv('WORDPRESS_NONCE_SALT') ?: 'put your unique phrase here');

$table_prefix = 'wp_';

define('WP_DEBUG', getenv('WP_DEBUG') === 'true');
define('WP_DEBUG_LOG', getenv('WP_DEBUG_LOG') === 'true');
define('WP_DEBUG_DISPLAY', false);

define('DISALLOW_FILE_EDIT', true);
define('DISALLOW_FILE_MODS', true);
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', false);

define('WP_DISABLE_FATAL_ERROR_HANDLER', true);
define('DISALLOW_UNFILTERED_HTML', true);
define('DISABLE_WP_CRON', true);

define('WP_CONTENT_URL', '/wp-content');
define('WP_PLUGIN_URL', WP_CONTENT_URL . '/plugins');

define('COOKIE_DOMAIN', getenv('WORDPRESS_COOKIE_DOMAIN') ?: $_SERVER['HTTP_HOST']);
define('COOKIEHASH', md5(COOKIE_DOMAIN));

if (getenv('WORDPRESS_BLOCK_EXTERNAL_URL_ACCESS') === 'true') {
    define('WP_HTTP_BLOCK_EXTERNAL', true);
}

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
    define('FORCE_SSL_ADMIN', true);
}

define('WP_HOME', getenv('WORDPRESS_HOME_URL') ?: 'https://' . $_SERVER['HTTP_HOST']);
define('WP_SITEURL', WP_HOME);

if (getenv('WORDPRESS_HIDE_ADMIN') === 'true') {
    define('WP_ADMIN_DIR', getenv('WORDPRESS_ADMIN_PATH') ?: 'secure-admin');
    define('WP_ADMIN_URL', WP_HOME . '/' . WP_ADMIN_DIR);
}

ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', '/var/log/wordpress-errors.log');

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
?>