#!/bin/bash
for x in {1..3}
do
scp setup_rootca.sh node$x:~
ssh node$x ~/setup_rootca.sh
done
