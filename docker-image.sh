#Password generator
#docker run --rm httpd:2.4-alpine htpasswd -nbB admin "password123" | cut -d ":" -f 2 

echo "....Cleaning old builds............."
make clean
echo

echo "....Setting up build structure............."
make all
echo

echo "....Building Backend............."
echo 
make build-server 

echo "....Building frontend............."
echo 
make build-client 

echo "...Building docker images............."
echo 
make build-image

echo "...Done............."