# !/bin/sh
# Use localhost as common name.
openssl genrsa -out private/webclient.key.pem 4096
openssl req -sha256 -config openssl.cnf -new -days 365 -key private/webclient.key.pem -out csrs/webclient.csr.pem
openssl ca -config openssl.cnf -keyfile private/ca.key.pem -cert certs/ca.crt.pem -extensions usr_cert -notext -md sha256 -in csrs/webclient.csr.pem -days 365 -out certs/webclient.crt.pem
openssl ca -keyfile private/ca.key.pem -cert certs/ca.crt.pem -gencrl -out crl/crl.pem
openssl ca -config openssl.cnf  -keyfile private/ca.key.pem -cert certs/ca.crt.pem -gencrl -out crl/crl.pem
openssl req -config openssl.cnf -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout private/apache.key -config server.csr.cnf
openssl x509 -req -in server.csr -CA certs/ca.crt.pem  -CAkey private/ca.key.pem -CAcreateserial -out certs/apache.crt -days 365 -sha256 -extfile v3.ext
