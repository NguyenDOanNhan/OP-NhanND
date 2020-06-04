#!/bin/bash
hostnamectl set-hostname proxy-nginx-incoming.example.com
yum makecache
yum install -y nginx
systemctl enable nginx.service
systemctl start nginx.service
nano /etc/nginx/nginx.conf
nano /etc/selinux/config
semanage port -a -t http_port_t -p tcp 8888
systemctl restart nginx.service
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
setsebool -P httpd_can_network_connect 1

