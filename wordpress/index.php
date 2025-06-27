<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
    <div class="headless-info">
        <h1>🚀 Headless WordPress is Running!</h1>
        <p>This WordPress installation is configured for headless use.</p>
        <p>Your frontend application should consume the API endpoints below:</p>
        
        <div class="api-endpoints">
            <h3>Available API Endpoints:</h3>
            <ul>
                <li><strong>REST API:</strong> <code><?php echo home_url('/wp-json/wp/v2/'); ?></code></li>
                <li><strong>Posts:</strong> <code><?php echo home_url('/wp-json/wp/v2/posts'); ?></code></li>
                <li><strong>Pages:</strong> <code><?php echo home_url('/wp-json/wp/v2/pages'); ?></code></li>
                <li><strong>Media:</strong> <code><?php echo home_url('/wp-json/wp/v2/media'); ?></code></li>
            </ul>
        </div>
        
        <div class="admin-notice">
            <p><strong>Admin Panel:</strong> <a href="<?php echo admin_url(); ?>">Access WordPress Admin</a></p>
        </div>
    </div>
    <?php wp_footer(); ?>
</body>
</html>