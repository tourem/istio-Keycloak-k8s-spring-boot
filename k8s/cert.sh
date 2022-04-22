#export DOMAIN_NAME=larbo.com

export DOMAIN_NAME=localhost
# As a first step, you are going to create the root certificate ($DOMAIN_NAME.crt) and the private key used for signing the certificate ($DOMAIN_NAME.key):
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=localhost Inc./CN=localhost' -keyout root.private.$DOMAIN_NAME.key -out root.certificate.$DOMAIN_NAME.crt

# En cas d'erreur : name is expected to be in the format /type0=value0/type1=value1/type2=... where characters may be escaped by \. This name is not in that format: 'C:/Program Files/Git/O=localhost Inc./CN=localhost'
# problems making Certificate Request ===> export MSYS_NO_PATHCONV=1; puis relancer la commande 

# Next, you need to create the private key:
# create private key (employee.$DOMAIN_NAME.key) and certificate request or   certificate signing requests (CSR) (employee.$DOMAIN_NAME.csr ) use to create certificate
openssl req -out $DOMAIN_NAME.csr -newkey rsa:2048 -nodes -keyout $DOMAIN_NAME.key -subj "/CN=localhost/O=api employee management from localhost"

# And the certificate:
openssl x509 -req -days 365 -CA root.certificate.$DOMAIN_NAME.crt -CAkey root.private.$DOMAIN_NAME.key -set_serial 0 -in $DOMAIN_NAME.csr -out $DOMAIN_NAME.crt

kubectl create secret tls istio-ingressgateway-certs -n istio-system --key $DOMAIN_NAME.key --cert $DOMAIN_NAME.crt

curl -v --cacert root.certificate.$DOMAIN_NAME.crt https://localhost:/app/employees


######################################
#Getting Chrome to accept self-signed localhost certificate

#For localhost only
#Simply paste this in your chrome:
#
#chrome://flags/#allow-insecure-localhost
#You should see highlighted text saying: Allow invalid certificates for resources loaded from localhost
#
#Click Enable.

openssl x509 -in $DOMAIN_NAME.crt -out $DOMAIN_NAME.crt.pem
openssl x509 -in root.certificate.$DOMAIN_NAME.crt -out root.$DOMAIN_NAME.crt.pem
