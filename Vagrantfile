ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "common.sh"

  # Load Balancer Nodes
  config.vm.define "loadbalancer" do |lb|
    lb.vm.box = "bento/ubuntu-20.04"
    lb.vm.hostname = "loadbalancer.example.com"
    lb.vm.network "private_network", ip: "172.16.16.100"
    lb.vm.provider "virtualbox" do |v|
      v.name = "loadbalancer"
      v.memory = 1024
      v.cpus = 1
    end
    
  end

  # Kubernetes Master Nodes
  MasterCount = 2

  (1..MasterCount).each do |i|

    config.vm.define "kmaster#{i}" do |masternode|

      masternode.vm.box               = "bento/ubuntu-20.04"
      masternode.vm.box_check_update  = false
      masternode.vm.hostname          = "kmaster#{i}.example.com"

      masternode.vm.network "private_network", ip: "172.16.16.10#{i}"

      masternode.vm.provider :virtualbox do |v|
        v.name   = "kmaster#{i}"
        v.memory  = 2048
        v.cpus    = 2
      end
    end
  end

  # Kubernetes Worker Nodes
  WorkerCount = 1

  (1..WorkerCount).each do |i|

    config.vm.define "kworker#{i}" do |workernode|

      workernode.vm.box               = "bento/ubuntu-20.04"
      workernode.vm.box_check_update  = false
      workernode.vm.hostname          = "kworker#{i}.example.com"

      workernode.vm.network "private_network", ip: "172.16.16.20#{i}"
      workernode.vm.provider :virtualbox do |v|
        v.name   = "kworker#{i}"
        v.memory  = 1024
        v.cpus    = 1
      end
    end

  end

end