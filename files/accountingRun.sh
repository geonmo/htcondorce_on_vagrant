#!/bin/bash
# accountingRun.sh
# sjones@hep.ph.liv.ac.uk, 2019
# Run the processes of a HTCondor accounting run

/usr/share/condor-ce/condor_blah.sh       # Make the blah file (CE/Security data)
/usr/share/condor-ce/condor_batch.sh      # Make the batch file (batch system job run times)
/usr/bin/apelparser                       # Read the blah and batch files in

