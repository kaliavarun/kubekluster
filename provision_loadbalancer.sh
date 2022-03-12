#/bin/bash

apt update
apt install -y haproxy

cat << EOF >> /etc/haproxy/haproxy.cfg

frontend kubernetes-frontend
    bind 192.168.1.23:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    #server kmaster2 172.16.16.102:6443 check fall 3 rise 2

frontend http_front
  bind *:80
  stats uri /haproxy?stats
  default_backend http_back

frontend https_front
  mode tcp
  bind *:443
  #ssl crt /etc/ssl/private/mydomain.pem
  stats uri /haproxy?stats
  default_backend https_back


backend http_back
  balance roundrobin
  server kworker1 172.16.16.201:32502
  server kworker2 172.16.16.202:32502


backend https_back
  mode tcp
  balance roundrobin
  server kworker1 172.16.16.201:31012
  server kworker2 172.16.16.202:31012
  #server kworker2 172.16.16.202:31012 check-ssl verify none send-proxy-v2

EOF

systemctl restart haproxy


