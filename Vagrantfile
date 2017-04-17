# -*- mode: ruby -*-
# vi: set ft=ruby :
#

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision :shell, path: "contrib/build-server.sh"
  config.vm.network :private_network, ip:"192.168.70.40"
  config.vm.box = "bento/ubuntu-14.04"
  
  # to enable symbolic links inside VM
  config.vm.provider "virtualbox" do |v|
	      v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
	      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

end
