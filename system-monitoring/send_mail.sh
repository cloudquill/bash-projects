#!/bin/bash
#
# This script sends an email using provided parameters. The script is sourced 
# in the system_monitoring.sh script so it can use the forward_email() 
# function.

forward_email(){
recipient=$1
subject=$2
body=$3

echo -e "From: cloudquill\nTo: $recipient\nSubject: $subject\n\n$body" | sendmail -t
}
