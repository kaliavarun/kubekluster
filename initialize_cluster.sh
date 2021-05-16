#/bin/bash

sleep 10 # Sleep a few seconds to let background tasks finish from previous runs
echo "[initialize_cluster.sh] args: $0 $1 $2 $3 $4 "

TOKEN_CONTROL_PLANE="/vagrant/.tmp/.kubeadm-control-plane-token"
CMD_JOIN_MASTER="/vagrant/.tmp/.join-master"

# Initialize and joiin master nodes
if [[ $4 == "MASTER" ]]
then
  if [[ $3 -eq 1 ]]
  then
    CMD="kubeadm init --control-plane-endpoint="$1:6443" --upload-certs --apiserver-advertise-address=$2 --pod-network-cidr=192.168.0.0/16"
    echo $CMD
    eval $CMD

    su vagrant

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    su root
    
    mkdir -p /vagrant/.tmp

    echo "[MASTER NODE 1] identified. Generating token for other master nodes to join control plane.."
    kubeadm init phase upload-certs --upload-certs | sed -n 3p > $TOKEN_CONTROL_PLANE
    echo "token created at $(pwd $TOKEN_CONTROL_PLANE)"
    echo "token value $(cat $TOKEN_CONTROL_PLANE)"
    kubeadm token create --print-join-command > $CMD_JOIN_MASTER

    echo "Deploying a pod networking solution.."
    #kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/manifests/calico.yaml
  else
    echo "Joining secondary master node [$2] with control plane"
    JOIN_MASTER="$(cat $CMD_JOIN_MASTER) --apiserver-advertise-address=$2 --control-plane --certificate-key $(cat $TOKEN_CONTROL_PLANE)  --v=5"
    echo $JOIN_MASTER
    eval $JOIN_MASTER
  fi
fi
# Join worker nodes
if [[ $4 == "WORKER" ]]
then
  echo "Joining worker node [$2] with control plane"
  JOIN_WORKER="$(cat $CMD_JOIN_MASTER) --apiserver-advertise-address=$2 --v=5  "
  echo $JOIN_WORKER
  eval $JOIN_WORKER
fi
