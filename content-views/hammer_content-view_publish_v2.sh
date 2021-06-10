#!/bin/sh

CCVS=`hammer --no-headers content-view list --organization "CS" --composite true --search "name ~ "ccv-%"" --fields "Content View ID"`
for CCV in $CCVS
    do
        CVS=`hammer --no-headers content-view info --organization CS --name ccv-rhel-7server --fields "components" | grep -i name | awk '{print $2}'`
        echo 'Publishing content views...'
        for CV in $CVS
            do
                echo -e "$CV"
                hammer content-view publish --id "$CV" --organization "$ORG"
            done
        echo 'Publishing composite content views...'
        hammer content-view publish --id "$CCV" --organization "$ORG"
    done
