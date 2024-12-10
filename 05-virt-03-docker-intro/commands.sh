#1
docker pull nginx:1.21.1
docker build -t hachubra/custom_nginx:1.0.0 .
docker run -p 81:80 hachubra/custom_nginx:1.0.0
docker login
docker push hachubra/custom_nginx:1.0.0


#2
docker run -d -p 127.0.0.1:8081:80 --name "solovev-alex-nginx-t2" hachubra/custom_nginx:1.0.0 
docker rename solovev-alex-nginx-t2 custom-nginx-t2
date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8081  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html

#3
docker logs -f custom-nginx-t2
docker ps -a
docker restart custom-nginx-t2
