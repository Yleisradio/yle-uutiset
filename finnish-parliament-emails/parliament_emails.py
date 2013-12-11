#!/usr/bin/env python
# -*- coding: UTF8 -*-
# @See http://www.python.org/dev/peps/pep-0263

#######
# ABOUT
#######

# Script for scraping Finnish parliament members emails.

########
# AUTHOR
########

# Teemo Tebest (teemo.tebest@gmail.com)

#########
# LICENSE
#########

# CC-BY-SA 4.0

#######
# USAGE
#######

# python parliament_email.py

# See:
# - http://www.eduskunta.fi/triphome/bin/hex3000.sh

#################
# VERSION HISTORY
#################

# Version 1.0
# - Initial version.

#############################################################

# Import pymongo for storing up values
import pymongo
# Import requests for making http requests.
import requests
# Import BeautifulSoup for handling html contents.
from BeautifulSoup import BeautifulSoup
# Import re for making regular experssions.
import re
# Import sys for reading arguments.
import sys

# Create mongodb connection
from pymongo import Connection
connection = Connection('localhost', 27017)

database = connection.parliament

table = database.members

if len(sys.argv) == 2:
  if sys.argv[1] == 'true':
    print '\033[1mRemoved all existing records!\033[0m\n'
    table.remove()

cookie = {}

data_added = 0
data_existed = 0

# First we get data from the pages that list the apartments. 
# Ex. http://www.vuokraovi.com/vuokra-asunnot?page=1
html = requests.get('http://www.eduskunta.fi/triphome/bin/hex3000.sh')
parsed_html = BeautifulSoup(html.text)
rows = parsed_html.find('table', {'class':'resultTable'}).findAll('tr')
row_index = 0
for row in rows:
  # Skip first row.
  row_index = row_index + 1
  if row_index == 1:
    continue
  column_index = 0
  columns = row.findAll('td')
  for column in columns:
    column_index = column_index + 1
    # Name column which includes the link information.
    if column_index == 1:
      name = column.find('a').text
      link = column.find('a')['href']
    # Push the data to db if doesn't exists.   
  if not table.find({'name':name}).count():
    data_added = data_added + 1
    # Push the collected data to db.
    table.insert({
      'name': name,
      'link': link,
      'email': '',
      'clean_name': '',
      'party': ''
    })
  else:
    data_existed = data_existed + 1

print '\033[1mNew records:\033[0m ' + str(data_added)
print '\033[1mExisting records:\033[0m ' + str(data_existed)

print '\n\033[1mWill now search for email data.\033[0m\n'

apartment_index = 0
# Second we get data from individual aparment pages.
# We need to do this while not all the information like build year
# is not available on the apartment listning page.
# Ex. http://www.vuokraovi.com/vuokra-asunto/helsinki/kalasatama/kerrostalo/yksio/484562?entryPoint=fromSearch&rentalIndex=1
print 'Fetching data for: ' + str(table.find({'email': ''}).count()) + ' parliament members.\n'
for parliament_member in table.find({'email': ''}):
  apartment_index = apartment_index + 1
  html = requests.get('http://www.eduskunta.fi/' + parliament_member['link'])
  parsed_html = BeautifulSoup(html.text)

  email = parsed_html.find('span', {'class':'emailAddress'})
  heading = parsed_html.find('h1')
  heading = heading.text.split(' / ')
  clean_name = heading[0]
  party = heading[1]

  try:
    # Update the existing database record
    # with the new data we've fetched.
    table.update({'name':parliament_member['name']}, {
      '$set': {
        'clean_name': clean_name,
        'party': party,
        'email': email.text.replace('[at]', '@')
      }
    })
    print 'Fetch data for ' + clean_name
  except:
    print '\n\033[1mFailed to fetch data for\033[0m ' + clean_name
  
print '\n\033[1mAll done! Bye bye.\n\033[0m'

# You can export the data from database with this kind of command.
# mongoexport --db parliament --collection members  --csv -f clean_name,email,party > data.csv