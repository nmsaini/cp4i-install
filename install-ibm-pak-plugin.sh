#!/bin/bash

# more info https://github.com/IBM/ibm-pak#download-and-verify-software 
#
# skopeo list-tags docker://cp.icr.io/cpopen/cpfs/ibm-pak
#
PAK_VERSION=v1.15.2
#
# check podman or docker installed
if ! ((command -v podman >/dev/null) || (command -v docker >/dev/null))
then
	echo "error: need podman or docker installed...."
	exit 1
fi

# since we are installing ibm-pak we need to make sure we are root
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

# 1 of them is installed check podman
if (command -v podman >/dev/null)
then
	id=$(podman create cp.icr.io/cpopen/cpfs/ibm-pak:$PAK_VERSION - )
	podman cp $id:/ibm-pak-plugin plugin-dir
	podman rm -v $id
	cd plugin-dir
	tar -xvf oc-ibm_pak-linux-amd64.tar.gz
	cp oc-ibm_pak-linux-amd64 /usr/local/bin/oc-ibm_pak
else
	id=$(docker create cp.icr.io/cpopen/cpfs/ibm-pak:$PAK_VERSION - )
	docker cp $id:/ibm-pak-plugin plugin-dir
	docker rm -v $id
	cd plugin-dir
	tar -xvf oc-ibm_pak-linux-amd64.tar.gz
	cp oc-ibm_pak-linux-amd64 /usr/local/bin/oc-ibm_pak
fi

echo "ibm-pak installed...done"

