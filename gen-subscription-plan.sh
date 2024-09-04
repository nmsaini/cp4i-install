#!/bin/bash

if [ -z $NS ]; then
	echo "NAMESPACE NS not setup....exiting" 
	echo "use: export NS=namespace"
	echo "and then re-run"
	exit
fi

SUBFILE=subscription-plan.txt

if [ ! -z $1 ] 
then
   SUBFILE=$1
fi

if [ ! -e $SUBFILE ]
then
   echo ERR
   echo -e "File $SUBFILE doesn't exsist....exiting!"
   echo
   exit -1
fi

# before you proceed for individual namespace we need an operatorgroup
if [ "$NS" != "openshift-operators" ]; then
echo " --------- generating an operator group ----------- "
echo "
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: ibm-integration-operatorgroup
  namespace: $NS
spec:
  targetNamespaces:
  - $NS
" | oc apply -f -
fi

echo " -------------- get operator, catalog, channel ---------------"
# get the operator, catalog, and channel
cat ${SUBFILE} | grep -v "^#" | while read -r sub catalog channel
do
  if [ -z $channel ]; then
	continue;
  fi
echo "
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: $sub
  namespace: $NS
spec:
  channel: $channel
  installPlanApproval: Automatic
  name: $sub
  source: $catalog
  sourceNamespace: openshift-marketplace
" | oc apply -f -
done

