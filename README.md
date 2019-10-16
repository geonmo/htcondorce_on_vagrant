# Install HTCondor-CE on vagrant system
These codes are written based on the code to explain how to install HTCondor-CE in UMD middleware environment.

You can run the code sequentially to see how HTCondor-CE is working and what packages you need.

## System environment
This lab requires at least 4 cores of CPU and 4 GB of RAM or higher. If you can test with equipment below this, but there is no guarantee that it will work properly.

At the time of development, the test equipment was:
   * CPU: Intel Core i7-7700 CPU @ 3.6 GHz
   * RAM: 64 GB
   * OS: Windows 10 Pro
   * VM: Oracle VM VirtualBox 6.0.12 r133076

The test environment must be an internet-enabled environment. However, it is recommended that the equipment be configured to be difficult to access from the outside.

The Vagrantfiles used are shown below. 
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

NODE_COUNT = 4
Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = false
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
     vb.linked_clone = true
   end

  NODE_COUNT.times do |i|
    node_id = "node#{i}"
    ip_address = "192.168.10.#{i+3}"
    config.vm.define node_id do |node|
      node.vm.box = "geerlingguy/centos7"
      node.vm.box_download_insecure=true
      node.vm.hostname = "#{node_id}.intranet.local"
      
      node.vm.network "private_network", ip: "#{ip_address}", 
        virtualbox__intnet: "condor_net"
      node.vm.network "forwarded_port", guest: 22, host: "#{i+2222}"
      node.vm.provision "shell", inline: <<-SHELL
        yum install -y git vim ansible
        rm -rf /tmp/ansible_provision
        git clone https://github.com/geonmo/desktop_vagrant.git /tmp/ansible_provision
        cd /tmp/ansible_provision
        ansible-playbook provision.yml
      SHELL
    end
  end  
end
```
The code is written to automatically recognize the test user's public key and to write node IP information to the /etc/hosts file. Therefore, it is safe to modify the code directly or do the installation part separately. Please, see the https://github.com/geonmo/desktop_vagrant.git for detail.

## Limitation
The provided scripts do not fit into the production environment in many ways. Completion of this part, please modify it for individual sites.

