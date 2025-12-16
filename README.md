# DynamicDNSUpdate

Script to update AWS Route53 record

## Description

This script checks the current public IP and updates AWS Route53 record if IP address change detected.

## Build

### Build container

```console
 $ cd /path/to/DynamicDNSUpdate
 $ sudo docker image build -t ddns-update .
```

## Author

Taku Izumi
