Vagrant.configure("2") do |config|
  config.vm.define "bvalab001", primary: true do |bvalab001|
    bvalab001.vm.box = "centos/7"
    bvalab001.vm.hostname = 'bvalab001'
    bvalab001.vm.network "private_network", ip: "192.168.210.11", name: "VirtualBox Host-Only Ethernet Adapter #2"
    bvalab001.vm.network :forwarded_port, guest: 8200, host: 8200, id: "vault" , auto_correct: true
    bvalab001.vm.network :forwarded_port, guest: 8500, host: 8500, id: "consul", auto_correct: true
    bvalab001.vm.network :forwarded_port, guest: 2049, host: 2049, id: "nfs", auto_correct: true
    bvalab001.vm.provision "ansible", ansible.playbook = "./Ansible/playbook.yml"
    bvalab001.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
      vb.name = "bvalab01"
    end
  end 

  config.vm.define "bvalab002" do |bvalab002|
    bvalab002.vm.box = "centos/7"
    bvalab002.vm.hostname = 'bvalab002'
    bvalab002.vm.network "private_network", ip: "192.168.210.12", name: "VirtualBox Host-Only Ethernet Adapter #2"
    bvalab002.vm.network :forwarded_port, guest: 8200, host: 8200, id: "vault", auto_correct: true
    bvalab002.vm.network :forwarded_port, guest: 8500, host: 8500, id: "consul", auto_correct: true
    bvalab002.vm.network :forwarded_port, guest: 2049, host: 2049, id: "nfs", auto_correct: true
    bvalab002.vm.provision "shell", path: "bva-script/bva-init.sh"
    bvalab002.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
      vb.name = "bvalab02"  
    end
  end

  config.vm.define "bvalab003" do |bvalab003|
    bvalab003.vm.box = "centos/7"
    bvalab003.vm.hostname = 'bvalab003'
    bvalab003.vm.network "private_network", ip: "192.168.210.10", name: "VirtualBox Host-Only Ethernet Adapter #2"
    bvalab003.vm.network "public_network", ip: "192.168.1.200"
    bvalab003.vm.network :forwarded_port, guest: 2049, host: 2049, id: "nfs", auto_correct: true
    bvalab003.vm.provision "shell", path: "bva-script/nfs-init.sh"
    bvalab003.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
      vb.name = "bvalab03"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end
end