#!/bin/bash

# change all instances of ibm-operator-catalog to opencloud-operators
#
oc -n ibm-common-services get operandregistry common-service -o json | \
	jq '(.spec.operators[] | select(.sourceName == "ibm-operator-catalog")).sourceName|="opencloud-operators"' | \
	oc replace -f -

