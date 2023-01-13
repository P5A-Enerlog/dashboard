# Tools to exchange data 
Here are some scripts used to send / retrieve data with the [EPF API](https://preprodapi.mde.epf.fr/measure.php?id=60)

# Send data
`csv_to_api.sh` was used to send former data that was collected on an SD card an stored on a CSV file. To be able to use this data on the dashboard, this script is sending it as JSON to the EPF API.  

## usage
To use it, execute the following command :  
`./csv_to_api.sh filename token`  
where, 
- **file name** is a string of the csv file to get data from
- **token** is the API token, to be authorized to send data to it


# Retrieve data
In order to analyze the data, `api_to_csv.sh` allows to download the data stored on the EPF API to a CSV file. You can set a custom time interval.

## usage
To use it, execute the following command :  
`./api_to_csv.sh filename date1 date2`   
where,  
- **file name** is a string of the csv file name to write data on, for example "DecemberData.csv"
- The data will be fetch between **date1** and one day before **date2** (date1<date2)  
  format: yyyy-mm-dd for example, 2022-12-02 is the 2nd day of Decemberin the year 2022
