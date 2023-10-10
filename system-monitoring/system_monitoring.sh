#!/bin/bash
#
# This script monitors and logs the CPU and Memory usage of a local system

# Capture system information and exit status in case of errors
user_cpu_usage=$(mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
mpstat_command_exit_status=$?

user_memory_usage=$(free --mega | awk 'NR==2{print $3*100/$2}')
free_command_exit_status=$?

# Check if the 'mpstat' command executed successfully
if [[ $mpstat_command_exit_status -ne 0 ]]; then
  echo "Error: Failed to execute 'mpstat' command."
  exit 1
fi

# Check if the 'free' command executed successfully
if [[ $free_command_exit_status -ne 0 ]]; then
  echo "Error: Failed to execute 'free' command."
  exit 1
fi

# Log system information to log file
echo -e "\nSystem information as at $(date)\nCPU Usage: ${user_cpu_usage}% \nMemory Usage: ${user_memory_usage}%" >> systemlog.txt
