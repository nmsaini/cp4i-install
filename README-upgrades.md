# On-Going version upgrades
update the catalog text file with newer versions and re-run the script
```
./gen-operator-catalog.sh catalog.2022.2.txt
```

At the end of the script execution it will show you a list of sources to apply to your environment. 

Newer versions are automatically installed as the subscriptions are all "Update approval" set to "automatic".
You now control what versions are installed by applying newer manifest files to the catalogsource and not simply because there is a new versions available in the global catalog.
