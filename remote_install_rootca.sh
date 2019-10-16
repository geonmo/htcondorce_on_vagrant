#!/bin/bash
for x in {0..3}
do
scp -oStrictHostKeyChecking=no setup_rootca.sh node$x:~
ssh node$x ~/setup_rootca.sh
done
