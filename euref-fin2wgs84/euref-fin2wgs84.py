#######
# ABOUT
#######

# Script for converting ETRS-TM35FIN coordinates to WGS84.

########
# AUTHOR
########

# Teemo Tebest (teemo.tebest@gmail.com)

#########
# LICENSE
#########

# CC-BY-SA 4.0 Yle Uutiset / Teemo Tebest

#######
# USAGE
#######

# python euref-fin2wgs84.py [filename]

# See:
#  - http://kansalaisen.karttapaikka.fi/kartanhaku/osoitehaku.html?lang=fi
#  - http://kansalaisen.karttapaikka.fi/koordinaatit/muunnos.html?x=541961&y=6982696&srsName=EPSG%3A3067&lang=fi

#################
# VERSION HISTORY
#################

# Version 1.2
# - Added filename argument.

# Version 1.1
# - Added mongodb functionality for caching results.

# Version 1.0
# - Initial version.

#############################################################

# Import csv for reading and writing csv files.
import csv
# Import urllib for reading contents over http.
import urllib
# Import time for sleep functionality.
import time
# Import BeautifulSoup for reading html files.
from bs4 import BeautifulSoup
# Import re for making regular expressions.
import re
# Import pymongo for storing up values
import pymongo
# Import sys for argument handling.
import sys

# Create mongodb connection
from pymongo import Connection
connection = Connection('localhost', 27017)

db = connection.gis
coordinates = db.euref_fin2wgs84

# Export is done with mongoexport.
export = 'false'
# mongoexport --db gis --collection euref_fin2wgs84 --csv -f north_wgs84,east_wgs84 >> data_wgs84.csv

# Read arguments.
if len(sys.argv) < 2:
  print("\033[1mProvide a file name.\033[0m\nUsage \"python convert.py [filename]\"")
  exit()
else:
  filename = sys.argv[1]

# Go through the data only if we are not exporting.
if export == 'false':
  # Read example_data.csv
  with open(filename, 'rb') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',', quotechar='"')
    row_number = 0
    column_names = []
    for row in csvreader:
      row_number = row_number + 1
      # Skip heading row but store the heading values.
      if row_number == 1:
        for column_name in row:
          column_names.append(column_name)
        continue
     
      # Create an unique row_id from row id. 
      row_id = row[0]

      ii = 0
      data = {}
      # Store all the column contained by the csv file.
      for column_data in row:
        data[column_names[ii]] = column_data
        ii = ii + 1

      # Set up and store the new data values.
      data['row_id'] = row_id
      data['north_wgs84'] = '0.0'
      data['east_wgs84'] = '0.0'

      # Check if data already is available in database.
      if coordinates.find({'row_id': row_id}).count() == 1:
        # Use the data available in the database.
        for values in coordinates.find({'row_id': row_id}):
          data['east_wgs84'] = values['east_wgs84']
          data['north_wgs84'] = values['north_wgs84']
        # Print out what we are doing.
        #print 'Row \033[1m' + str(row_number - 1) + ' already found from db\033[0m'

      # Otherwise we need to fetch the data from the API.
      else:
        # Remove any existing contents, just to be safe.
        coordinates.remove({'row_id': row_id})
        # Store coordinates.
        north = row[14]
        east = row[13]
        # If we have valid data get wgs84 values from Luomus API.
        if north != '0' and east != '0':
          # Fetch HTML document.
          url = 'http://kansalaisen.karttapaikka.fi/koordinaatit/muunnos.html?x=' + east + '&y=' +  north + '&srsName=EPSG%3A3067&lang=fi'
          # Parse HTML document.
          soup = BeautifulSoup(urllib.urlopen(url))

          # Get north coordinate from html tree.
          north_re = re.search("<td>([0-9]{2}\.[0-9]+)", str(soup.findAll('tr')[4].findAll('td')[1]))
          data['north_wgs84'] = north_re.group(1)

          # Get east coordinate from html tree.
          east_re = re.search("<td>([0-9]{2}\.[0-9]+)", str(soup.findAll('tr')[4].findAll('td')[2]))
          data['east_wgs84'] = east_re.group(1)

        # Put data to mongodb.
        coordinates.insert(data)

        # Print out what we are doing.
        print 'Row \033[1m' + str(row_number - 1) + ' added to db\033[0m\n' + row[0].decode("utf8", "ignore") + ': ' + data['north_wgs84'] + ',' + data['east_wgs84']
        
        # Sleep between requests for now overflowing the API.
        time.sleep(0.3)
        