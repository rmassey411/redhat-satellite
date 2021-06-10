#!/bin/sh

# Advise user of required params
echo -e "\e[5mTo provide organization name, pass -o with organizationname \e[0m"
echo -e "\e[5mTo provide life-cycle environment, pass -l lifecyclename \e[0m"

# Set cli args as variables
while getopts ":o:l:" arg; do
  case $arg in
    o) ORG=$OPTARG;;
    l) LC=$OPTARG;;
  esac
done

# Promote content-views
echo 'Promoting content views...'
CVS=`hammer --no-headers content-view list --organization "$ORG" --composite false --search "name ~ "cv-%"" --fields "Content View ID"`
for CV_ID in $CVS
    do
        CV_LATEST=`hammer --no-headers content-view version list --content-view-id "$CV_ID" --organization "$ORG" | awk '{print $6}' | head -n1`
        #hammer content-view version promote --async --organization "$ORG" --content-view-id "$CV" --to-lifecycle-environment "$LC" --version $CV_LATEST --force
        echo "Promoting cv-version $CV_LATEST for cv-id $CV_ID to lifecycle-environment $LC in the organization $ORG"
        hammer content-view version promote --organization "$ORG" --content-view-id "$CV_ID" --to-lifecycle-environment "$LC" --version $CV_LATEST --force
    done

# Promote composite content-views
echo 'Promoting composite content views...'
CCVS=`hammer --no-headers content-view list --organization "$ORG" --composite true --search "name ~ "ccv-%"" --fields "Content View ID"`
for CCV_ID in $CCVS
    do
        CCV_LATEST=`hammer --no-headers content-view version list --content-view-id "$CCV_ID" --organization "$ORG" | awk '{print $6}' | head -n1`
        #hammer content-view version promote --async --organization "$ORG" --content-view-id "$CCV" --to-lifecycle-environment "$LC" --version $CCV_LATEST
        echo "Promoting composite cv-version $CCV_LATEST for composite cv-id $CCV_ID to lifecycle-environment $LC in the organization $ORG"
        hammer content-view version promote --organization "$ORG" --content-view-id "$CCV_ID" --to-lifecycle-environment "$LC" --version $CCV_LATEST
    done
