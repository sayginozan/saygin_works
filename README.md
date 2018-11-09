# saygin_works


### 1- Vagrant and VirtualBOX installation on Ubuntu ###

	root@saygin:~# apt -y update && apt install vagrant virtualbox


### 2- Download and Place vagrant_saygin under / Directory for Vagrant ###

	root@saygin:/vagrant# pwd
	/vagrant


### 3- File Tree ###

	root@saygin:/vagrant# tree

	vagrant
	├── provision
	│   ├── playbook.yml
	│   └── roles
	│       └── saygin_docker
	│           ├── files
	│           │   ├── monitor.sh
	│           │   ├── server1.conf
	│           │   ├── server2.conf
	│           │   └── server_settings.sh
	│           └── tasks
	│               ├── create_dockerfiles.yml
	│               ├── install_docker.yml
	│               ├── install_packages.yml
	│               └── main.yml
	└── Vagrantfile



### 4- Activate Ubuntu ###

	root@saygin:/vagrant# vagrant up


	PS: playbook outputs:  

		- Creating OS (with VB Gui)
		- Installing Packages in "install_packages.yml"
		- Installing Docker-CE
		- Creating and Building Hello World Container
		- Creating and Building HTOP Container
		- Copying Files


### 5- Docker Host ###

### 5.1- Connection Docker Host ###
		
	# vagrant ssh

		vagrant@saygin:~$ sudo su
		root@saygin:/home/vagrant# cd /opt/dockersaygin/
		root@saygin:/opt/dockersaygin# pwd
		/opt/dockersaygin

		root@saygin:/opt/dockersaygin# tree

	dockersaygin/
	├── context
	│   ├── hello
	│   ├── monitor.sh
	│   ├── server1.conf
	│   ├── server2.conf
	│   └── server_settings.sh
	└── dockerfiles
	    └── Dockerfile_Hello
	    └── Dockerfile_HTOP


### 5.2- Check Docker Host Web Service ###
	
	root@saygin:/home/vagrant# echo DOCKER HOST > /var/www/html/index.html
	root@saygin:/home/vagrant# service apache2 restart
	
	root@saygin:/home/vagrant# ifconfig -a

	http://public_network_IP

	PS: Guest Network Definition is set as Public in Vagrantfile

    		"saygin.vm.network "public_network"

### 5.3- Check Containers ###

	# List All Containers

		root@saygin:/opt/dockersaygin# docker container ps -a

		CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                         PORTS                                                                  NAMES
		e08593618982        hello-world         "/hello"                 19 hours ago        Exited (0) 19 hours ago                                                                          
		ef8009a5f437        htop:v1             "htop"                   19 hours ago        Exited (0) 19 hours ago




	# Hello-World 

		root@saygin:/opt/dockersaygin# docker run hello-world

		Hello from Docker!
		This message shows that your installation appears to be working correctly.
		...


	# HTOP 

		root@saygin:/opt/dockersaygin# docker run -it --pid host htop:v1

                                                                                
		  1  [                                                                        0.0%]   Tasks: 79, 317 thr; 1 running
		  2  [                                                                        0.0%]   Load average: 0.00 0.00 0.00 
		  Mem[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||198M/1.95G]   Uptime: 12:01:18
		  Swp[                                                                       0K/0K]
		  PID USER      PRI  NI  VIRT   RES   SHR S CPU% MEM%   TIME+  Command          
		    1 root       20   0  116M  5716  3920 S  0.0  0.3  0:05.28 /sbin/init       
		  398 root20   0 29644  3228  2900 S  0.0  0.2  0:00.46 /lib/systemd/systemd-journald
		  433 root20   0  100M  1564  1380 S  0.0  0.1  0:00.00 /sbin/lvmetad -f         
		  456 root20   0 42480  3304  2504 S  0.0  0.2  0:00.28 /lib/systemd/systemd-udevd
		  868 root20   0 16120  2680  1816 S  0.0  0.1  0:00.00 /sbin/dhclient -1 -v -pf /run/dhclient.enp0s3.pid -lf /var/lib/dhcp/dhclient.enp0s3.leases -I -df /var/lib/dhc
		 1040 root20   0  5220   152    36 S  0.0  0.0  0:02.04 /sbin/iscsid             
		 1041 root10 -10  5720  3508  2424 S  0.0  0.2  0:10.13 /sbin/iscsid            
		 1045 root20   0  4396  1256  1168 S  0.0  0.1  0:00.00 /usr/sbin/acpid         
		 1047 root20   0 26068  2356  2092 S  0.0  0.1  0:00.12 /usr/sbin/cron -f       



### 6- Create Apache Containers on Docker Host ###

### 6.1- Apache Server Container ###

	# Create server1 Container

		root@saygin:/opt/dockersaygin# docker run -it -p 8080:80 -p 9081:8081 -p 9082:8082 --name apache1 ubuntu:latest /bin/bash
	
		# Execute Commands on apache1

			# apt -y update && apt install -y apache2 nano tcpdump && a2enmod proxy && a2enmod proxy_http
			# echo APACHE 1 > /var/www/html/index.html 
			# service apache2 restart

	# To Exit CTRL-P + CTRL-Q (leaving container running in the background)


	PS: Forwarded ports 80,8081,8082 on Apache Server Container are mapped ports 8080,9081,9082 on Docker Host


