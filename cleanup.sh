#!/bin/bash

echo "Removing all Network Rail Projects"
# oc delete project nr-nexus
oc delete project nr-jenkins
oc delete project nr-dev
oc delete project nr-test
# oc delete project nr-prod

oc delete is --all