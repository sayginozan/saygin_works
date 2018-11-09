#! /bin/bash

# Get Add Apache Client Servers IP Addresses and Add into /etc/host

for i in server1 server2; do for j in `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $i`; do docker exec -it apache1 sh -c "echo "$j" "$i" >> /etc/hosts"; done; done 

# Adding Forwarded Ports into /etc/apache2/ports.conf 
docker exec -it apache1 sh -c "echo Listen 8081 >> /etc/apache2/ports.conf"
docker exec -it apache1 sh -c "echo Listen 8082 >> /etc/apache2/ports.conf"

# Copy VirtualHost files
docker cp /opt/dockersaygin/context/server1.conf apache1:/etc/apache2/sites-available/server1.conf
docker cp /opt/dockersaygin/context/server2.conf apache1:/etc/apache2/sites-available/server2.conf

# Enable the VirtualHosts
docker exec -it apache1 a2ensite server1.conf
docker exec -it apache1 a2ensite server2.conf

# Reload Apache Service
docker exec -it apache1 service apache2 reload
