#!/bin/bash

# Get data from EPF energylab API for enerlog project in json and transform it to CSV

# Usage: ./api_to_csv.sh filename date1 date2
# file name is a string of the csv file name to write data on
# The data will be fetch between date1 and one day before date2 (date1<date2)
# format: yyyy-mm-dd for example, 2022-12-02 is the 2nd day of Decemberin the year 2022

ids=(57 58 59 60 67 68 69 70 61 62 52 53)
len=${#ids[@]}
data=() # will store the json data for each sensor id
file=$1 
date1=$2
date2=$3

# create the output file
touch $file

# fetch data for each sensor id
for i in $(seq 0 $((len-1)))
do 
    id=${ids[$(($i))]}
    echo "getting data from sensor $id"
    data+=("$(curl -s https://preprodapi.mde.epf.fr/measure.php?id=$id | jq -r '[.[] | del(.general)]')")

    sleep 0.25
done

# Join all the data on the same json variable
all_data="$(echo ${data[@]}| jq -s '[.[][]]')" #join all ids data
echo "all data joined"

# Filter the dates between date1 and date2
filtered_data="$(echo $all_data | jq -r --arg date1 "$date1" --arg date2 "$date2" ' .[] | select(.created | (tostring > $date1) and (tostring < $date2)) | {"created": (.created | tostring | match("[0-9+-]+ +[0-9]+:[0-9]+") | .string ) , "id": .id_system_sensor ,"value": .value} ')"
echo "date filtered"

# Convert to CSV with id values as column names and save the result in the output file
echo $filtered_data | jq -nr 'reduce inputs as {$created, $value, $id} ({head: [], body: {}}; 
.head |= (.[index($id) // length] = $id) | .body[$created][$id] = $value)
| (.head | sort_by(tonumber)) as $head | ["created", $head[]], (.body | to_entries[] | [.key, .value[$head[]]])
| map(. // "nan") | join(",")' > $file
echo "converted to CSV"
