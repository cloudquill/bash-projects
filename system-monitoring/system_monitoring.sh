#!/bin/bash
#
# This script monitors and logs the CPU and Memory usage of a local system. It
# also sends out email alerts if one or more of the monitored metric is above
# a threshold

# Source send_mail script to use the forward_mail() function
source send_mail.sh

# Threshold values for CPU and Memory usage to trigger alerts
cpu_threshold=1
memory_threshold=20

# Capture system information and exit status in case of errors
user_cpu_usage=$(mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
mpstat_command_exit_status=$?

user_memory_usage=$(free --mega | awk 'NR==2{print $3*100/$2}')
free_command_exit_status=$?

# Check if the 'mpstat' and 'free' commands executed successfully
if [[ $mpstat_command_exit_status -ne 0 ]]; then
  echo "Error: Failed to execute 'mpstat' command."
  exit 1
fi

if [[ $free_command_exit_status -ne 0 ]]; then
  echo "Error: Failed to execute 'free' command."
  exit 1
fi

# Log system information to log file
echo -e "\nSystem information as at $(date)\nCPU Usage: ${user_cpu_usage}% \nMemory Usage: ${user_memory_usage}%" >> systemlog.txt

# Send an email if at least one metric is above the threshold
if [[ $user_cpu_usage > $cpu_threshold ]] || [[ $user_memory_usage > $memory_threshold ]]; then
  recipient="ifeanyiojukwu11@outlook.com"
  subject="System Monitoring Alert"

  # I ignored the indentation to eliminate unnecessary white spaces in the
  # email body.
  body="
System Information:

Hostname: $(hostname)
CPU Usage: ${user_cpu_usage}%
Memory Usage: ${user_memory_usage}%

One or more of these metrics are above the threshold value. Please review!"
  
  # Call email script
  forward_email "${recipient}" "${subject}" "${body}"

fi
