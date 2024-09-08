#!/bin/bash

# Step 1: Create the CA
mkdir -p myCA
openssl genrsa -out myCA/ca.key 2048
openssl req -x509 -new -nodes -key myCA/ca.key -sha256 -days 1024 -out myCA/ca.crt -subj "/CN=RedisCA"

# Step 2: Generate private keys and self-signed certificates for each Redis node
for i in {1..3}; do
    mkdir -p redis$i
    openssl genrsa -out redis$i/redis$i.key 2048
    openssl req -new -key redis$i/redis$i.key -out redis$i/redis$i.csr -subj "/CN=redis$i"
    openssl x509 -req -in redis$i/redis$i.csr -CA myCA/ca.crt -CAkey myCA/ca.key -CAcreateserial -out redis$i/redis$i.crt -days 500 -sha256
done

echo "CA and certificates for Redis nodes created."

