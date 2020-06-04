#iptables -I INPUT -p tcp -s 192.168.56.200 -m tcp --dport 80 -j ACCEPT
# muốn xóa đi thì
#iptables -D INPUT -p tcp -s 192.168.56.125 -m tcp --dport 80 -j ACCEPT
# chặn tất cả không cho vào
#iptables -A INPUT -s 192.168.56.0/24 -j DROP
# xóa bỏ chặn
#iptables -D INPUT -s 192.168.56.0/24 -j DROP
