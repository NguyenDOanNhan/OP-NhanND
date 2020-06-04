*Cài đặt apache		yum -y install httpd
Khởi động apache:	systemctl start httpd
Kích hoạt apache:	systemctl enable httpd
Kiểm tra thông tin: 	systemctl status httpd
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
