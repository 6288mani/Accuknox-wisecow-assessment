#!/bin/bash

# Configuration
APPLICATION_URL="${{secreats.URL_CONFIG}}"   # URL of the application to check
EXPECTED_STATUS_CODE=200                           # Expected HTTP status code for 'up' status
LOG_FILE="/var/log/application_uptime.log"          # Log file to record the status
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Function to check the application's status
check_application_status() {
    # Make a request to the application and get the HTTP status code
    http_status=$(curl -o /dev/null -s -w "%{http_code}" "$APPLICATION_URL")

    # Log the status and check if it matches the expected status code
    if [ "$http_status" -eq "$EXPECTED_STATUS_CODE" ]; then
        echo "$DATE - Application is UP (HTTP Status Code: $http_status)"
        echo "$DATE - Application is UP (HTTP Status Code: $http_status)" >> $LOG_FILE
    else
        echo "$DATE - Application is DOWN (HTTP Status Code: $http_status)"
        echo "$DATE - Application is DOWN (HTTP Status Code: $http_status)" >> $LOG_FILE
    fi
}

# Main script execution
echo "Checking application status..."
check_application_status
