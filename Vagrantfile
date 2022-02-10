# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
CLUST_CONF = YAML.load_file './config.yml'

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  # Load Balancer Node
  config.vm.define "loadbalancer" do |lb|
    lb.vm.box = "bento/ubuntu-20.04"
    lb.vm.hostname = "loadbalancer.example.com"
    lb.vm.network "private_network", ip: CLUST_CONF['LOAD_BALANCER_IP']
    lb.vm.provider "virtualbox" do |v|
      v.name = "loadbalancer"
      v.memory = 1024
      v.cpus = 1
    end
    lb.vm.provision "shell", path: "bootstrap.sh"
    lb.vm.provision "shell", path: "provision_loadbalancer.sh"    
  end

  MasterCount = CLUST_CONF['MASTER_NODE_COUNT']

  # Kubernetes Master Nodes
  (1..MasterCount).each do |i|
    config.vm.define "kmaster#{i}" do |masternode|
      masternode.vm.box = "bento/ubuntu-20.04"
      masternode.vm.hostname = "kmaster#{i}.example.com"
      masternode.vm.network "private_network", ip: "" +  CLUST_CONF['MASTER_IP_RANGE'] + "#{i}"
      masternode.vm.provider "virtualbox" do |v|
        v.name = "kmaster#{i}"
        v.memory = 2048
        v.cpus = 2
      end
      masternode.vm.provision "shell", path: "bootstrap.sh"
      masternode.vm.provision "shell", path: "provision_nodes.sh"
      masternode.vm.provision "shell", path: "initialize_cluster.sh", args: [CLUST_CONF['LOAD_BALANCER_IP'], "" +  CLUST_CONF['MASTER_IP_RANGE'] + "#{i}", "#{i}", "MASTER" ]
    end
  end

  NodeCount = CLUST_CONF['WORKER_NODE_COUNT']

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |workernode|
      workernode.vm.box = "bento/ubuntu-20.04"
      workernode.vm.hostname = "kworker#{i}.example.com"
      workernode.vm.network "private_network", ip: "" + CLUST_CONF['WORKER_IP_RANGE'] + "#{i}"
      #workernode.vm.network "public_network", ip: "192.168.2.#{i}", bridge: "wlp2s0"
      #workernode.vm.network "public_network", ip: "192.168.2.#{i}"
      workernode.vm.network "public_network", :bridge => "wlp2s0", :ip => "192.168.1.3#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 4096
        v.cpus = 1
      end
      workernode.vm.provision "shell", path: "bootstrap.sh"
      workernode.vm.provision "shell", path: "provision_nodes.sh"
      workernode.vm.provision "shell", path: "initialize_cluster.sh", args: [CLUST_CONF['LOAD_BALANCER_IP'], "" +  CLUST_CONF['WORKER_IP_RANGE'] + "#{i}", "#{i}", "WORKER" ]
    end
  end

end
