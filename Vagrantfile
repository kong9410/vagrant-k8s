Vagrant.configure("2") do |config|
  Nodes = 3
  KubeVer = "1.23.5"

  config.vm.define "m-k8s" do |cfg|
    cfg.vm.hostname="m-k8s"
    cfg.vm.box = "centos/7"
    cfg.vm.network "forwarded_port", guest: 22, host: 60010, id:"ssh"
    cfg.vm.network "private_network", ip: "192.168.1.10"
    cfg.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
      vb.customize ["modifyvm", :id, "--groups", "/k8s"]
    end
    cfg.vm.provision "shell", path: "config.sh", args: Nodes
    cfg.vm.provision "shell", path: "install_package.sh", args: KubeVer
    cfg.vm.provision "shell", path: "password_authentication.sh"
    cfg.vm.provision "shell", path: "master_node.sh"
  end

  (1..Nodes).each do |i|
    config.vm.define "w#{i}-k8s" do |cfg|
      cfg.vm.hostname="w#{i}-k8s"
      cfg.vm.box="centos/7"
      cfg.vm.network "forwarded_port", guest: 22, host: "6001#{i}", id:"ssh"
      cfg.vm.network "private_network", ip: "192.168.1.10#{i}"
      cfg.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = "1"
        vb.customize ["modifyvm", :id, "--groups", "/k8s"]
      end
      cfg.vm.provision "shell", path: "config.sh", args: Nodes
      cfg.vm.provision "shell", path: "install_package.sh", args: KubeVer
      cfg.vm.provision "shell", path: "password_authentication.sh"
      cfg.vm.provision "shell", path: "worker_node.sh"
    end
  end
end
