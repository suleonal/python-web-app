#!/bin/bash

# Terraform Yükleme Scripti

echo "Terraform yükleme işlemi başlıyor..."

# Gerekli paketlerin güncellenmesi
echo "Sistem güncelleniyor..."
sudo apt-get update -y

# Gerekli bağımlılıkların yüklenmesi
echo "Gerekli bağımlılıklar yükleniyor..."
sudo apt-get install -y software-properties-common gnupg

# HashiCorp GPG anahtarını ekleme
echo "HashiCorp GPG anahtarı ekleniyor..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# HashiCorp deposunu ekleme
echo "HashiCorp deposu ekleniyor..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Paket listesi güncelleniyor
echo "Paket listesi güncelleniyor..."
sudo apt-get update -y

# Terraform'un yüklenmesi
echo "Terraform yükleniyor..."
sudo apt-get install -y terraform

# Yüklemenin doğrulanması
echo "Yükleme tamamlandı. Terraform sürümü:"
terraform -v

echo "Terraform başarıyla yüklendi!"

