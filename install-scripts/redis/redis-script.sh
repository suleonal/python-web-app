#!/bin/bash

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env dosyası bulunamadı."
    exit 1
fi

POD_NAME=$(kubectl get pods -n $NAMESPACE --no-headers -o custom-columns=":metadata.name" | grep redis) # Redis Pod adı

echo "Redis bağlantısını kontrol ediyor..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD PING > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Redis pod'una bağlanılamadı veya bağlantı başarısız oldu."
    exit 1
fi

echo "Redis bağlantısı başarılı!"

echo "Redis'e test verisi ekleniyor..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD SET test_key "HelloRedis" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Test verisi eklenirken hata oluştu."
    exit 1
fi

echo "Test verisi başarıyla eklendi."

echo "Test verisini okuma..."
TEST_VALUE=$(kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD GET test_key 2>&1 | sed -e 's/^Warning:.*//g' | xargs)

echo " Okunan değer: HG '$TEST_VALUE'"  

EXPECTED_VALUE="HelloRedis"

CLEAN_TEST_VALUE=$(echo "$TEST_VALUE" | tr -d '[:space:]')
CLEAN_EXPECTED_VALUE=$(echo "$EXPECTED_VALUE" | tr -d '[:space:]')

if [ "$CLEAN_TEST_VALUE" == "$CLEAN_EXPECTED_VALUE" ]; then
    echo "Redis bağlantısı ve veri testi başarılı!"
else
    echo "Redis veri testi başarısız oldu."
    echo "Değerler farklı: Okunan değer: '$CLEAN_TEST_VALUE' Beklenen değer: '$CLEAN_EXPECTED_VALUE'"
    exit 1
fi
