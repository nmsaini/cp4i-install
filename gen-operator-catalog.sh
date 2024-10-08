#!/bin/bash
# you can get the case name from https://github.com/IBM/cloud-pak/tree/master/repo/case
# if don't give the version it will get the latest catalog version on the get
# however version is required for generate mirror-manifests command
#
export ARCH=amd64
CATFILE=catalog.2022.2.txt

if [ ! -z $1 ] 
then
   CATFILE=$1
fi

if [ ! -e $CATFILE ]
then
   echo ERR
   echo -e "File $CATFILE doesn't exsist....exiting!"
   echo
   exit -1
fi

echo " -------------- get operator versions ---------------"
# get the desired operator
cat ${CATFILE} | grep -v "^#" | while read -r case version
do
  echo "oc ibm-pak get $case --version $version"
  oc ibm-pak get $case --version $version
done 

echo
echo " -------------- generate manifests file ---------------"
# generate the catalog sources
cat ${CATFILE} | grep -v "^#" | while read -r case version
do
  echo "oc ibm-pak generate mirror-manifests $case icr.io --version $version"
  oc ibm-pak generate mirror-manifests $case icr.io --version $version
done 

# you need to apply both catalog-sources.yaml + catalog-sources-${ARCH}.yaml
#
echo
echo "******************************************************************"
echo "********** apply the following operator manifests ****************"
echo "******************************************************************"
for cs in $(find ~/.ibm-pak/data/mirror -name catalog-sources*.yaml)
do
	echo oc apply -f $cs
done
echo "******************************************************************"
echo "done"
