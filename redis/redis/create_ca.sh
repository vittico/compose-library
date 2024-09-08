#!/bin/bash

# Load configuration variables
source ca_config.conf

# Directory structure
CA_DIR="ca_directory"
CSR_DIR="$CA_DIR/certificate_requests"
CERTS_DIR="$CA_DIR/issued_certificates"
CRL_DIR="$CA_DIR/revocation_list"
PRIVATE_DIR="$CA_DIR/private"
NEW_CERTS_DIR="$CA_DIR/newcerts"

mkdir -p $CA_DIR $CSR_DIR $CERTS_DIR $CRL_DIR $PRIVATE_DIR $NEW_CERTS_DIR
chmod 700 $PRIVATE_DIR

# Creating a database to manage certificates
touch $CA_DIR/index.txt
echo 1000 > $CA_DIR/serial

# CA configuration file
cat > $CA_DIR/openssl.cnf <<EOF
[ ca ]
default_ca = CA_default

[ CA_default ]
dir               = $CA_DIR
certs             = $CERTS_DIR
crl_dir           = $CRL_DIR
database          = $CA_DIR/index.txt
new_certs_dir     = $NEW_CERTS_DIR
certificate       = $CA_DIR/ca_cert.pem
serial            = $CA_DIR/serial
crlnumber         = $CA_DIR/crlnumber
crl               = $CRL_DIR/crl.pem
private_key       = $PRIVATE_DIR/ca_key.pem
RANDFILE          = $PRIVATE_DIR/.rand

default_days      = 1825
default_crl_days  = 30
default_md        = sha512
preserve          = no
policy            = policy_any

[ policy_any ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
default_bits        = 4096
default_md          = sha512
default_keyfile     = $PRIVATE_DIR/ca_key.pem
distinguished_name  = ca_distinguished_name
x509_extensions     = v3_ca

[ ca_distinguished_name ]
countryName             = Country Name (2 letter code)
stateOrProvinceName     = State or Province Name (full name)
localityName            = Locality Name (eg, city)
organizationName        = Organization Name (eg, company)
organizationalUnitName  = Organizational Unit Name (eg, section)
commonName              = Common Name (e.g. server FQDN or YOUR name)
emailAddress            = Email Address

[ v3_ca ]
# Extensions for a typical CA
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical,CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

EOF

# Generate CA private key
openssl genrsa -out $PRIVATE_DIR/ca_key.pem 4096

# Generate CA certificate
openssl req -config $CA_DIR/openssl.cnf -key $PRIVATE_DIR/ca_key.pem -new -x509 -days 1825 -sha512 -extensions v3_ca -out $CA_DIR/ca_cert.pem

echo "CA setup complete."

