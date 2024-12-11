#!/bin/bash

# .env dosyasını yükle
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env dosyası bulunamadı."
    exit 1
fi

# PostgreSQL pod adını al
POD_NAME=$(kubectl get pods -n $NAMESPACE | grep 'postgres-postgresql-' | awk '{print $1}' | head -n 1)

if [ -z "$POD_NAME" ]; then
    echo "PostgreSQL pod'u bulunamadı. Pod'un çalıştığından ve 'app=postgresql' etiketine sahip olduğundan emin olun."
    exit 1
fi

echo "PostgreSQL pod'u bulundu: $POD_NAME"

# PostgreSQL bağlantısını kontrol et
echo "PostgreSQL bağlantısını kontrol ediyor..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -c "\conninfo"
if [ $? -ne 0 ]; then
    echo "PostgreSQL pod'una bağlanılamadı veya bağlantı başarısız oldu."
    exit 1
fi
echo "PostgreSQL bağlantısı başarılı!"

# Test veritabanını oluştur
echo "Test veritabanını oluşturuyor..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -c "CREATE DATABASE $PG_DB;" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Test veritabanı oluşturulamadı. Veritabanı zaten mevcut olabilir."
else
    echo "Test veritabanı başarıyla oluşturuldu."
fi

# Tablo oluşturup veri ekle
echo "Tablo oluşturup veri ekliyor..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -d $PG_DB <<EOF
CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO test_table (name) VALUES ('Test User');
EOF

if [ $? -ne 0 ]; then
    echo "Tablo oluşturma veya veri ekleme işlemi başarısız oldu."
    exit 1
else
    echo "Tablo ve veri başarıyla oluşturuldu."
fi

# Veritabanından veri sorgula
echo "Veritabanından veri sorguluyor..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -d $PG_DB -c "SELECT * FROM test_table;"

# Temizlik yap
echo "Temizlik yapılıyor..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -c "DROP DATABASE $PG_DB;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Test veritabanı başarıyla silindi."
else
    echo "Test veritabanı silinemedi."
fi

echo "PostgreSQL Kubernetes test scripti tamamlandı."

