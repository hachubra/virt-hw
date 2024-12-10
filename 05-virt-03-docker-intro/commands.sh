#1
docker pull nginx:1.21.1
docker build -t hachubra/custom_nginx:1.0.0 .
docker run -p 81:80 hachubra/custom_nginx:1.0.0
docker login
docker push hachubra/custom_nginx:1.0.0


#2
docker run -d -p 127.0.0.1:8081:80 --name "solovev-alex-nginx-t2" hachubra/custom_nginx:1.0.0 
