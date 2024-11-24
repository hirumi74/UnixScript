## Overview  
This script handles:  
- Apache2 installation and firewall configuration.  
- Creating a custom test web page.  
- Setting up a virtual host and managing default site settings.  

---

### Step 1: Create the Script File  

bash
touch SetUpWebServer.sh
nano SetUpWebServer.sh



---

### Step 2: Copy the Script  
Paste the content below into SetUpWebServer.sh:  

bash
#!/bin/bash

# Update packages and install Apache2
apt update && apt install apache2 -y
echo "Apache2 installed"

# Install and configure UFW
apt install ufw -y
ufw enable
ufw allow 'Apache'
echo "Firewall enabled; Apache traffic allowed"

# Check and manage Apache2 service
if ! systemctl is-active --quiet apache2; then
    systemctl enable apache2
    systemctl start apache2
    echo "Apache2 service started and enabled"
else
    echo "Apache2 is already running"
fi

# Create a directory and test web page
mkdir -p /var/www/testWebserver
echo "Created directory /var/www/testWebserver"

cat <<EOF > /var/www/testWebserver/index.html
<html>
    <head><title>Test Web Server</title></head>
    <body>
        <p>Test WebServer using script</p>
    </body>
</html>
EOF
echo "Test web page created"

# Create a virtual host configuration
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
echo "Virtual host configuration created"

# Enable and manage site configurations
a2ensite testWebserver.conf
a2dissite 000-default.conf
apache2ctl configtest

# Restart Apache2
systemctl restart apache2
echo "Apache2 configuration applied and service restarted"



---

### Step 3: Make the Script Executable  

bash
chmod 777 SetUpWebServer.sh



---

### Step 4: Run the Script  
Execute the script:  

bash
sudo ./SetUpWebServer.sh



---

### Step 5: Verify the Setup  
1. **Visit the Test Page:**  
   Open your browser and visit:  
   

http://<your-server-ip>/

  

2. **Check Apache2 Service:**  
   

bash
   systemctl status apache2

  

---

### Output Examples  

- **Script Execution Output:**  
  ![Script Output](https://github.com/user-attachments/assets/de868aa2-5898-4360-8ef4-4b8dce6e6868)

- **Firewall Status:**  
  ![Firewall Status](https://github.com/user-attachments/assets/8afaa719-3fc4-4793-8286-c65827d84319)

- **Test Web Page:**  
  ![Test Web Page](https://github.com/user-attachments/assets/284d00cd-8576-469b-9864-c49b485d4f3b)

- **Apache2 Service Running:**  
  ![Apache2 Service](https://github.com/user-attachments/assets/ddc8f149-579d-4c6a-9693-57cf85d30d48)

- **Website is Running:**  
  ![image](https://github.com/user-attachments/assets/21dd6e5d-79d2-43c5-a607-1231ba122e77)

### Automating Service Monitoring

To ensure Apache2 remains active and is restarted automatically if it stops, you can use a script to check its status every 5 minutes.  

---

#### Step 1: Create the Monitoring Script  

1. Create a new script file for monitoring:  
   ```bash
   touch MonitorApache.sh
   nano MonitorApache.sh
   ```

2. Add the following script content to `MonitorApache.sh`:  

   ```bash
   #!/bin/bash

   # Check if Apache2 service is running
   if ! systemctl is-active --quiet apache2; then
       systemctl restart apache2
       echo "$(date): Apache2 service restarted" >> /var/log/apache_monitor.log
   else
       echo "$(date): Apache2 service is running normally" >> /var/log/apache_monitor.log
   fi
   ```

---

#### Step 2: Set Permissions  

Make the script executable:  
```bash
chmod 777 checkServices.sh
```

---

#### Step 3: Schedule the Script with Cron  

1. Enter as Root and open the crontab editor:  
   ```bash
   hilmi@unixubuntu:~$ sudo su
   [sudo] password for hilmi:
   root@unixubuntu:/home/hilmi# crontab -e
   ```  

2. Add the following line to run the monitoring script every 5 minutes:  
   ![image](https://github.com/user-attachments/assets/fd1787ca-9856-4319-aedb-c2ff959d9808)
   
3. Save and exit the crontab editor.

---

### Example Output  

- ![image](https://github.com/user-attachments/assets/b8ad0054-5892-4760-922e-8eef6d03c841)

---

### Troubleshooting  

I observed that the script need root in order to be executed. so i have enter root environment where the crontab will be use root priviledge and created automation to check apache services every 5minutes and print the output to log file.
---

### Example Results  

1. **Automation Confirmation:**  
   The following image shows the script running via crontab:  
   ![Root Crontab Running](https://github.com/user-attachments/assets/ecb4546b-faeb-4c2d-aa63-115e6627be42)

2. **Script Execution Success:**  
   This image confirms that the automation script is functioning as expected:  
   ![Automation Output](https://github.com/user-attachments/assets/fa7176ff-4352-46a9-a7f1-d6497edf6f40)

---
