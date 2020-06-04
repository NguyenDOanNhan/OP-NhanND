echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
# fix internet centos8
PublicKeyAuthentication yes
AuthorizedkeysFile .ssh/authorized_keys

https://gocit.vn/bai-viet/cau-hinh-xac-thuc-remote-ssh-khong-can-mat-khau/

Việc cấu hình thực hiện trên hai phần client và phần chính trên server.
1.Cấu hình trên Client
– Đầu tiên tạo key pair để khởi tạo các key public lẫn private:
	ssh-keygen -t rsa -b 4096
– Chấp nhận tất cả các mặc định, chỉ cần nhấn Enter khi được hỏi một passphrase:
	Generating public/private rsa key pair.
	Enter file in which to save the key (/root/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase):
	Enter same passphrase again:
	Your identification has been saved in /root/.ssh/id_rsa.
	Your public key has been saved in /root/.ssh/id_rsa.pub.
– Bây giờ bạn sẽ có một tập hợp các key trong /root/.ssh/. 
	Copy chúng vào máy muốn đăng nhập từ xa, trong trường hợp này là máy 192.168.1.100  :
	*ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.1.100*
	ex:
		ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.137.200
		ssh-copy-id -i ~/.ssh/id_rsa.pub nhannd@192.168.137.100 (**lưu ý ubuntu thì chỉ vào bằng tài khoản thường và không nên truy cập theo tài khoản root"**)
– Bạn sẽ được nhắc nhở về mật khẩu cho tài khoản trên máy chủ từ xa, nhập vào và ssh-copy-id sẽ copy key này vào thư mục chính xác và sắp xếp quyền truy cập hệ thống tập tin.
Tiến hành một thử nghiệm để chắc chắn rằng nó hoạt động:
	ssh username@192.168.137.100
#Cấu hình file network cho centos8
	- Vào quyền root từ lúc đăng nhập vào máy
	- nano /etc/sysconfig/network-scripts/['Nhấn phím tab khi tới gạch này vì tùy váo máy mà cạc mạng sẽ hiện thị khác nhau']
		ex: nano /etc/sysconfig/network-scripts/ifcfg-eth0
	- Nhìn và tùy chỉnh cài đặt ( 
		ex: file cấu hình
			TYPE = Ethernet 
			PROXY_METHOD = none 
			BROWSER_ONLY = no 
			BOOTPROTO = static 
			DEFROUTE = yes 
			IPV4_FAILURE_FATAL = no 
			IPV6INIT = yes 
			IPV6_AUTOCONF = yes 
			IPV6_DEFROUTE = yes 
			IPV6_FAILURE_FATAL = no 
			IPV6_ADDR_GEN_MODE = stable - privacy 
			NAME = ens 33 
			UUID = 5240fb72-005b - 46c3 - af35-97fc2f703853 
			DEVICE = ens 33 
			ONBOOT = yes 
			IPV6_PRIVACY = no 
			IPADDR=192.168.1.254                    # IP Address
			NETMASK=255.255.255.0                   # Netmask
			GATEWAY=192.168.1.1                     # Default Gateway
			DNS1=8.8.8.8                            # DNS server
			DNS2=8.8.4.4
	- ifdown ens3
	- ifup ens3
	- Ubuntu, centos8 , cài static file Kết nối mạng nameserver
		1. Tạo một file cài đặt mới và liên kết tới file cấu hình mặc địnhif
			- Vào quyền root trước
			- *nano /etc/resolv.conf.manually-configured*
			- *rm /etc/resolv.conf *
			- Tạo liên kết với file cấu hình: 
				**ln -s /etc/resolv.conf.manually-configured  /etc/resolv.conf**
			- tiến hành khởi động lại may
				*reboot*
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
## Cấu hình tưởng lửa
ubuntu
ufw block specific IP address
sudo ufw deny from {ip-address-here} to any
ex: sudo ufw deny from 192.168.1.5 to any
nstead of deny rule we can reject connection from any IP as follows:
sudo ufw reject from 202.54.5.7 to any
centos8
firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='192.168.0.11' reject"
																						    Chặn tất cả			
firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='192.168.137.100' reject"
firewall-cmd --permanent --remote-rich-rule='rule family="ipv4" source address="192.168.56.1" reject' - remote rule
firewall-cmd --reload
xem thông tin chặn
sudo firewall-cmd --list-all
