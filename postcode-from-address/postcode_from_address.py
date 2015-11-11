#!/usr/bin/env python
# -*- coding: UTF8 -*-
# @See http://www.python.org/dev/peps/pep-0263

#######
# ABOUT
#######

# Script for fetching postcode for Finnish streed address.

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

# python postcode_from_address.py

# See:
# - http://www.verkkoposti.com/e3/postinumeroluettelo?streetname=Vuohikuja+12&postcodeorcommune=Vantaa

#################
# VERSION HISTORY
#################

# Version 1.0
# - Initial version.

# Import requests for making http requests.
import requests

# Import BeautifulSoup for handling html contents.
from BeautifulSoup import BeautifulSoup

# Import re for making regular experssions.
import re

# Import csv for reading data files.
import csv

# Import time for sleeping.
import time

with open('data.csv', 'r') as csv_file:
  index = 0
  csv_rows = csv.reader(csv_file, delimiter=',', quotechar='"')
  founds = []
  for row in csv_rows:
    city = row[0]
    address = row[1]
    if city == 'Esbo':
      city = 'Espoo'
    if city == 'Helsingfors':
      city = 'Helsinki'

    url = 'http://www.verkkoposti.com/e3/postinumeroluettelo?streetname=' + address + '&postcodeorcommune=' + city
    print '\033[1mSeeking:\033[0m ' + address + ', ' + city
    # print '\033[1mUrl:\033[0m ' + url
    html = requests.get(url, cookies={}, data={'streetname':address, 'postcodeorcommune':city})

    parsed_html = BeautifulSoup(html.text)
    try:
      table_rows = parsed_html.find('table', {'class':'hidden-xs'}).findAll('tr')
      if len(table_rows) == 2:
        table_cell = table_rows[1].findAll('td')[2]
        found = re.search('([0-9]{5})', table_cell.text).group(1)
        founds.append(found)
        print '...\033[1mOk\033[0m: ' + found
      else:
        founds.append('')
        print '...\033[1mError #1\033[0m'
    except:
      founds.append('')
      print '...\033[1mError #2\033[0m'

    index = index + 1
    time.sleep(1)
      # if (index > 2):
        # break

  print '\n' + str(founds)
  print '\n\033[1mAll done. Total of ' + str(index) + ' records. Enjoy!\033[0m'