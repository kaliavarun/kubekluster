# kubekluster

<img src="https://github.com/kaliavarun/kubekluster/blob/main/icons/kubekluster.jpg" width="100">

----

kubecluster provides a way to create a HA kubernetes cluster using virtual machines
without any manual configurations !!. Just configure number of master and worker nodes 
and you are done!!

----
## Usage
# Set up a Highly Available Kubernetes Cluster using kubekluster

> * Password for the **root** account on all these virtual machines is **kubeadmin**
> * Perform all the commands as root user unless otherwise specified

## Pre-requisites
If you want to try this in a virtualized environment on your workstation
* Virtualbox installed
* Vagrant installed
* Host machine has atleast 8 cores
* Host machine has atleast 8G memory
* Install yq
```
	VERSION=v4.2.0
	BINARY=yq_linux_amd64
	sudo add-apt-repository ppa:rmescandon/yq
	sudo apt update
	sudo apt install yq -y
```
* Install sshpass
```	
	sudo apt-get install sshpass
```

## Configure nodes
Edit the following configuration file for number of master and worker nodes.
```
vagrant up
```

## Launch kubekluster command and wait for cluster setup to complete
```
./kubekluster
```
## Verifying the cluster
```
kubectl cluster-info
kubectl get nodes
kubectl get cs
```

Have Fun!!
