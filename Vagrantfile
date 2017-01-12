# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  #Apache
  config.vm.network :forwarded_port, guest: 80, host: 8888

  #Shared folders
  config.vm.synced_folder "working_dir/", "/var/www/html",
    owner: "ubuntu",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]

  config.vm.provision :shell, path: "vagrant_bootstrap/bootstrap.sh"
end
