#!/bin/bash

sudo dnf update
sudo dnf install java-17-amazon-corretto -y

# Add the Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import the Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
sudo dnf install jenkins -y

# create and install a self signed certificate
sudo su jenkins
mkdir /var/lib/jenkins/.ssl
cd /var/lib/jenkins/.ssl
keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore /var/lib/jenkins/.ssl/server.jks

# Start the Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins
