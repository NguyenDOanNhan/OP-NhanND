# Dịch vụ SSH còn có tên gọi là OpenSSH trên Linux
	Cổng dịch vụ mặc định SSH : TCP – 22
		/etc/ssh/sshd_config : file cấu hình dịch vụ OpenSSH Server.
		/etc/ssh/ssh_config : file cấu hình OpenSSH client.
		~/.ssh/ : thư mục chứa nội dung cấu hình ssh của user client trên Linux.
		~/.ssh/authorized_keys : thư mục chứa thông tin các public key (RSA hoặc DSA) được user sử dụng để đăng nhập vào hệ thống Linux.
		/etc/nologin : nếu file này tồn tại, thì dịch vụ SSH Server trên Linux sẽ từ chối kết nối đăng nhập từ các user khác trên hệ thống 
		ngoại trừ user root. File này thường dùng trong trường hợp khẩn cấp cần cách ly sớm hệ thống.