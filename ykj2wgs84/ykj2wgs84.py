#######
# ABOUT
#######

# Script for converting YKJ coordinates to WGS84.

########
# AUTHOR
########

# Teemo Tebest (teemo.tebest@gmail.com)

#########
# LICENSE
#########

# CC-BY-SA 3.0

#######
# USAGE
#######

# python ykj2wgs84.py

# See:
#  - http://www.luomus.fi/projects/coordinateservice/info/

#################
# VERSION HISTORY
#################

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
# Import minidom for reading xml files.
from xml.dom import minidom
# Import pymongo for storing up values
import pymongo
# Import sys for argument handling.
import sys

# Create mongodb connection
from pymongo import Connection
connection = Connection('localhost', 27017)

db = connection.gis
coordinates = db.ykj2wgs84_koulut

export = 'false'
# Export is done with mongoexport.
# mongoexport --db gis --collection kkj2wgs84_koulut  --csv -f OSOITE,LKK,PKRYHMA,ONIMI,LVUOSI,ONUTS2U,OKIELI,SVUOSI,SKK,OKUNRYH,OMUOTO,north_wgs84,OMIST,tilv,ONUTS3,OLO,oikoord,OPPLIS,OPPYHT,PSNRO,PTOIMIP,OKUN,east_wgs84,OPPESI,KOSOITE,TUNN,OSEUTU,opkoord,UTUNN,OLTYP,JARJNIM,OKUNIM,JARJ,TOL2002,school_id,SAIR,OPPLUK,OPP79,_id,OPP16 >> data_wgs84.csv

# Go through the data only if we are not exporting.
if export == 'false':
  # Read example_data.csv
  with open('example_data.csv', 'rb') as csvfile:
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
     
      # Create an unique school_id from year and id information. 
      school_id = row[0] + row[1]

      ii = 0
      data = {}
      # Store all the column contained by the csv file.
      for column_data in row:
        data[column_names[ii]] = column_data
        ii = ii + 1

      # Set up and store the new data values.
      data['school_id'] = school_id
      data['north_wgs84'] = '0.0'
      data['east_wgs84'] = '0.0'

      # Check if data already is available in database.
      if coordinates.find({'school_id': school_id}).count() == 1:
        # Use the data available in the database.
        for values in coordinates.find({'school_id': school_id}):
          data['east_wgs84'] = values['east_wgs84']
          data['north_wgs84'] = values['north_wgs84']
        # Print out what we are doing.
        #print 'Row \033[1m' + str(row_number - 1) + ' already found from db\033[0m'

      # Otherwise we need to fetch the data from the API.
      else:
        # Remove any existing contents, just to be safe.
        coordinates.remove({'school_id': school_id})
        # Store coordinates.
        if row[22] and row[23]:
          # Column 22 contains east coordinates.
          if row[22][0] == '3':
            east = row[22]
            north = row[23]
          # Column 23 contains east coordinates.
          else:
            east = row[23]
            north = row[22]

        # If we know that we have flaw data then 
        # set coordinates to dummy values.
        if east == '9999999' or east == '9999999.99' or east == '':
          east = '0'
        if north == '9999999' or north == '9999999.99' or north == '':
          north = '0'

        # If we have valid data get wgs84 values from Luomus API.
        if north != '0' and east != '0':
          # Fetch XML document
          url = 'http://www.luomus.fi/projects/coordinateservice/?orig_system=ykj&north=' + north + '&east=' + east
          # Parse XML document.
          dom = minidom.parse(urllib.urlopen(url))
          # Get north coordinate.
          itemlist = dom.getElementsByTagName('north')
          data['north_wgs84'] = itemlist[0].firstChild.nodeValue
          # Get east coordinate.
          itemlist = dom.getElementsByTagName('east') 
          data['east_wgs84'] = itemlist[0].firstChild.nodeValue

        # Put data to mongodb.
        coordinates.insert(data)

        # Print out what we are doing.
        print 'Row \033[1m' + str(row_number - 1) + ' added to db\033[0m\n' + row[2].decode("utf8", "ignore") + ': ' + data['north_wgs84'] + ',' + data['east_wgs84']
        
        # Sleep between requests for now overflowing the API.
        time.sleep(0.3)