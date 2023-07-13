#!/bin/bash
oc get pods -A --no-headers | grep ibm-common-service-operator | 
while read -r ns pod ignore
do 
	echo oc -n $ns delete pod $pod
	oc -n $ns delete pod $pod > /dev/null
done
