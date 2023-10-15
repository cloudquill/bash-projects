#!/bin/bash
#
# This script sends an email using provided argument which would be an email 
# text containing the email headers and message. The ssmtp utility with the 
# option -t tells it to read the input text for the headers and message. These 
# headers begin with keywords such as 'To', 'From' and 'Subject'. 
#
# Ensure to leave a space after defining the headers to begin the email body.
#
# So it seems cron cannot run the ssmtp command unless we include the full path 
# to the ssmtp binary. This is because cron operates in a limited environment.
#
# Apparently, the current usage of ssmtp below requires the use of the here 
# document (EOF)

forward_email(){

  /usr/sbin/ssmtp -t << EOF
  ${1}
EOF
}
