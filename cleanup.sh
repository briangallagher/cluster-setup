#!/bin/bash

echo "Removing all Network Rail Projects"
oc delete project nr-nexus
oc delete project nr-jenkins
