Apache1
E:\AWS\Hyper-V\Apache01
.100
Apache2
E:\AWS\Hyper-V\Apache02
.50:x
Web-Proxy
E:\AWS\Hyper-V\Web-Proxy
.200
Hostname apache:	web-01.example.com
hostnamectl set-hostname web-01.example.com                                                                            
Hostname apache:	web-02.example.com
hostnamectl set-hostname web-01.example.com                                                                        
Hostname nginx:		proxy-02.example.com
hostnamectl set-hostname proxy-02.example.com
Cài cache:		yum makecache
Cài nginx:		yum install -y nginx
Kích hoạt nginx:	systemctl enable nginx.service
Bật nginx:		systemctl start nginx.service
Thông tin nginx:	systemctl status nginx.service

Configure Nginx as HTTP Load Balancer:
			nano /etc/nginx/conf.d/app.conf
upstream appset {
 server 192.168.56.125;
 server 192.168.56.150;
}


server {
 listen 8888;
 location / {
  proxy_pass http://appset;
 }
}

Cấu hình vào host của proxy: nano /etc/hosts
192.168.56.125
192.168.56.150

Cấu hình file selinux để disable
			nano /etc/selinux/config
			SELINUX=disabled
Cài lệnh semanage: 	yum install policycoreutils-python
Điều chỉnh chính sách selinux để cho phép nginx chạy http trên cổng 8888:
			semanage port -a -t http_port_t -p tcp 8888
Restart nginx:		systemctl restart nginx.service