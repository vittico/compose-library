#!/bin/bash

# Check if a hostname was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

# Load configuration variables from the root CA config
source ca_config.conf

# The server name is provided as a command-line argument
SERVER_NAME=$1

# Variables for the server certificate
SERVER_DIR="$CA_DIR/servers/$SERVER_NAME"
SERVER_PRIVATE_DIR="$SERVER_DIR/private"
SERVER_CERTS_DIR="$SERVER_DIR/certs"
SERVER_CSR_DIR="$SERVER_DIR/csr"

# Create directories for the server certificate
mkdir -p $SERVER_DIR $SERVER_PRIVATE_DIR $SERVER_CERTS_DIR $SERVER_CSR_DIR
chmod 700 $SERVER_PRIVATE_DIR

# Generate private key for the server (unencrypted)
openssl genrsa -out $SERVER_PRIVATE_DIR/server_key.pem 2048

# Create a CSR for the server
openssl req -new -key $SERVER_PRIVATE_DIR/server_key.pem -out $SERVER_CSR_DIR/server.csr -subj "/C=$CA_COUNTRY/ST=$CA_STATE/L=$CA_LOCALITY/O=$CA_ORG/CN=$SERVER_NAME" -nodes

# Sign the server CSR with the root CA (non-interactive)
openssl ca -config $CA_DIR/openssl.cnf -in $SERVER_CSR_DIR/server.csr -out $SERVER_CERTS_DIR/server_cert.pem -batch

# Export server certificate in common formats
# PEM format (Unix)
cp $SERVER_CERTS_DIR/server_cert.pem $SERVER_DIR/server_cert.pem

# PFX format (Windows)
openssl pkcs12 -export -out $SERVER_DIR/server_cert.pfx -inkey $SERVER_PRIVATE_DIR/server_key.pem -in $SERVER_CERTS_DIR/server_cert.pem -certfile $CA_DIR/ca_cert.pem -passout pass:

# Creating a zip file with the CA chain, server certificate, and key
zip $SERVER_DIR/${SERVER_NAME}.zip $CA_DIR/ca_cert.pem $SERVER_DIR/server_cert.pem $SERVER_PRIVATE_DIR/server_key.pem $SERVER_DIR/server_cert.pfx

echo "Server certificate setup complete for $SERVER_NAME."

