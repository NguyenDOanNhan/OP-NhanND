#!/bin/bash
yum install -y keepalived
echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
sysctl -p
cd /etc/keepalived/
mv keepalived.conf keepalived.conf.org
nano keepalsived.conf
! Configuration File for keepalived
#identify the global def configuration block
global_defs{
		#notification_email
		notification_email {
			# email web-01
			root@web-01.example.com
		}
		notification_email_from root@web-01.example.com
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
		#
		auth_type AH
		auth_pass 1111
        }
        virtual_ipaddress {
                192.168.56.200/24
        }
 }