#/bin/bash

apt update
apt install -y haproxy

cat << EOF >> /etc/haproxy/haproxy.cfg

frontend kubernetes-frontend
    bind 172.16.16.100:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    server kmaster2 172.16.16.102:6443 check fall 3 rise 2

frontend http_front
  bind *:80
  stats uri /haproxy?stats
  default_backend http_back

backend http_back
  balance roundrobin
  server kube 172.16.16.201:80
  server kube 172.16.16.202:80
    
EOF

systemctl restart haproxy

