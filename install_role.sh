#!/bin/bash
sudo yum update -y
sudo yum update -y ansible

ansible-galaxy -c install geerlingguy.repo-epel
ansible-galaxy -c install hephyvienna.htcondor_ce
ansible-galaxy -c install hephyvienna.htcondor_grid
ansible-galaxy -c install hephyvienna.htcondor_poolaccounts
ansible-galaxy -c install hephyvienna.workernode
ansible-galaxy -c install geonmo.ansible_htcondor


wget --no-check-certificate http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
sudo rpm --import RPM-GPG-KEY-HTCondor

openssl req -x509 -newkey rsa:4096 -keyout key_encrypt.pem -out cert.pem -days 365
openssl rsa -in key_encrypt.pem -out key.pem

sudo cp cert.pem /etc/grid-security/hostcert.pem
sudo cp key.pem /etc/grid-security/hostkey.pem
sudo chmod 400 /etc/grid-security/hostkey.pem 
sudo chmod 644 /etc/grid-security/hostcert.pem 
sudo chown root.root /etc/grid-security/host*.pem


