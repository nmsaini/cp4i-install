#!/bin/bash

# more info https://github.com/IBM/ibm-pak#download-and-verify-software 
# download directly instead of docker 
# wget https://github.com/IBM/ibm-pak/releases/latest/download/oc-ibm_pak-linux-amd64.tar.gz
# curl -sL https://github.com/IBM/ibm-pak/releases/latest/download/oc-ibm_pak-linux-amd64.tar.gz | tar zx && mv oc-ibm_pak-linux-amd64 /usr/local/bin/oc-ibm_pak && oc ibm-pak --version
# mv oc-ibm_pak-linux-amd64 /usr/local/bin/oc-ibm_pak
# 
# skopeo list-tags docker://cp.icr.io/cpopen/cpfs/ibm-pak
#
if [ "$EUID" -ne 0 ]
then 
	echo "Please run as root"
	exit 1
fi

# check to see if ibm-pak is installed
oc ibm-pak --version > /dev/null
if [ $? -eq 0 ]; then
	echo "ibm-pak plugin already installed"
	echo "nothing to do"
	exit 1
fi

curl -sL https://github.com/IBM/ibm-pak/releases/latest/download/oc-ibm_pak-linux-amd64.tar.gz | tar zx
mv oc-ibm_pak-linux-amd64 /usr/local/bin/oc-ibm_pak

verInstalled=$(oc ibm-pak --version)
echo "ibm-pak version $verInstalled installed...done"
