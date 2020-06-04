#Cấu hình mạng sự dụng với máy ảo Virtual Box
** cấu hình này áp dụng với centos, còn linux thì cùng theo cách thức tương tự**
1. Cấu hình mạng NAT
	- cấu hình dynamic
	- Chỉ cấu hình thêm : ( nano /etc/systemconfig/network-scripts/ifcfg [Nhấn tab để hiện thị cạc mạng])
		- DNS1="8.8.8.8"
		- DNS2="8.8.4.4"
2. Cấu hình mạng host_only
	-Lưu lý cấu hình thêm và chú ý các trường theo mẫu(chỉ là vd, nên linh động xử lý)
		( nano /etc/systemconfig/network-scripts/ifcfg [Nhấn tab để hiện thị cạc mạng])
		BOOTPROTO = static 
		ONBOOT = yes 
		IPADDR=192.168.56.100                    # IP Address
		NETMASK=255.255.255.0                   # Netmask
		GATEWAY=192.168.56.2                    # Default Gateway
** cấu hình mạng của ubuntu
- Ubuntu, centos8 , cài static file Kết nối mạng nameserver
		1. Tạo một file cài đặt mới và liên kết tới file cấu hình mặc địnhif
			- Vào quyền root trước
			- *nano /etc/resolv.conf.manually-configured*
			- *rm /etc/resolv.conf *
			- Tạo liên kết với file cấu hình: 
				**ln -s /etc/resolv.conf.manually-configured  /etc/resolv.conf**
			- tiến hành khởi động lại may
				*reboot*/etc/netplan/
	- Tạo mạng static in ubuntu
		-nano /etc/netplan/["Nhấn tab"] tùy máy se có file cấu hình khác nhau
		- cấu hình file, tham khảo dưỡi mẫu sau:
			network:
				  version: 2
				  ethernets:
					ens3:
					  dhcp4: no
					  dhcp6: no
					  addresses: [192.168.137.100/24] * cái này là địa chỉ ip 192.168.137.100 cần chia, và 24 subnet mạng con*
					  gateway4: 192.168.121.1
					  nameservers:
						  addresses: [8.8.8.8, 1.1.1.1]
							
		- netplan apply