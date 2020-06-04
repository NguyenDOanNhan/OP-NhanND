#!/bin/bash
yum install update
yum -y install httpd
systemctl start httpd
systemctl enable httpd
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
# chú ý tên web nhé!
echo "<p> Hello world </p><h1> web-01 </h1>" > /var/www/html/index.html
systemctl restart httpd
reboot