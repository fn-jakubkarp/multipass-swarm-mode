# Troubleshoot

## Windows

### IPv4 'N/A' after running inject-dynamic-hosts.sh script

If after running ./scripts/inject-dynamic-hosts.sh the resulting hosts.ini file shows N/A in the IPv4 column:

1. Check your Virtualization Engine
This is a Windows-specific problem related to how Multipass communicates with different hypervisors. Run the following command to check your driver:
```sh
multipass get local.driver
```

If the result is virtualbox, you will need to change the driver to hyperv.
***NOTE: If using Windows 10/11 Home edition enabling hyperv will require running custom .bat script. You will be able to find one on the internet***

2. Change your driver to Hyper-V
```sh
multipass set local.driver=hyperv
```

