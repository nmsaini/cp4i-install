#!/bin/bash

if [ -z "$1" ]; then
	echo "Please provide the namespace for the subscriptions to be patched"
	exit 1
fi

NS=$1

# check if datapower operator is installed
oc -n $NS get sub datapower-operator > /dev/null
if [ $? -eq 0 ]; then
	oc -n $NS get sub datapower-operator -o yaml | \
	yq '.spec.source |= sub("ibm-operator-catalog", "ibm-datapower-operator-catalog")' | \
	oc replace -f -
fi

# check if apiconnect operator is installed
oc -n $NS get sub ibm-apiconnect > /dev/null
if [ $? -eq 0 ]; then
	oc -n $NS get sub ibm-apiconnect -o yaml | \
	yq '.spec.source |= sub("ibm-operator-catalog", "ibm-apiconnect-catalog")' | \
	oc replace -f -
fi

# check if appconnect operator is installed
oc -n $NS get sub ibm-appconnect > /dev/null
if [ $? -eq 0 ]; then
	oc -n $NS get sub ibm-appconnect -o yaml | \
	yq '.spec.source |= sub("ibm-operator-catalog", "appconnect-operator-catalogsource")' | \
	oc replace -f -
fi

# check if eventstreams operator is installed
oc -n $NS get sub ibm-eventstreams > /dev/null
if [ $? -eq 0 ]; then
	oc -n $NS get sub ibm-eventstreams -o yaml | \
	yq '.spec.source |= sub("ibm-operator-catalog", "ibm-eventstreams")' | \
	oc replace -f -
fi

# check if platform-navigator is installed
oc -n $NS get sub ibm-integration-platform-navigator > /dev/null
if [ $? -eq 0 ]; then
	oc -n $NS get sub ibm-integration-platform-navigator -o yaml | \
	yq '.spec.source |= sub("ibm-operator-catalog", "ibm-integration-platform-navigator-catalog")' | \
	oc replace -f -
fi

# check if mq operator is installed
oc -n $NS get sub ibm-mq > /dev/null
if [ $? -eq 0 ]; then
	oc -n $NS get sub ibm-mq -o yaml | \
	yq '.spec.source |= sub("ibm-operator-catalog", "ibmmq-operator-catalogsource")' | \
	oc replace -f -
fi

# check if common-svc is installed
oc -n $NS get sub ibm-common-service-operator-v3-ibm-operator-catalog-openshift-marketplace > /dev/null
if [ $? -eq 0 ]; then
	oc -n $NS get sub ibm-common-service-operator-v3-ibm-operator-catalog-openshift-marketplace -o yaml | \
	yq '.spec.source |= sub("ibm-operator-catalog", "opencloud-operators")' | \
	oc replace -f -
fi

# also change ibm-common-service subscriptions to the opencloud-operators
oc -n ibm-common-services get subs ibm-common-service-operator -o yaml |  yq '.spec.source |= sub("ibm-operator-catalog", "opencloud-operators")' | oc replace -f -
oc -n ibm-common-servicesget subs operand-deployment-lifecycle-manager-app -o yaml |  yq '.spec.source |= sub("ibm-operator-catalog", "opencloud-operators")' | oc replace -f -
oc -n ibm-common-servicesget sub ibm-namespace-scope-operator -o yaml |   yq '.spec.source |= sub("ibm-operator-catalog", "opencloud-operators")' | oc replace -f -

