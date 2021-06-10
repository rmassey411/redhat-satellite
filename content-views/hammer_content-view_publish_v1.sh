#!/bin/sh

# Advise user of required params
echo -e "\e[5mTo provide organization name, pass -o with organizationname \e[0m"

# Set cli args as variables
while getopts ":o:" arg; do
  case $arg in
    o) ORG=$OPTARG;;
  esac
done

# Publish content-views
echo 'Publishing content views...'
CVS=`hammer --no-headers content-view list --organization "CS" --composite false --search "name ~ "cv-%"" --fields "Content View ID"`
for CV in $CVS
    do
        echo -e "$CV"
        #hammer content-view publish --async --id "$CV" --organization "$ORG"
        hammer content-view publish --id "$CV" --organization "$ORG"
    done

# Publish composite content-views
echo 'Publishing composite content views...'
CCVS=`hammer --no-headers content-view list --organization "CS" --composite true --search "name ~ "ccv-%"" --fields "Content View ID"`
for CCV in $CCVS
    do
        echo -e "$CCV"
        #hammer content-view publish --async --id "$CCV" --organization "$ORG"
        hammer content-view publish --id "$CCV" --organization "$ORG"
    done