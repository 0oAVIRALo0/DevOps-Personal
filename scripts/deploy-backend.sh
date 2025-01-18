#!/bin/bash

# Exit script on any error
set -e

# Ask for user inputs
read -p "Enter your domain name or public IP address: " DOMAIN_NAME
read -p "Enter the URL of the Git repository to clone: " REPO_URL

# Update the system
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Install necessary dependencies
echo "Installing dependencies..."
sudo apt install -y docker.io docker-compose nginx nodejs npm

# Enable and start Docker
echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Create your Node.js in /var/www/backend
echo "Setting up Node.js backend project..."
sudo mkdir -p /var/www/backend
sudo chown -R $USER:$USER /var/www/backend

# Git clone the repository
echo "Cloning backend repository..."
git clone "$REPO_URL" /var/www/backend

# Navigate to the project directory
cd /var/www/backend/test/server

# Build Docker image from the Dockerfile
echo "Building Docker image..."
docker build -t nodejs-backend .

# Run the Docker container
echo "Running Docker container..."
docker run -d --name nodejs-backend-instance -p 3000:3000 nodejs-backend

# Configure Nginx for reverse proxy
echo "Configuring Nginx for reverse proxy..."
cat <<EOL | sudo tee /etc/nginx/sites-available/nodejs-backend
server {
    listen 80;

    server_name $DOMAIN_NAME;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Enable the Nginx configuration
echo "Enabling Nginx configuration..."
sudo unlink /etc/nginx/sites-enabled/default || true
sudo ln -s /etc/nginx/sites-available/nodejs-backend /etc/nginx/sites-enabled/

# Test the Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Restart Nginx to apply changes
echo "Restarting Nginx..."
sudo nginx -s reload

echo "Deployment complete. Your Node.js backend is now running and accessible through Nginx!"
