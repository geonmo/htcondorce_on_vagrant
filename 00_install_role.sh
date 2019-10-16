#!/bin/bash
#sudo yum update -y
#sudo yum update -y ansible

ansible-galaxy -c install geerlingguy.repo-epel
ansible-galaxy -c install hephyvienna.htcondor_ce
ansible-galaxy -c install hephyvienna.grid
ansible-galaxy -c install hephyvienna.poolaccounts
ansible-galaxy -c install hephyvienna.workernode
ansible-galaxy -c install geonmo.ansible_htcondor


## Dueto KISTI security, 
#./remote_install_rootca.sh


./create-all.sh
