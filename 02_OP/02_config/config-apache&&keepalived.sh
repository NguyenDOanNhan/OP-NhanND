#!/bin/bash
# Chúc ý lúc cấu hình dưới, tên mà vrrp_instance
hostnamectl set-hostname web2-g2.example.com
yum install update
yum -y install httpd
systemctl start httpd
systemctl enable httpd
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
echo "<p> Hello world </p><h1> web-04 </h1>" > /var/www/html/index.html
systemctl restart httpd
yum install -y keepalived
echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
sysctl -p
cd /etc/keepalived/
mv keepalived.conf keepalived.conf.org
echo "
! Configuration File for keepalived
#identify the global def configuration block
global_defs{
		#notification_email
		notification_email {
			# email web-01
			root@web2-g2.example.com
		}
		notification_email_from root@web2-g2.example.com
		smtp_server 127.0.0.1
		smtp_connect_timeout 30
		router_id LVS_DEVEL
}
# identify a VRRP instance definition block
vrrp_instance VI_1 {
        state MASTER
        interface enp0s8
        virtual_router_id 51
        priority 101 #used in election, 101 for master & 100 for backup
        advert_int 1
        authentication {
		# lưu ý nều là MASTER còn backup thì dùng pass
		auth_type AH
		auth_pass 1111
        }
        virtual_ipaddress {
                192.168.56.150/24
        }
 }" >keepalived.conf
 systemctl start keepalived ; systemctl enable keepalived
 systemctl restart httpd