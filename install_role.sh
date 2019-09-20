#!/bin/bash
sudo yum update
sudo yum update ansible

ansible-galaxy -c install geerlingguy.repo-epel
ansible-galaxy -c install egi-foundation.umd
ansible-galaxy -c install hephyvienna.htcondor_ce



wget --no-check-certificate http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
sudo rpm --import RPM-GPG-KEY-HTCondor

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365

sudo cp cert.pem /etc/grid-security/hostcert.pem
sudo cp key.pem /etc/grid-security/hostkey.pem
sudo chmod 400 /etc/grid-security/hostkey.pem 


