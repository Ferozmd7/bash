pass=root12
echo "#step:1"


openssl req -config details.conf -x509 -newkey rsa:2048 -passout pass:$pass  -keyout key.pem -out cert.pem -days 365
#####################################################################
echo "#step2"

VAR1=$(openssl x509 -noout -modulus -in cert.pem | openssl md5)
VAR2=$(openssl rsa -noout -modulus -passin pass:$pass -in key.pem | openssl md5 )  

if [ "$VAR1" = "$VAR2" ]; then
    echo "Strings are equal."
else
    echo "Strings are not equal."
    exit 0
fi
 
#######################################################################
echo "#step:3"

openssl pkcs12 -passout pass:$pass -passin pass:$pass -inkey key.pem -in cert.pem -export -out server.p12  

########################################################################
echo "#step:4"

keytool -list -v -storepass $pass -keystore server.p12 

##########################################################################

echo "#step:5"

keytool -importkeystore -deststorepass $pass -destkeypass $pass -destkeystore keystore.jks -srckeystore server.p12 -srcstoretype PKCS12 -srcstorepass $pass -alias 1

