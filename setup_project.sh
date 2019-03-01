#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 USER"
    exit 1
fi

USER=$1

echo "Creating projects for Network Rail"

# oc new-project nr-nexus --display-name="Network Rail Nexus"
oc new-project nr-jenkins --display-name="Network Rail Jenkins"
oc new-project nr-dev --display-name="Network Rail Dev"
oc new-project nr-test --display-name="Network Rail Test"
# oc new-project nr-prod --display-name="Network Rail Prod"

# oc policy add-role-to-user admin ${USER} -n nr-nexus
oc policy add-role-to-user admin ${USER} -n nr-jenkins