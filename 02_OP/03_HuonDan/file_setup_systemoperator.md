# Các bạn truy cập link sau : https://downloads.mariadb.org/mariadb/repositories/ , để MariaDB web tạo cho các bạn nội dung Repository tương ứng OS.
## link tham khảo: https://cuongquach.com/cai-dat-mariadb-10-2-tren-centos-7.html
	1. Tạo file
		curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
	2. Tiền hành cài đặt MariaDB
		yum update
		sudo dnf install MariaDB-server MariaDB-client MariaDB-devel -y
		**MariaDB khởi động khi Hệ Điều Hành Linux được khởi động.**
		systemctl enable mariadb.service
		systemctl start mariadb.service
	3. Test
		mysql_secure_installation
		sau nhấn enter tới lúc nhập mật khẩu cho root thi viết pass cho root
		- Tạo bảng:
			CREATE DATABASE IF NOT EXISTS new_database;
			CREATE DATABASE IF NOT EXISTS testMariaDB;
			SHOW DATABASES;
			USE new_database;
			USE testMariaDB;
			create database_name
			CREATE DATABASE `birthdays`;
			CREATE TABLE tourneys (name varchar(30), wins real, best real, size real );
			INSERT INTO tourneys (name, wins, best, size) 
			VALUES ('Dolly', '7', '245', '8.5'), 
			('Etta', '4', '283', '9'), 
			('Irma', '9', '266', '7'), 
			('Barbara', '2', '197', '7.5'), 
			('Gladys', '13', '273', '8');
			SELECT * FROM tourneys;
			(https://www.digitalocean.com/community/tutorials/introduction-to-queries-mysql)
## PostgreSQL
	https://www.centlinux.com/2019/07/install-postgresql-pgadmin-on-centos-7.html
	1. Cài đặt
		dnf install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y
		dnf -qy module disable postgresql
		dnf install postgresql11 postgresql11-server -y
		/usr/pgsql-11/bin/postgresql-11-setup initdb
		systemctl enable postgresql-11
		systemctl start postgresql-11
		nano /var/lib/pgsql/11/data/postgresql.conf
			Tìm và thay đổi thành:
			listen_addresses = '*'
		nano /var/lib/pgsql/11/data/pg_hba.conf
			# IPv6 local connections: Thêm vào host all dưới ident này
				host    all  all ::1/128 ident
				host all all 192.168.56.0/24 md5 ( đây là nới mà bạn câu hình ip của bạn)
		systemctl restart postgresql-11.service
		firewall-cmd --permanent --add-service=postgresql
		firewall-cmd --reload
		netstat -napl | grep post
	2. Cấu hình PostgreSQL liền kết pgadmin
		Đổi pass:
			su - postgres
			passwd postgres
			psql
			psql -d template -c "ALTER USER postgres WITH PASSWORD 'root';"
	3. Xem thông tin postgress ( kết nối với pgadmin)
			\c database_name
			\dt
			SELECT * FROM public."TestDB1";
			INSERT INTO public."TestDB1"(
			name, email)
			VALUES ('Dolly', '7'),
			('Etta', '4'),
			('Irma', '9'),
			('Barbara', '2');
## Suite
	(https://www.centlinux.com/2019/10/install-squid-proxy-server-on-centos-7.html)
	yum install -y squid
	systemctl enable --now squid.service
	firewall-cmd --permanent --add-service=squid
	firewall-cmd --reload
	nano /etc/squid/blacklist
		-and add following URLs therein.(Xem ví dụ dưới)
			.yahoo.com
			.facebook.com
	nano /etc/squid/squid.conf
		-add following directives after the ports’ ACLs.
			acl bad_urls dstdomain "/etc/squid/blacklist"
			http_access deny bad_urls
	systemctl restart squid
	-> Sau đó  chọn một trình duyệt và bật tĩnh năng proxy: chọn proxy server là cái mà mình vừa cài trên máy ảo
## HA: Keepalived (https://www.centlinux.com/2018/08/keepalived-configure-floating-ip-centos-7.html#point2)
	Hostname			webserver-01.example.com	webserver-02.example.com
	IP Address			192.168.56.125/24			192.168.56.150/24
	Operating System	CentOS 8					CentOS 8
	Web Server			Nginx						Nginx
	state 				Master						BACKUP
	keepalived : 192.168.56.200
	( cả webserver-01 và webserver-02 mặc định đã cài ngin x)
	*Configure KeepAlived on webserver-01:*
		yum install -y keepalived
	- Hỗ trợ Floating IP
		nano /etc/sysctl.conf
	- Thêm vào cuối file
		net.ipv4.ip_nonlocal_bind = 1
	- Khởi động lại dịch vụ: kiểm tra
		sysctl -p
		[ kết quả của lệnh này là: net.ipv4.ip_nonlocal_bind = 1]
	- configure keepalived settings:
		cd /etc/keepalived/
		mv keepalived.conf keepalived.conf.org
		nano keepalived.conf
		cấu hình theo mẫu sau:

			! Configuration File for keepalived
			
			global_defs {
			   notification_email {
			  root@webserver-01.example.com
			   }
			   notification_email_from root@webserver-01.example.com
			   smtp_server 127.0.0.1
			   smtp_connect_timeout 30
			   router_id LVS_DEVEL
			}

			vrrp_instance VI_1 {
				state MASTER
				interface [Tên cạc mạng]
				virtual_router_id 51
				priority 101 #used in election, 101 for master & 100 for backup
				advert_int 1
				authentication {
					auth_type PASS
					auth_pass 1111
				}
				virtual_ipaddress {
					[ip-chọn để cân bằng tải chung]/24
					ex: 
					192.168.56.200/24
				}
			}
	- Start and enable keepalived service.
		systemctl start keepalived ; systemctl enable keepalived
	- Check IP Address of the server
		ip addr | grep "inet" | grep "[gia trị cần muốn xem thông tin-ở đây là thông tin cạc mạng]"
	systemctl restart ngin.service
	*Configure KeepAlived on webserver-02*
		yum install -y keepalived
	- Hỗ trợ Floating IP
		nano /etc/sysctl.conf
	- Thêm vào cuối file
		net.ipv4.ip_nonlocal_bind = 1
	- Khởi động lại dịch vụ: kiểm tra
		sysctl -p
		[ kết quả của lệnh này là: net.ipv4.ip_nonlocal_bind = 1]
	- configure keepalived settings:
		cd /etc/keepalived/
		mv keepalived.conf keepalived.conf.org
		nano keepalived.conf
		cấu hình theo mẫu sau:

			! Configuration File for keepalived
			
			global_defs {
			   notification_email {
				root@webserver-02.example.com
			   }
			   notification_email_from root@webserver-01.example.com
			   smtp_server 127.0.0.1
			   smtp_connect_timeout 30
			   router_id LVS_DEVEL
			}

			vrrp_instance VI_1 {
				state BACKUP
				interface [Tên cạc mạng]
				virtual_router_id 51
				priority 101 #used in election, 101 for master & 100 for backup
				advert_int 1
				authentication {
					auth_type PASS
					auth_pass 1111
				}
				virtual_ipaddress {
					(ip này phải trùng với cấu hình ở mục tương ứng của webserver-01
					[ip-chọn để cân bằng tải chung]/24
					ex: 
					192.168.56.200/24
				}
			}
	- Start and enable keepalived service.
		systemctl start keepalived ; systemctl enable keepalived
	- Check IP Address of the server
		ip addr | grep "inet" | grep "[gia trị cần muốn xem thông tin-ở đây là thông tin cạc mạng]"
	systemctl restart ngin.service
**Sau khi cài xong để dịch vụ nhận thì khởi động lại nginx, và reboot lại cả hai máy, Muốn test thì gõ ip chung của hai máy đặt, ở đây là 192.168.56.200, sau đó tắt mạng của máy master rồi load lại thì sẽ nhận kết quả"