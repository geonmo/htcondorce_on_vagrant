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
The provided scripts do not fit into the production environment in many ways. Completion of this part, please modify it for individual sites. Site administrators should consider the following settings.

1. We used a host certificate with a dummy Trust CA for testing. The administrator who wants to provide the service must actually build the system using the host certificate that is allowed. (CERN or local Trust CA)
1. This setting does not include the Security setting in the local HTCondor cluster managed by LRMS. The system administrator should refer to the HTCondor manual and change the settings to prevent security problems. To do this, you can test both the LRMS and HTCondor-CE services using the job submission specification file in the test directory.
1. HTCondor-CE is installed so that condor_mapfile can use ARGUS during installation. However, for testing purposes, the condor_mapfile has been modified so that any GSI certificate request is approved. Site administrators should either modify the condor_mapfile to meet their site's goals or build a separate Argus system to supplement this.
1. We modified the configuration of HTCondor due to network interface problem in Vagrant environment. The contents of the /etc/condor/conf.d/03-private.conf and /etc/condor-ce/conf.d/03-private.conf files to ensure that services work properly in HTCondor and HTCondor-CE in production. Please correct or delete it.

## Description of each step file
### 00_install_role.sh
You can install the ansible roles and create dummy Trust CA.

A total of 6 ansible roles are installed.

The first role, *geerlingguy.repo-epel*, is an epel repo installation ansible role created by **Jeff Geerling**, who created the centos7 OS image. Many thanks for his help. With Jeff Geerling's ansible code you can install an EPEL repo that works very well.

The second to fifth roles were developed by **the Institute of High Energy Physics, Austrian Academy of Sciences**. All Roles help build UMD middleware system and install HTCondor-CE. Since the existing YAIM setup program does not work well, the Ansible Role is very helpful in UMD middleware. Many thanks to IHEP and **Dietrich Liko** for developing the code.

The sixth is a role which moved HTCondor installation script used by **KISTI** to Ansible. The role is still missing a lot of features, but this HTCondor-CE demo is just fine.

*create-all.sh* is a dummy Trust CA creation script developed by Mark Kubacki. By modifying the script, we could create a virtual dummy Trust CA for the demo and copy it to the /etc/grid-security/certificates directory. Thanks to W. Mark Kubacki for developing the code.


### 01_hosts.yml
Plese, type "ansible-playbook 01_hosts.yml" to run it.

When you add a Private Network Interface in Vagrant, the content is added to the /etc/hosts file which is included as its hostname maps to 127.0.0.1. This causes problems with the operation of the HTCondor and HTCondor-CE services. Therefore, it must be remove from /etc/hosts. However, in most cases, this setting is not necessary. Because the first NIC takes over the public IP and communicates with the working nodes through the NIC. However, due to immature use of Vagrant, we need to add NIC as the second interface to fix IP addresses.


### 02_epel.yml
Plese, type "ansible-playbook 02_epel.yml" to run it.

On CentOS7, you can simply install epel-release via the yum command, but the _meta_ option doesn't work so often that you need to modify your repo file. **Jeff Geerling**'s epel repo ansible code solve the problem.

### 03_updateAnsible.sh
Plese, type "./03_updateAnsible.sh" to run it.

Below ansible codes require Ansible v2.8. So, we need to install latest ansible from EPEL repo.

### 04_middleware.yml
Plese, type "ansible-playbook 04_middleware.yml" to run it.

It performs the tasks to setup UMD middleware on all nodes, adding certificates, adding user accounts and creating home directories, and installing host certificates. Please refer to the roles(grid, poolaccount) developed by IHEP for more details.
In this example, the following settings are used.

```ruby
grid_vos:
   -cms
grid_dummy_host_certificate: true
grid_site_name: "KR-DUMMY-Tier3"
grid_dummy_ca:
   crt: dummy/CA.crt
   key: dummy/CA.key
   hash: 19d25ae9
   cn: /C=KR/O=KISTI/O=GSDC/O=Dummy CA/CN=
grid_host_certificate: {}
```
In this case, dummy host certificate is configured to be used, but in practice, **vars** should be changed to install a public certificate. For example, you need to change grid_dummy_host_certificate to false if you want to use host certs which is acquired by GRID CA. If you want to test by changing the certificate information of the dummy host certificate, you must also change the hash value. I didn't know how to calculate the hash value, so I got the hash value from htcondor-ce's MasterLog message and use it.


### 05_
