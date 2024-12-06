#!/bin/bash

# Download and save the Helm GPG key
echo "Downloading Helm GPG key..."
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

# Install APT transport-https
echo "Installing APT transport-https..."
sudo apt-get install apt-transport-https --yes

# Add Helm repository to APT sources list
echo "Adding Helm repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install Helm
echo "Installing Helm..."
sudo apt-get install helm --yes

# Check the installed Helm version
echo "Checking Helm version..."
helm version


 helm repo add bitnami https://charts.bitnami.com/bitnami

