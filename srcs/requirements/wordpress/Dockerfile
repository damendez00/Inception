FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysqli \
    php7.4-curl \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-zip \
    php7.4-gd \
    php7.4-intl \
    php7.4-soap \
    mariadb-client \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create WordPress files directory
RUN mkdir -p /var/www/html

# Install Wordpress
RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    unzip /tmp/wordpress.zip -d /var/www/html && \
    rm /tmp/wordpress.zip

# Copy wp-config.php to the correct directory
COPY conf/wp-config.php /var/www/html/wordpress/wp-config.php

# Copy PHP-FPM configuration
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# Create directory for socket and logs
RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html /run/php && \
    chmod 755 /run/php

# Copy initialization script
COPY tools/init-wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-wordpress.sh

# Listen for incoming FastCGI requests
# NGINX will foward PHP requests to PHP-FPM on this port
EXPOSE 9000

CMD ["/usr/local/bin/init-wordpress.sh"]