#!/bin/bash

# Send csv data to EPF energylab API for Enerlog project

# The previous experiment was collecting data on an SD card in a CSV file
# For the next experiments, it is directly sent to the API via WiFi where it is stored in a JSON format
# The dashboard needs to fetch the data from the API
# Thus, to make firsts test on the dashboard, data is needed to be accessible from the API
# This program read the CSV file and will send the data to the EPF API
# The time will be wrong but it is only for testing data display

# Usage: ./csv_to_api.sh filename token
# file name is a string of the csv file to get data from
# token is the API token

# upper tube T, upper tube H, lower tube T, lower tube H, upper air layer T, upper air layer H, lower air layer T, lower air layer H, anem lower, anem upper, thermocouple upper, thermocouple lower, pyranometer
# 58, 57, 60, 59, 68, 67, 70, 69, 55, 53, 61, 62, 52
ids=(58 57 60 59 68 67 70 69 55 53 61 62 52)
len=${#ids[@]}
file=$1 #"PREM.csv"
token=$2 # API token


cat $file | while read line
do
    for i in $(seq 1 $len)
    do 
 	value=$(echo $line | cut -d',' -f$i)
	id=${ids[$(($i-1))]}
	#echo $id $value
	curl -d "id_system_sensor=$id&value=$value&token=$token" -X POST http://192.168.139.27/add_measure.php
	sleep 0.25
	
    done
done
