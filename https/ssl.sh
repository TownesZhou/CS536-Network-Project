#!/bin/bash

PROJECT_NAME="https Project"

# Generate the openssl configuration files.
cat > ca_cert.conf << EOF
[ req ]
distinguished_name     = req_distinguished_name
prompt                 = no

[ req_distinguished_name ]
 O                      = $PROJECT_NAME Certificate Authority
EOF

cat > server_cert.conf << EOF
[ req ]
distinguished_name     = req_distinguished_name
prompt                 = no

[ req_distinguished_name ]
 O                      = $PROJECT_NAME
 CN                     = 
EOF

cat > client_cert.conf << EOF
[ req ]
distinguished_name     = req_distinguished_name
prompt                 = no

[ req_distinguished_name ]
 O                      = $PROJECT_NAME Device Certificate
 CN                     = 
EOF

mkdir ca
# mkdir server
# mkdir client

# 生成私钥
openssl genrsa -out ca.key 2048
openssl genrsa -out server.key 2048
openssl genrsa -out client.key 2048

# 根据私钥创建证书请求文件，需要输入一些证书的元信息：邮箱、域名等
openssl req -out ca.req -key ca.key -new -config ./ca_cert.conf -nodes -subj '/CN=10.0.0.1'
openssl req -out server.req -key server.key -new -config ./server_cert.conf -nodes -subj '/CN=10.0.0.1'
openssl req -out client.req -key client.key -new -config ./client_cert.conf -nodes -subj '/CN=10.0.0.2'

# 结合私钥和请求文件，创建自签署证书
openssl x509 -req -in ca.req -out ca.crt -sha1 -days 5000 -signkey ca.key
openssl x509 -req -in server.req -out server.crt -sha1 -CAcreateserial -days 5000 -CA ca.crt -CAkey ca.key
openssl x509 -req -in client.req -out client.crt -sha1 -CAcreateserial -days 5000 -CA ca.crt -CAkey ca.key

mv ca.crt ca.key ca/
mv server.crt server.key h1/
mv client.crt client.key h2/

rm *.conf
rm *.req
rm *.srl