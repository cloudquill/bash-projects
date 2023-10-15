#!/bin/bash
#
# This script monitors and logs the CPU and Memory usage of a local system. It
# also sends out email alerts if one or more of the monitored metric is above
# a threshold.

# Source send_mail script to use the forward_mail() function. More information
# on how this works is in the send_mail script.
source send_mail.sh

# Store the name of this script for error reporting.
filename=$(basename "$0")

# Threshold values for CPU and Memory usage to trigger alerts
cpu_threshold=1
memory_threshold=20

# Capture system information and exit status in case of errors.
#
# The 12th field of the command 'mpstat' list the percentage of cpu that is
# idle. Using the awk command with regex to extract the decimal part and
# subtracting from 100 gives us the percentage that is being used.
user_cpu_usage=$(mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
mpstat_command_exit_status=$?

# The free command lists the hard disk and RAM information such as the total
# or used memory. Then we calculate the percentage of used hard disk space 
# with the second and third fields in the second row.
user_memory_usage=$(free --mega | awk 'NR==2{print $3*100/$2}')
free_command_exit_status=$?

# Check if the 'mpstat' and 'free' commands executed successfully.
# Otherwise send an error message to an admin to notify them.
if [[ $mpstat_command_exit_status -ne 0 ]]; then
  email_txt="An error occurred when running the 'mpstat' command for ${filename} file. Please review!"
  forward_email "${email_txt}"
  exit 1
fi

if [[ $free_command_exit_status -ne 0 ]]; then
  email_txt="An error occurred when running the 'free' command for ${filename} file. Please review!"
  forward_email "${email_txt}"
  exit 1
fi

# Log system information to log file
echo -e "\nSystem information as at $(date)\nCPU Usage: ${user_cpu_usage}% \nMemory Usage: ${user_memory_usage}%" >> systemlog.txt

# Send an email if at least one metric is above the threshold
if [[ $user_cpu_usage > $cpu_threshold ]] || [[ $user_memory_usage > $memory_threshold ]]; then

  # I ignored the indentation to eliminate unnecessary white spaces in the
  # email body.
  email_txt="
To: ifeanyiojukwu11@outlook.com
From: $(hostname)
Subject: System Monitoring Alert
X-Custom-Header: Custom value

System Information:

CPU Usage: ${user_cpu_usage}%
Memory Usage: ${user_memory_usage}%

One or more of these metrics are above the threshold value. Please review!"
  
  # Call the forward_email() function with email_txt as an argument.
  forward_email "${email_txt}"

fi
