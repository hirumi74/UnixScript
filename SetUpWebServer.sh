#!/bin/bash

# Update package lists and install Apache2
apt update && apt install apache2 -y
echo "Installed Apache2"

# Install and enable the firewall
apt install ufw -y
ufw enable
ufw allow 'Apache'
echo "Enabled firewall and allowed Apache2 in firewall"

# Check if Apache2 service is running, and enable/start if not
if ! systemctl is-active --quiet apache2; then
    systemctl enable apache2
    systemctl start apache2
    echo "Apache2 service started and enabled"
else
    echo "Apache2 service is running normally"
fi

# Create a directory for the test web server
mkdir -p /var/www/testWebserver
echo "Created testWebserver folder"

# Create an index.html file with test content
cat <<EOF > /var/www/testWebserver/index.html
<html>
    <head><title>Test Web Server</title></head>
    <body>
        <p>Test WebServer using script</p>
    </body>
</html>
EOF
echo "Created index.html"

# Create a virtual host configuration file
cat <<EOF > /etc/apache2/sites-available/testWebserver.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName unixubuntu
    ServerAlias unixubuntu
    DocumentRoot /var/www/testWebserver
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
echo "Modified configuration block"

# Enable the new site and disable the default site
a2ensite testWebserver.conf
echo "Enabled testWebserver site"

a2dissite 000-default.conf
echo "Disabled default site"

# Test Apache configuration for syntax errors
apache2ctl configtest

# Restart Apache2 to apply changes
systemctl restart apache2
echo "Apache2 service restarted"
