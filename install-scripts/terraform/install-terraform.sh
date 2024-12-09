#!/bin/bash


echo "Terraform yükleme işlemi başlıyor..."

echo "Sistem güncelleniyor..."
sudo apt-get update -y

echo "Gerekli bağımlılıklar yükleniyor..."
sudo apt-get install -y software-properties-common gnupg

echo "HashiCorp GPG anahtarı ekleniyor..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "HashiCorp deposu ekleniyor..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

echo "Paket listesi güncelleniyor..."
sudo apt-get update -y

echo "Terraform yükleniyor..."
sudo apt-get install -y terraform

echo "Yükleme tamamlandı. Terraform sürümü:"
terraform -v

echo "Terraform başarıyla yüklendi!"

