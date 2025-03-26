#!/bin/bash

echo "🚀 Starting WordPress initialization script..."

# Verify and set permissions for dirs
echo "🔧 Verifying directory permissions..."
mkdir -p /run/php
chown -R www-data:www-data /run/php /var/www/html
chmod 755 /run/php

# Connect to MariaDB server
echo "⌛ Waiting for MariaDB to be available..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if mysql -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" -e "SELECT 1" &>/dev/null; then
        echo "✅ MariaDB connection established"
        break
    fi
    echo "⏳ Attempt $attempt of $max_attempts - Waiting for MariaDB..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "❌ Error: Could not connect to MariaDB after $max_attempts attempts"
    exit 1
fi

cd /var/www/html/wordpress
echo "📂 Current directory: $(pwd)"

# Continue setting permissions and ownership
# dir: group and others have read and exec
# files: group and others have read permissions
echo "🔧 Configuring advanced permissions..."
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chown -R www-data:www-data /var/www/html

# Create wp-config.php if it doesnt exist
if [ ! -f wp-config.php ]; then
    echo "📝 Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root
    echo "✅ wp-config.php created"
fi

# Instal WordPress if not installed
if ! wp core is-installed --allow-root; then
    echo "🔧 Installing WordPress..."
    
    # Install WordPress
    wp core install \
        --url="${WP_SITE_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    
    echo "👤 Creating secondary user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    echo "✅ WordPress installed successfully"
    echo "🔑 Admin credentials:"
    echo "   Username: ${WP_ADMIN_USER}"
    echo "   Password: ${WP_ADMIN_PASSWORD}"
    echo "🔑 Secondary user credentials:"
    echo "   Username: ${WP_USER}"
    echo "   Password: ${WP_USER_PASSWORD}"

    # Check and activate the default theme
    wp theme activate twentytwentyone --allow-root || true

    # Clean caché
    wp cache flush --allow-root || true
fi

# Before starting PHP-FPM, verify the configuration
echo "🔍 Verifying PHP-FPM configuration..."
php-fpm7.4 -t

# Start PHP-FPM in foreground 
echo "🚀 Starting PHP-FPM..."
exec php-fpm7.4 -F -R