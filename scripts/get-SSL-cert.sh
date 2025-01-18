#!/bin/bash

# Exit script on any error
set -e

# Ask for user inputs
read -p "Enter your domain name: " DOMAIN_NAME
read -p "Enter your email address for the SSL Certificate: " EMAIL_ADDRESS

# Updating the system
echo "Updating the system..."
sudo apt update

# Installing system dependencies
echo "Installing system dependencies..."
sudo apt install -y python3 python3-venv libaugeas0

# Remove certbot-auto and any Certbot OS packages
echo "Removing old Certbot packages if present..."
sudo apt-get remove -y certbot || true

# Set up a Python virtual environment
echo "Setting up Python virtual environment..."
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip

# Install Certbot
echo "Installing Certbot..."
sudo /opt/certbot/bin/pip install certbot certbot-nginx

# Prepare the Certbot command
if [ ! -f /usr/bin/certbot ]; then
    echo "Linking Certbot binary to /usr/bin/certbot..."
    sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
fi

# Get and install your certificates
echo "Obtaining certificates..."
sudo certbot --nginx --non-interactive --agree-tos --email $EMAIL_ADDRESS -d $DOMAIN_NAME

# Set up automatic renewal (avoid duplicate crontab entries)
echo "Setting up automatic renewal..."
if ! grep -q "certbot renew" /etc/crontab; then
    echo "0 0,12 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && sudo certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
else
    echo "Renewal job already exists in crontab."
fi

# Optional: Set up monthly Certbot upgrade
echo "Setting up monthly Certbot upgrade..."
if ! grep -q "certbot upgrade" /etc/crontab; then
    echo "@monthly root /opt/certbot/bin/pip install --upgrade certbot certbot-nginx" | sudo tee -a /etc/crontab > /dev/null
else
    echo "Monthly Certbot upgrade job already exists in crontab."
fi

echo "Certbot installation and renewal setup completed."
