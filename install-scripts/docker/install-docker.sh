#!/bin/bash

# Sistem güncellemesi
echo "Sistemi güncelliyor..."
sudo apt-get update

# Gerekli paketlerin yüklenmesi
echo "Gerekli paketler yükleniyor..."
sudo apt-get install -y ca-certificates curl software-properties-common

# Docker'ın resmi GPG anahtarını ekleme
echo "Docker GPG anahtarı ekleniyor..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Docker deposunu sisteme ekleme
echo "Docker deposu ekleniyor..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker paketi listesini güncelleme
echo "Paket listesi güncelleniyor..."
sudo apt-get update

# Docker ve gerekli bileşenlerin yüklenmesi
echo "Docker ve gerekli bileşenler yükleniyor..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Kurulumu doğrulama
echo "Docker kurulumu tamamlandı. Versiyonu kontrol ediliyor..."
docker --version

echo "Docker başarıyla yüklendi!"

sudo usermod -aG docker $USER
newgrp docker

