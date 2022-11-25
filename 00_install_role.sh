#!/bin/bash
#sudo yum update -y
#sudo yum update -y ansible


ansible-galaxy role install geerlingguy.repo-epel
ansible-galaxy role install geonmo.ansible_htcondor
ansible-galaxy role install geonmo.grid
ansible-galaxy role install geonmo.htcondor_ce


## Dueto KISTI security, 
#./remote_install_rootca.sh


./create-all.sh
