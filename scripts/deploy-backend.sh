#!/bin/bash

# Exit script on any error
set -e

# Update the system
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Install necessary dependencies
echo "Installing dependencies..."
sudo apt install -y docker.io docker-compose nginx

# Enable and start Docker
echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to the Docker group (requires logout/login to take effect)
echo "Adding current user to Docker group..."
sudo usermod -aG docker $USER

# Clone or copy your Node.js backend project to /var/www/backend
echo "Setting up Node.js backend project..."
sudo mkdir -p /var/www/backend
sudo chown -R $USER:$USER /var/www/backend

# Copy project files (assumes they're in the same directory as this script)
cp -r ./backend/* /var/www/backend/

# Navigate to the project directory
cd /var/www/backend

# Build Docker image from the Dockerfile
echo "Building Docker image..."
docker build -t nodejs-backend .

# Run the Docker container
echo "Running Docker container..."
docker run -d --name nodejs-backend -p 3000:3000 nodejs-backend

# Configure Nginx for reverse proxy
echo "Configuring Nginx for reverse proxy..."
cat <<EOL | sudo tee /etc/nginx/sites-available/nodejs-backend
server {
    listen 80;

    server_name your_domain_or_ip;

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
sudo ln -s /etc/nginx/sites-available/nodejs-backend /etc/nginx/sites-enabled/

# Test the Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Restart Nginx to apply changes
echo "Restarting Nginx..."
sudo systemctl restart nginx

echo "Deployment complete. Your Node.js backend is now running and accessible through Nginx!"
