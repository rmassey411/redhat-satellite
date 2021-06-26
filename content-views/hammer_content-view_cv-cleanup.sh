#!/usr/bin/env bash

# Set global variables
ORG="ORG_NAME_HERE"
NUM_TO_RETAIN="5"

cvs=`hammer --no-headers content-view list --organization "$ORG" --composite false --fields Label`

for cv in $cvs:
do
  while [ $(hammer --no-headers content-view version list --organization "$ORG" --content-view "$cv" --order 'version asc' | wc -l) -gt "$NUM_TO_RETAIN" ]
  do
    num_of_ver=`hammer --no-headers content-view version list --organization "$ORG" --content-view "$cv" --order 'version asc' | wc -l`
    oldest_ver=`hammer --no-headers content-view version list --organization "$ORG" --content-view "$cv" --order 'version asc' | head -1 | awk '{print $6}'`
    echo "$cv has $num_of_ver versions"
    echo "Removing version $oldest_ver from $cv"
    hammer content-view version delete --organization "$ORG" --content-view "$cv" --version "$oldest_ver"
  done
done
