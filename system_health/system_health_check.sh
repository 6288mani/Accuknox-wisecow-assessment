#!/bin/bash

# Configuration
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=90
LOG_FILE="/var/log/system_health.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Function to check CPU usage
check_cpu() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        echo "$DATE - CPU usage is at ${cpu_usage}% (Threshold: ${CPU_THRESHOLD}%)"
        echo "$DATE - CPU usage is at ${cpu_usage}% (Threshold: ${CPU_THRESHOLD}%)" >> $LOG_FILE
    fi
}

# Function to check memory usage
check_memory() {
    local memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$DATE - Memory usage is at ${memory_usage}% (Threshold: ${MEMORY_THRESHOLD}%)"
        echo "$DATE - Memory usage is at ${memory_usage}% (Threshold: ${MEMORY_THRESHOLD}%)" >> $LOG_FILE
    fi
}

# Function to check disk space usage
check_disk() {
    local disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    if (( disk_usage > DISK_THRESHOLD )); then
        echo "$DATE - Disk space usage is at ${disk_usage}% (Threshold: ${DISK_THRESHOLD}%)"
        echo "$DATE - Disk space usage is at ${disk_usage}% (Threshold: ${DISK_THRESHOLD}%)" >> $LOG_FILE
    fi
}

# Function to check running processes
check_processes() {
    local process_count=$(ps aux | wc -l)
    local max_processes=500
    if (( process_count > max_processes )); then
        echo "$DATE - Number of running processes is at ${process_count} (Threshold: ${max_processes})"
        echo "$DATE - Number of running processes is at ${process_count} (Threshold: ${max_processes})" >> $LOG_FILE
    fi
}

# Main script execution
echo "Running system health checks..."
check_cpu
check_memory
check_disk
check_processes
