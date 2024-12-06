#!/bin/bash

echo "Updating package lists..."
sudo apt-get update

echo "Installing prerequisites..."
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "Adding Kubernetes GPG key..."
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "Adding Kubernetes apt repository..."
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package lists after adding Kubernetes repo..."
sudo apt-get update

echo "Installing kubectl..."
sudo apt-get install -y kubectl

echo "Verifying kubectl installation..."
kubectl version --client

echo "kubectl installation completed successfully!"

