#!/bin/bash

# oc login master.rhpds311.openshift.opentlc.com

# Set Variables
JENKINS_PROJECT=nr-jenkins
echo "Setting up Jenkins project"

oc project $JENKINS_PROJECT

# S2I method
oc new-build jenkins:2~https://github.com/briangallagher/custom-jenkins.git --name=custom-jenkins -e GIT_SSL_NO_VERIFY=true -e OVERRIDE_PV_CONFIG_WITH_IMAGE_CONFIG=true -e OVERRIDE_PV_PLUGINS_WITH_IMAGE_PLUGINS=true -n $JENKINS_PROJECT
oc new-app jenkins-persistent -p JENKINS_SERVICE_NAME=nrjenkins -p JENKINS_IMAGE_STREAM_TAG=custom-jenkins:latest -p NAMESPACE=$JENKINS_PROJECT -p MEMORY_LIMIT=4Gi -p VOLUME_CAPACITY=10Gi -n $JENKINS_PROJECT


# v3.11 may not be compatible with jenkins version - may need to look at v3.9
oc new-build --name=jenkins-slave-nodejs4-appdev -D $'FROM docker.io/openshift/jenkins-slave-nodejs-centos7:v3.11\nUSER root\nRUN yum -y install skopeo\nUSER 1001' -n $JENKINS_PROJECT
oc new-build --name=jenkins-slave-nodejs6-appdev -D $'FROM docker.io/dudash/jenkins-slave-nodejs6:latest\nUSER root\nRUN yum -y install skopeo\nUSER 1001' -n $JENKINS_PROJECT
oc new-build --name=jenkins-slave-nodejs8-appdev-test -D $'FROM registry.access.redhat.com/openshift3/jenkins-agent-nodejs-8-rhel7:v3.11' -n $JENKINS_PROJECT
# Issue with below, skopeo package not available. Only need one image to have skopeo.
# oc new-build --name=jenkins-slave-nodejs8-appdev -D $'FROM registry.access.redhat.com/openshift3/jenkins-agent-nodejs-8-rhel7:v3.11\nUSER root\nRUN yum -y install skopeo\nUSER 1001' -n $JENKINS_PROJECT


# Setup the Config Map for the node.js jenkins slave
oc new-app -f ./templates/jenkins-nodejs4-slave.yml -n $JENKINS_PROJECT
oc new-app -f ./templates/jenkins-nodejs6-slave.yml -n $JENKINS_PROJECT
oc new-app -f ./templates/jenkins-nodejs8-slave.yml -n $JENKINS_PROJECT

