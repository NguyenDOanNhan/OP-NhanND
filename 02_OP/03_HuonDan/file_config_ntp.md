#Đồng bộ thời gian: Ntp - Đã tích hợp sẵn tron centos8
- xem lệnh date : date '+%D %T'
	centos8
		1. install package Chrony NTP:
			dnf install chrony
		2. Enable chrony to start after boot:
			systemctl enable chronyd
		3. Set Chrony to act as an NTP server for a local network.
			nano /etc/chrony.conf
				add endline file
					allow 192.168.137.0/24
				Set Chrony to act as an NTP client
					Server 192.168.137.100
					Server 192.168.137.200
		4. Restart Chrony NTP daemon to apply the changes:
			systemctl restart chronyd
		5. Open firewall port to allow for incoming NTP requests:
			firewall-cmd --permanent --add-service=ntp
			firewall-cmd --reload
		-set time:
		timedatectl  status
		timedatectl set-timezone “Asia/Kolkata”
		timedatectl set-timezone UTC
		timedatectl set-time 15:58:30
		timedatectl set-time 20151120
		timedatectl set-time '2020-11-20 16:14:50'
	ubuntu20
		- cai chrony:
				apt install chrony
		- Cấu hình timezone.
			timedatectl set-timezone Asia/Ho_Chi_Minh
		- Kiểm tra timezone sau khi cài đặt.
			timedatectl
		- Tiến hành stop dịch vụ timesync
			timedatectl set-ntp no
		- Cấu hình firewall ufw
			sudo ufw allow ntp
		- Sau khi cài đặt chúng ta tiến hành start Chrony và cho phép khởi động cùng hệ thống.
			systemctl enable --now chrony
		- Kiểm tra  dịch vụ đang hoạt động.
			systemctl status chrony
