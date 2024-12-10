docker pull nginx:1.21.1


docker build -t hachubra/custom_nginx:1.0.0 .

docker run -p 81:80 hachubra/custom_nginx:1.0.0

docker login
docker push hachubra/custom_nginx:1.0.0

