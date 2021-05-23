#/bin/sh
echo "Initilaizing a highly available Kubernetes cluster..."

#Creating virtual machines to act as cluster nodes


NODE_PASSWORD=$(yq e '.NODE_PASSWORD' config.yml)

#vagrant up &> vagrant.log

MASTER_IP_RANGE=$(yq e '.MASTER_IP_RANGE' config.yml)


# Cleanup
rm -R -f .tmp/


rm -R -f ~/.kube
mkdir ~/.kube
CMD="sshpass -p $NODE_PASSWORD scp  root@${MASTER_IP_RANGE}1:/etc/kubernetes/admin.conf ~/.kube/config"
eval $CMD


echo "Kubernetes cluster has been setup successfully!!"
