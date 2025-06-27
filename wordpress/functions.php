<?php
add_action('wp_enqueue_scripts', 'remove_default_styles');
function remove_default_styles() {
    wp_dequeue_style('wp-block-library');
    wp_dequeue_style('wp-block-library-theme');
}

add_theme_support('post-thumbnails');
add_theme_support('title-tag');
add_theme_support('custom-logo');

add_action('rest_api_init', function () {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
});

function enable_cors() {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
    
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        exit(0);
    }
}
add_action('init', 'enable_cors');

function add_custom_post_types_to_api() {
    register_post_type('page', array(
        'show_in_rest' => true,
        'rest_base' => 'pages'
    ));
}
add_action('init', 'add_custom_post_types_to_api');

function enqueue_headless_theme_assets() {
    wp_enqueue_style('headless-theme', get_template_directory_uri() . '/style.css');
}
add_action('wp_enqueue_scripts', 'enqueue_headless_theme_assets');
?>