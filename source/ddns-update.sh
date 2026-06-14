#!/bin/sh

#****************************************************************************
#    ddns-update.sh - script to update AWS Route53 record
#    version: 2.2.0
#****************************************************************************

## Variables
APP_NAME='ddns-update.sh'
APP_DATA_PATH='/opt/ddns-update'

IP_INFO_WEB='v4.api.ipinfo.io/ip'
IP_DATA_FILE=$APP_DATA_PATH/data/current_ip.dat

## Functions
function log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') ${APP_NAME}: $@"
}

## Main routine

# Sanity check
if !(type jq > /dev/null 2>&1) ||
   !(type curl > /dev/null 2>&1) ||
   !(type $CLI53 > /dev/null 2>&1); then
   echo "Some commands are missing"
   exit 1; 
fi

# ENV check
if [ -z "$DNS_ZONE" ] ||
   [ -z "$AWS_ACCESS_KEY_ID" ] ||
   [ -z "$AWS_SECRET_ACCESS_KEY" ] ; then
   log "Some DNS data are missing"
   exit 1
fi
if [ -z "$CLI53" ] ; then
    CLI53=/bin/cli53
fi

# Get old IP address
if [ -f $IP_DATA_FILE ]; then
    OLD_IP=`cat $IP_DATA_FILE`
else
    OLD_IP='0.0.0.0'
fi

# Get current IP address
CURRENT_IP=`curl -sS $IP_INFO_WEB`
if [ -n "$CURRENT_IP" ]; then
    echo $CURRENT_IP > $IP_DATA_FILE
else
    log "CURRENT IP: FAILED"
    exit 1
fi

# Check if IP is changed
if [ "$OLD_IP" == "$CURRENT_IP" ]; then
    log "CURRENT IP: $CURRENT_IP"
    exit 0
else
    log "IP CHANGED: $OLD_IP to $CURRENT_IP"
fi

# Update Route53
$CLI53 rrcreate --replace $DNS_ZONE "* A $CURRENT_IP"
if [ $? == 0 ]; then
    log "UPDATE ROUTE53 RECORD: SUCCESS" 
else
    log "UPDATE ROUTE53 RECORD: FAILED"
fi