### 6.2- Create Apache Client Server Tepmlate and Containers  ###

	# Create server1 Container

		root@saygin:/opt/dockersaygin# docker run -it -p 8081:80 --name server1 ubuntu:latest /bin/bash

		# Execute Commands on server1

			# apt -y update && apt install -y apache2 nano tcpdump
        	        # echo SERVER 1 > /var/www/html/index.html 
			# service apache2 restart
		
	# To Exit CTRL-P + CTRL-Q (leaving container running in the background)


	# Create an image of server1:

		root@saygin:/opt/dockersaygin# docker commit server1 server-template


	# Create server2 Container

		root@saygin:/opt/dockersaygin# docker run -it -p 8082:80 --name server2 server-template /bin/bash

		#Execute Commands on server2

	                # echo SERVER 2 > /var/www/html/index.html 
			# service apache2 restart

	# To Exit CTRL-P + CTRL-Q (leaving container running in the background)
		

	PS: Forwarded ports 8081,8082 on Apache Client Server Containers are mapped ports 8081,8082 on Docker Host


### 6.3- Check Running Containers ###

	root@saygin:/opt/dockersaygin# docker ps

	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                                                  NAMES

	5f1d37b4c4cb        ubuntu:latest       "/bin/bash"         19 hours ago         Up 19 hours          0.0.0.0:8080->80/tcp, 0.0.0.0:9081->8081/tcp, 0.0.0.0:9082->8082/tcp   apache1
	f2ff433157af        ubuntu:latest       "/bin/bash"         19 hours ago         Up 19 hours          0.0.0.0:8081->80/tcp                                                   server1
	ae0426aec7a2        ubuntu:latest       "/bin/bash"         19 hours ago         Up 19 hours          0.0.0.0:8082->80/tcp                                                   server2


### 6.4- Check ALL Servers ### 

	# Docker Host (saygin)

		http://public_network_IP

	# Apache Server (apache1)

		http://public_network_IP:8080

	# Apache Client Server (server1)

		http://public_network_IP:8081

	# Apache Client Server (server2)

		http://public_network_IP:8082


### 7- Apache Server Settings ###

### 7.1- Define VirtualHost on Apache Server ###

	# Execute server_settings.sh with trace option

		!!! root@saygin:/opt/dockersaygin# sh -x /opt/dockersaygin/files/server_settings.sh

	PS: To check server_settings.sh on apache1

		root@saygin:/opt/dockersaygin# docker exec -it apache1 bash

			Get Add Apache Client Servers IP Addresses and Add into /etc/host

				# for i in server1 server2; do for j in `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $i`; do docker exec -it apache1 sh -c "echo "$j" "$i" >> /etc/hosts"; done; done 
				

			Add Forwarded Ports into /etc/apache2/ports.conf 

				Listen 8081 # to server1 port 80
				Listen 8082 # to server2 port 80

			Create VirtualHost files

				# nano /etc/apache2/sites-available/server1.conf 

					<VirtualHost *:8081>
					ServerName localhost
					<Proxy *>
					Order deny,allow
					Allow from all
					</Proxy>
					ProxyPass / http://server1/
					</VirtualHost>


				# nano /etc/apache2/sites-available/server2.conf 

					<VirtualHost *:8082>
					ServerName localhost
					<Proxy *>
					Order deny,allow
					Allow from all
					</Proxy>
					ProxyPass / http://server2/
					</VirtualHost>

			Enable the VirtualHosts and Reload Apache Service

				# a2ensite server1.conf		
				# a2ensite server2.conf		
				# service apache2 reload


### 7.2- Check VirtualHost ###


	#Apache Client Server (server1) 
	
		http://public_network_IP:9081

	-Port 9081, Docker Host <-> Port 8081, Apache Server <-> Port 80, Apache Client Server


	#Apache Client Server (server2)
 
		http://public_network_IP:9082

	-Port 9082, Docker Host <-> Port 8082, Apache Server <-> Port 80, Apache Client Server


### 8- Monitoring Traffic ###

	# Execute monitor.sh. For every 1 Second. That may take a time because of lack of logs.

		root@saygin:/opt/dockersaygin# sh /opt/dockersaygin/files/monitor.sh

		Active Internet connections (w/o servers)
		Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
		tcp6       0      0 192.168.178.24:80       192.168.178.11:59294    FIN_WAIT2   5578/apache2
		tcp6       0      0 192.168.178.24:80       192.168.178.11:59296    SYN_RECV    -

		  Count IP
		      2 192.168.178.11
		      1 10.0.2.2


	PS: To check monitor.sh on apache1

		watch -n 1 -c "netstat -ntupw | head -n 2 && netstat -ntupw | tail -n 10 | grep -v 'Active\|Proto' | grep '":80"\|":908"' && echo '\n \n' && echo '  'Count IP && netstat -ntu | awk '{print \$5}' | cut -d: -f1 | sort | uniq -c | sort -rn | tail -n 10"





