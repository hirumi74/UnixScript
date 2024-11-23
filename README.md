```markdown
# UnixScript: Set Up a Basic Web Server

This script automates the installation and configuration of an Apache2 web server on a Unix-based system.

---

## Steps

### 1. Create the Script File
Create a shell script file to house the commands:

```bash
touch SetUpWebServer.sh
nano SetUpWebServer.sh
```

### 2. Copy the Script Content
Paste the following content into `SetUpWebServer.sh`:

```bash
#!/bin/bash

# Update package lists and install Apache2
apt update && apt install apache2 -y
echo "Installed Apache2"

# Allow Apache2 in the firewall
ufw allow 'Apache'
echo "Allowed Apache2 in the firewall"

# Check if Apache2 service is active
if ! systemctl is-active --quiet apache2; then
    systemctl enable apache2
    systemctl start apache2
    echo "Apache2 service started and enabled"
else
    echo "Apache2 service is running normally"
fi

# Create a directory for the test web server
mkdir -p /var/www/testWebserver
echo "Created testWebServer folder"

# Create an index.html file in the testWebserver directory
cat <<EOF > /var/www/testWebserver/index.html
<html>
    <head><title>Test Web Server</title></head>
    <body>
        <p>testWebServer using script</p>
    </body>
</html>
EOF
echo "Created index.html"

# Create a new Apache virtual host configuration
cat <<EOF > /etc/apache2/sites-available/testWebserver.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName unixubuntu
    ServerAlias www.your_domain
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

# Test Apache configuration for errors
apache2ctl configtest

# Restart Apache2 to apply changes
systemctl restart apache2
echo "Apache2 service restarted"
```

---

### 3. Grant Execution Permission
Make the script executable:
```bash
chmod +x SetUpWebServer.sh
```

---

### 4. Execute the Script
Run the script to automatically install and configure the web server:
```bash
sudo ./SetUpWebServer.sh
```

Example output:
![Setup Output](https://github.com/user-attachments/assets/de868aa2-5898-4360-8ef4-4b8dce6e6868)

---

### 5. Verify Web Server
After execution, the Apache2 web server will host a test page located at `/var/www/testWebserver/index.html`. Visit `http://<your-server-ip>/` to see the web server in action.

Example:
![Basic Webserver](https://github.com/user-attachments/assets/1f1478ab-8fbd-423f-bcc1-8c77d6efb89a)

---

### Notes:
- Ensure the `ufw` (firewall utility) is installed to allow Apache traffic.
- Update the `ServerName` and `ServerAlias` in the virtual host configuration to suit your domain or server settings.
- Run `systemctl reload apache2` after enabling/disabling sites to apply changes.

Happy scripting!
```
