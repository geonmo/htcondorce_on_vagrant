#!/bin/bash
sudo yum update -y
sudo yum update -y ansible

ansible-galaxy -c install geerlingguy.repo-epel
ansible-galaxy -c install hephyvienna.htcondor_ce
ansible-galaxy -c install hephyvienna.grid
ansible-galaxy -c install hephyvienna.poolaccounts
ansible-galaxy -c install hephyvienna.workernode
ansible-galaxy -c install geonmo.ansible_htcondor


wget --no-check-certificate http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
sudo rpm --import RPM-GPG-KEY-HTCondor

./create-all.sh
