#!/bin/bash

# oc login master.rhpds311.openshift.opentlc.com

# Set Variables
JENKINS_PROJECT=nr-jenkins
echo "Setting up Jenkins project"


oc project $JENKINS_PROJECT


# TODO: we need to replace this with the S2I version
# oc process -f ./templates/jenkins-template.yml -p NAMESPACE=$JENKINS_PROJECT | oc create -f - -n $JENKINS_PROJECT

# S2I method
oc new-build jenkins:2~https://github.com/briangallagher/custom-jenkins.git --name=custom-jenkins -e GIT_SSL_NO_VERIFY=true -e OVERRIDE_PV_CONFIG_WITH_IMAGE_CONFIG=true -e OVERRIDE_PV_PLUGINS_WITH_IMAGE_PLUGINS=true -n nr-jenkins
oc new-app jenkins-persistent -p JENKINS_IMAGE_STREAM_TAG=custom-jenkins:latest -p NAMESPACE=nr-jenkins -p MEMORY_LIMIT=4Gi -p VOLUME_CAPACITY=10Gi -n nr-jenkins




# v3.11 may not be compatible with jenkins version - may need to look at v3.9
oc new-build --name=jenkins-slave-nodejs4-appdev -D $'FROM docker.io/openshift/jenkins-slave-nodejs-centos7:v3.11\nUSER root\nRUN yum -y install skopeo\nUSER 1001' -n nr-jenkins


# openshift3/jenkins-agent-nodejs-8-rhel7
# https://github.com/dudash/jenkins-slave-nodejs6
	# dudash/jenkins-slave-nodejs6

oc new-build --name=jenkins-slave-nodejs4-appdev -D $'FROM docker.io/openshift/jenkins-slave-nodejs-centos7:v3.11\nUSER root\nRUN yum -y install skopeo\nUSER 1001' -n nr-jenkins
oc new-build --name=jenkins-slave-nodejs4-appdev -D $'FROM docker.io/openshift/jenkins-slave-nodejs-centos7:v3.11\nUSER root\nRUN yum -y install skopeo\nUSER 1001' -n nr-jenkins


# Setup the Config Map for the node.js jenkins slave
# TODO: change this <label>maven-appdev</label> in the template to be more node.js 
oc new-app -f ./templates/jenkins-nodejs4-slave.yml -n nr-jenkins

# TODO: Need another slave config for node.js 6





# TODO: What about the plugins and config? 


# Notes
# I've remove the health and readiness checks from the Jenkins template as it seemed to be causing issues

# To copy the jenkins config from running jenkins
# oc cp jenkins-2-bkjgn:/var/lib/jenkins .
# oc cp <podName><path> <dest>


# Jenkins Slave images
# https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/openshift3/jenkins-agent-nodejs-8-rhel7
# https://access.redhat.com/containers/?tab=tech-details#/registry.access.redhat.com/openshift3/jenkins-slave-nodejs-rhel7
# https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7
# https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/openshift3/jenkins-agent-nodejs-8-rhel7


