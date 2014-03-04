#!/usr/bin/env python
# -*- coding: UTF8 -*-
# @See http://www.python.org/dev/peps/pep-0263

#######
# ABOUT
#######

# Script for reverse geocoding coordinate data.

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

# python reverse_geocode.py [filename]

# See:
# - http://yle.fi/uutiset/merkitse_risteys_karttaan_missa_olit_jaada_auton_alle/7042073

#################
# VERSION HISTORY
#################

# Version 1.0
# - Initial version.

#############################################################


# Import sys.
import sys

if len(sys.argv) < 2:
  print("\033[1mProvide a filename.\033[0m\nUsage \"python reverse_geocode.py [filename]\"")
  exit()
else:
  filename = sys.argv[1]

# Import pymongo for storing up values.
import pymongo

# Create mongodb connection.
from pymongo import Connection
connection = Connection('localhost', 27017)
database = connection.gis
table = database.reverse_geocode

if len(sys.argv) == 3:
  if sys.argv[2] == 'true':
    print '\033[1mRemoved all existing records!\033[0m\n'
    table.remove()

# Import csv.
import csv

# Import geocoder. (http://code.xster.net/pygeocoder/wiki/Home)
from pygeocoder import Geocoder

# Import hashlib.
import hashlib
m = hashlib.md5()

# Init counters.
data_added = 0
data_existed = 0
data_failed = 0

# Open data file
with open(filename, 'r') as csv_file:
  print '\033[1mReverse geocoding coordinates from "' + filename + '"\033[0m\n'
  # Init index value.
  index = 0
  csv_rows = csv.reader(csv_file, delimiter=',', quotechar='"')
  for row in csv_rows:
    if index != 0:
      # Check if coordinate data is already geocored.
      m.update(row[1])
      if not table.find({'cid': m.hexdigest()}).count():
        # Remove the existing record.
        table.remove({'cid': m.hexdigest()})
        # Split coordinate information to latitude and longitude.
        coordinates = row[1].split(',')
        # Fetch address based on coordinates.
        try:
          geocoder = Geocoder.reverse_geocode(float(coordinates[0]), float(coordinates[1]))
          cid = m.hexdigest()
          data_added = data_added + 1
        except:
          geocoder = 'Ei osoitetta'
          cid = ''
          data_failed = data_failed + 1
        # Store data to database.
        table.insert({
          'cid': cid,
          'timestamp': row[0], 
          'coordinates': row[1], 
          'lat': float(coordinates[0]), 
          'lng': float(coordinates[1]),
          'geometry': '<Point><coordinates>' + coordinates[1] + ',' + coordinates[0] + '</coordinates></Point>'
        })
      else:
        data_existed = data_existed + 1

      # Output every 50th request.
      if (index % 50) == 0:
        print 'Geocoded ' + str(index) + ' coordinates so far.'

    # Increment index value.
    index = index + 1

print '\033[1mNew records:\033[0m ' + str(data_added)
print '\033[1mExisting records:\033[0m ' + str(data_existed)
print '\033[1mFailed records:\033[0m ' + str(data_failed)

print '\n\033[1mAll done! Bye bye.\n\033[0m'

# You can export the data from database with this kind of command.
# mongoexport --db gis --collection reverse_geocode --csv -f timestamp,geometry,coordinates,address,lat,lng > data.csv