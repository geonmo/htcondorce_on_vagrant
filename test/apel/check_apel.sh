#!/bin/bash
echo "EventRecords"
mysql -u apel -pSomeSecretPasswordNooneCanGuess -h node3.intranet.local -e 'use apelclient; select JobName,StartTime,EndTime from EventRecords order by EndTime desc LIMIT 10;'
echo "BlahdRecords"
mysql -u apel -pSomeSecretPasswordNooneCanGuess -h node3.intranet.local -e 'use apelclient; select TimeStamp,GlobalJobId,LrmsId from BlahdRecords order by TimeStamp desc LIMIT 10;'
echo "SpecRecords"
mysql -u apel -pSomeSecretPasswordNooneCanGuess -h node3.intranet.local -e 'use apelclient; select * from SpecRecords;'
echo "JobRecords"
mysql -u apel -pSomeSecretPasswordNooneCanGuess -h node3.intranet.local -e 'use apelclient; select UpdateTime,LocalJobId,StartTime,EndTime from JobRecords order by UpdateTime desc LIMIT 10;'
