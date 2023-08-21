# cp4i migrating from a global catalog

Refer to [2022.2.1 docs](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.2?topic=upgrading-moving-specific-catalog-sources-each-operator)

## Step 1. Install ibm-pak plugin to ocp
```
./install-ibm-pak-plugin.sh
```

## Step 2. Generate your operator manifest files
```
./gen-operator-catalog.sh catalog.2022.2.txt
```
At the end of the script execution it will show you a list of sources to apply to your environment.
You will need to copy and paste that text into a shell to execute. 🛑 DO NOT COPY this output. This is just a sample. You need to copy from your own execution output!

```
******************************************************************
********** apply the following operator manifests ****************
******************************************************************
oc apply -f /root/.ibm-pak/data/mirror/ibm-integration-platform-navigator/1.7.11/catalog-sources.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-integration-asset-repository/1.5.10/catalog-sources-linux-amd64.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-integration-operations-dashboard/2.6.12/catalog-sources-linux-amd64.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-apiconnect/4.0.4/catalog-sources.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-apiconnect/4.0.4/catalog-sources-linux-amd64.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-appconnect/5.0.8/catalog-sources.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-mq/2.0.12/catalog-sources.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-eventstreams/3.2.1/catalog-sources.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-datapower-operator/1.6.8/catalog-sources-linux-amd64.yaml
oc apply -f /root/.ibm-pak/data/mirror/ibm-aspera-hsts-operator/1.5.9/catalog-sources.yaml
******************************************************************
```
now validate the new catalog sources.
```
oc -n openshift-marketplace get catalogsources
```

## Step 3. Delete the old global catalog
```
oc -n openshift-marketplace delete catalogsource ibm-operator-catalog
```
when this is done, a bunch of your current subscriptions will become unhealthy as the source of their subscritions are now gone. 
In the next steps you will need to patch your environment and repoint those subscriptions to the new catalogsource.

## Step 4. Delete the running ibm-common-service-operator pods from all namespaces
```
./delete-comsvc-operator-pods.sh
```

## Step 5. Patch the operandregistry with the new catalogsource names
```
./patch-commsvc-operandregistry.sh
```

## Step 6. Patch the subscriptions source catalog names to the new catalog names
Run the patch command for each namespace that contains the operator subscriptions
```
./patch-op-subscriptions-catalog.sh cp4i
```
This script assumes ibm-common-services under the covers

## Step 7. Validate all subscriptions are healthy
If not all subscriptions in all namespaces are healthy (or showing errors), you will have to patch them manually.
