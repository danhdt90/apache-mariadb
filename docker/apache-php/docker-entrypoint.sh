#!/bin/bash
set -e

# Create log directories if they don't exist
mkdir -p /var/log/apache2 /var/log/php

# Set proper permissions
chown -R www-data:www-data /var/www/html /var/log/apache2 /var/log/php
chmod -R 755 /var/www/html

# Enable SSL site if SSL certificates exist
if [ -f /etc/ssl/certs/ssl-cert-snakeoil.pem ]; then
    a2ensite default-ssl
    a2enmod ssl
fi

# Display environment info
echo "=== LAMP Stack Starting ==="
echo "PHP Version: $(php -v | head -n 1)"
echo "Apache Version: $(apache2 -v | head -n 1)"
echo "Database Host: ${DB_HOST:-localhost}"
echo "Document Root: /var/www/html"
echo "=========================="

# Execute the main command
exec "$@"