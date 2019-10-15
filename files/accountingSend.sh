#!/bin/bash
# accountingRun.sh
# sjones@hep.ph.liv.ac.uk, 2019
# Run the processes of a HTCondor accounting run

/usr/bin/apelclient                # Join blah and batch records to make job records
/usr/bin/ssmsend                   # Send job records into APEL system
