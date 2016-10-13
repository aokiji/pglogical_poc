# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.define "db_master" do |master|
      master.vm.box = "bento/centos-7.1"
      master.vm.network "private_network", ip: "192.168.33.10"
      master.vm.synced_folder "provision/salt/", "/srv/salt/"
      master.vm.synced_folder "provision/pillar/", "/srv/pillar"

      master.vm.provision "shell", inline: <<-SHELL
        sudo yum install -y python2
      SHELL
      
      master.vm.provision :salt do |salt|
          salt.masterless = true
          salt.minion_config = "provision/postgres_master"
          salt.run_highstate = true
          salt.verbose = true
      end
  end

  config.vm.define "db_slave" do |slave|
      slave.vm.box = "bento/centos-7.1"
      slave.vm.network "private_network", ip: "192.168.34.10"
      slave.vm.synced_folder "provision/salt/", "/srv/salt/"
      slave.vm.synced_folder "provision/pillar/", "/srv/pillar"

      slave.vm.provision "shell", inline: <<-SHELL
        sudo yum install -y python2
      SHELL

      slave.vm.provision :salt do |salt|
          salt.masterless = true
          salt.minion_config = "provision/postgres_slave"
          salt.run_highstate = true
          salt.verbose = true
      end
  end
end
