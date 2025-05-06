#!/bin/bash

# Update and upgrade system
echo "Updating and upgrading system packages..."
sudo apt update -y && sudo apt upgrade -y

# Install PostgreSQL and other required packages
echo "Installing PostgreSQL and other dependencies..."
sudo apt install -y postgresql postgresql-client postgresql-contrib
sudo apt install -y nano git wget curl ufw maven
sudo apt install -y openjdk-8-jdk

# Download and install Tomcat 9
echo "Downloading and installing Tomcat 9..."
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.14/bin/apache-tomcat-9.0.14.tar.gz

# Create Tomcat directory and extract
sudo mkdir -p /opt/apache-tomcat9
sudo tar xzvf apache-tomcat-9.0.14.tar.gz -C /opt/apache-tomcat9 --strip-components=1

# Create tomcat user and group
echo "Creating tomcat user and group..."
sudo groupadd tomcat || true
sudo useradd -s /bin/false -g tomcat -d /opt/apache-tomcat9 tomcat || true

# Adjust permissions
echo "Setting up permissions..."
cd /opt/apache-tomcat9
sudo chown -R tomcat: /opt/apache-tomcat9
sudo chmod +x /opt/apache-tomcat9/bin/*.sh

# Configure PostgreSQL
echo "Configuring PostgreSQL..."
sudo -u postgres psql <<EOF
CREATE DATABASE "ss_demo_1";
ALTER USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE "ss_demo_1" TO postgres;
\q
EOF

# Verify PostgreSQL configuration
echo "Verifying PostgreSQL setup..."
sudo -u postgres psql -c "\l"
sudo -u postgres psql -c "\du"

# Start Tomcat
echo "Starting Tomcat..."
sudo sh /opt/apache-tomcat9/bin/startup.sh

echo "Installation and configuration complete!"