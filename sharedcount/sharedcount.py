#######
# ABOUT
#######

# Script for fetching social media share counts from sharedcount.com.

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

# python sharedcount.py

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
# Import json for reading json files.
import json
# Import re for making regular expressions.
import re
# Import pymongo for storing up values
import pymongo
# Import sys for argument handling.
import sys

# Create mongodb connection
from pymongo import Connection
connection = Connection('localhost', 27017)

db = connection.some
shared_data = db.sharedcount

export = 'false'

# Export is done with mongoexport.
# mongoexport --db some --collection sharedcount --csv -f facebook_total,facebook_comment,facebook_like,facebook_share,twitter,googleplus > data_output.csv

# Go through the data only if we are not exporting.
if export == 'false':
  # Read data.csv
  with open('data.csv', 'rb') as csvfile:
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
     
      ii = 0
      data = {}
      # Store all the column contained by the csv file.
      for column_data in row:
        data[column_names[ii]] = column_data
        ii = ii + 1

      # URL's are in 4th column.
      href = row[3]

      # Get SharedCount data.
      url = 'http://api.sharedcount.com/?url=' + href
      json_data = json.load(urllib.urlopen(url))
      data['facebook_total'] = json_data['Facebook']['total_count'];
      data['facebook_comment'] = json_data['Facebook']['comment_count'];
      data['facebook_like'] = json_data['Facebook']['like_count'];
      data['facebook_share'] = json_data['Facebook']['share_count'];
      data['twitter'] = json_data['Twitter'];
      data['googleplus'] = json_data['GooglePlusOne'];
          
      # Put data to mongodb.
      shared_data.insert(data)

      # Print out what we are doing.
      print 'Row \033[1m' + str(row_number - 1) + ' added to db\033[0m\n' + row[1].decode("utf8", "ignore")

      # Sleep between requests for now overflowing the API.
      time.sleep(0.3)
