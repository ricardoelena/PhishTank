#!/bin/bash

cd /data/PhishTank/

#Retreive raw html code fom phishtank
wget -U firefox  -t2  -T3  --no-check-certificate -S "https://www.phishtank.com/phish_search.php?valid=All&active=y&Search=Search"

#Extract details of each result
cat phish_search.php\?valid\=All\&active\=y\&Search\=Search | sed 's/td/\\\n/g' | grep phish_detail.php | cut -d ">" -f3 | cut -d "<" -f1 > olddata.list

#Validate if there are any new findings
comm -13 <(sort phishid.list) <(sort olddata.list) >aux

#Log
date >> phishid.list

#Initiate Variables for process
cat aux >> phishid.list
rm -f urls.list

#For each finding browser each phish_detail and extract full URL
while read ids
do

url=`wget -U firefox  -t2  -T3 -qO- --no-check-certificate -S https://www.phishtank.com/phish_detail.php?phish_id=$ids | grep word-wrap | cut -d ">" -f3 | cut -d "<" -f1`

echo $url >> urls.list

done < aux

#Delete results from initial wget
rm -f  phish_search.php*

#Delete any empty lines
sed -i '/^$/d' urls.list

#Manipulate each new URL
while read url
do

echo $url

done < urls.list


