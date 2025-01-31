# cp-access-log.sh
# This script downloads the file 'web-server-access-log.txt.gz'
# from "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/".

# The script then extracts the .txt file using gunzip.

# The .txt file contains the timestamp, latitude, longitude 
# and visitor id apart from other data.

# Transforms the text delimeter from "#" to "," and saves to a csv file.
# Loads the data from the CSV file into the table 'access_log' in PostgreSQL database.

#Extract Phase
echo "Extracting Data"
wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/web-server-access-log.txt.gz"

#Unzip the file to extract
gunzip -f web-server-access-log.txt.gz

#Extract the columns
cut -d"#" -f1-4 web-server-access-log.txt > extracted-data.txt


#Transorm phase

echo "Transforming Data"
tr "#" "," < extracted-data.txt > transformed-data.csv

#Load phase

echo "Loading Data"

#COPY table_name FROM 'filename' DELIMITERS 'delimiter_character' FORMAT;

echo "\c template1\;\COPY access_log FROM 'home/project/transformed-data.csv' DELIMITERS ',' CSV HEADER;" | psql --username=postgres --host=localhost