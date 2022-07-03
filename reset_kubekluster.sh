#!/bin/bash

if [ `id -u` -ne 0 ]
 then echo "This script can only be run as a root user"
 exit 1
fi


read -p "Are you sure you want to reset Kubekluster? Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
echo "Resetting kubernetes cluster..."
kubeadm reset -f
rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube* -y
sudo apt-get autoremove -y
sudo rm -rf ~/.kube

# Remove IP tables since they are not reset during kubeadm reset
/sbin/iptables -t nat -F && /sbin/iptables -t nat -X
/sbin/iptables -t raw -F && /sbin/iptables -t raw -X
/sbin/iptables -t mangle -F && /sbin/iptables -t mangle -X
systemctl restart docker
echo "Kubernetes cluster has been reset."
