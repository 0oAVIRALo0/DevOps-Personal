# DevOps-Personal

## Backend Deployment

- Create an EC2 instance 
- Create key/secret pair for the EC2 instance
- Give SSH key permissions
  ``` 
  chmod 700 key/secret.pem
  ```
- SSH into the EC2 instance using the command provided:
  ```
  ssh -i "key/secret.pem" ubuntu@ec2-65-2-6-23.ap-south-1.compute.amazonaws.com
  ```
- Run the update and upgrade commands
  ```
  sudo apt-get update && upgrade
  ```
- Clone the repository
- Install Node.js (3rd point)
  https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04
- In security group add inbound rule to open the port number on which the server is listening
- Install Nginx
 ```
 sudo apt install nginx
 ```
- Create a nginx configuration file for the server in /etc/nginx/sites-available/custom.conf
- Add reverse proxy for the server running locally 
- By default the nginx server serves the default configuration file. To serve your custom configuration you need to unlink or remove the default configuration file.
  ```
  sudo rm /etc/nginx/sites-enabled/default
  ```
  ```
  sudo unlink /etc/nginx/sites-enabled/default
  ```
- To serve your custom nginx configuration, make a symbolic link to enable it,
  ```
  sudo ln -s /etc/nginx/sites-available/your_config /etc/nginx/sites-enabled/
  ```
- For HTTPS, create a SSL certificate for your domain. You can follow the steps given below:
  https://certbot.eff.org/
- Keep in mind to add an A record (@) and a CNAME record (www) for your doman that points to the IP address of the EC2 instance. 
- Finally, make changes to your nginx configuration file to handle both HTTP as well as HTTPS requests.
